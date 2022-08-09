%%% This script combines all the previous controllers (collocated, IFF and
%%% H-inf) and with this defined structure it tries to find an optimal
%%% gains in the gain matrix.

clear

%% Define the plant
load linsys
minsys = ss(linsys,'min');

%% Check the stability
% close all
% pzplot(minsys)

%%
nio = 6; % number of collocated control loops
G = minsys; %...create linear state-space plant G

ny = nio; nu = nio;
nz = 6; % 6DOF velocities of the top platform
nw = 12; % 12 disturbance inputs

%% Define tunable controller (negative diagonal integral feedback)
C0ss = tunableSS('C0',nio,nio,nio);

C0ss.A.Value = zeros(nio); C0ss.A.Free = zeros(nio);
C0ss.B.Value = -eye(nio);  C0ss.B.Free = zeros(nio);
C0ss.C.Value =  eye(nio);  C0ss.C.Free = ones(nio); C0ss.C.Minimum = zeros(nio);
C0ss.D.Value = zeros(nio); C0ss.D.Free = zeros(nio);

F0 = ss(eye(nio) * tf([1 0],[1 1]));    % weight filter for y (highpass)
F1 = ss(eye(nio) * tf([1 0],[1 1e-3])); % weight filter for z (highpass)

%% Label the block I/Os
% Input names

T_I = cell(1,nw);

% disturbances first
for i = 1:nw
    G.u(i) = {['w' num2str(i)]};
    T_I{i} = ['w' num2str(i)];
end

% control inputs afterwards
for i = 1:nu
    G.u(nw+i) = {['u' num2str(i)]};
end

% Output names
T_O = cell(1,nz);

% error signal first
for i = 1:nz
    G.y(i) = {['z' num2str(i)]};
    T_O{i} = ['z' num2str(i)];
end

% control output afterwards
for i = 1:ny
    G.y(nz+i) = {['y' num2str(i)]};
end

%% Name IOs
for i = 1:nio
    F0.u{i} = ['y' num2str(i)];    F0.y{i} = ['v1' num2str(i)];
    F1.u{i} = ['z' num2str(i)];    F1.y{i} = ['zz' num2str(i)];
    C0ss.u{i} = ['v1' num2str(i)]; C0ss.y{i} = ['u' num2str(i)];
end

%% Connect the controller and the plant together
C1ss = connect(F0,C0ss,F0.u,C0ss.y);
T0 = connect(G,C1ss,T_I,T_O);
T1 = connect(T0,F1,T_I,F1.y);

%% Set-up the optimizer
rng('default')
opt = hinfstructOptions('Display','iter','RandomStart',30,'UseParallel',true);

%% Optimize
[Toptfull,gamma,info] = hinfstruct(T1,opt)

%% Output the controller params
Kfull = Toptfull.Blocks.C0.C.Value

close all
sigma(Toptfull)