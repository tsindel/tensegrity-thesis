%%% This script combines all the previous controllers (collocated, IFF and
%%% H-inf) and with this defined structure it tries to find an optimal
%%% gains in the gain matrix.

%% Define the plant
only_force = true;
load plantsys
load plantsys_topf
if only_force
    plantsys = plantsys_topf;
end

%% Def. IOs
nio = 6; % number of collocated control loops
    
ny = nio; nu = nio;
nz = length(plantsys.OutputName) - nio; % 6DOF velocities of the top platform
nw = length(plantsys.InputName) - nio; % 12 disturbance inputs

%% Check the stability
close all
openLoop = lft(plantsys,ss(zeros(nio),zeros(nio),zeros(nio),zeros(nio)));
pzplot(openLoop)

%% Assemble the big (multiple OP) plant state space model
G = ss([],[],[],[]);
for i = 1:lin_points
    ith_sys = plantsys(:,:,i,1);
    for j = 1:nw
        ith_sys.u{j} = ['w' '_' num2str(i) '_' num2str(j)];
    end
    for j = nw+1:nw+nu
        ith_sys.u{j} = ['u' '_' num2str(i) '_' num2str(j-nw)];
    end
    for j = 1:nz
        ith_sys.y{j} = ['z' '_' num2str(i) '_' num2str(j)];
    end
    for j = nz+1:nz+ny
        ith_sys.y{j} = ['y' '_' num2str(i) '_' num2str(j-nz)];
    end
    
    G = connect(G,ith_sys,[G.u;ith_sys.u],[G.y;ith_sys.y]);
end

%% Assemble the big (multiple OP) state space model with zero gain (OL)
OL = ss([],[],[],[]);
for i = 1:lin_points
    ith_sys = openLoop(:,:,i,1);
    for j = 1:nw
        ith_sys.u{j} = ['w' '_' num2str(i) '_' num2str(j)];
    end
    for j = 1:nz
        ith_sys.y{j} = ['z' '_' num2str(i) '_' num2str(j)];
    end
    
    OL = connect(OL,ith_sys,[OL.u;ith_sys.u],[OL.y;ith_sys.y]);
end

%% Define tunable controller (negative diagonal integral feedback)

% Define controller free parameters
Ci = realp('Ci',eye(nio)); % gain matrix
gi = realp('gi',1); % single gain

% Ci.Free = eye(nio);        % only diagonal elements are not fixed
% Ci.Free = ones(nio);       % all elements are free - full matrix gain
Ci.Free = zeros(nio);        % no matrix elements are free - single gain
gi.Free = 1;

Ci.Minimum = zeros(nio); % only positive values
gi.Minimum = 0; % only positive gain

% Assemble MIMO state-space model equivalent to integral feedback
A = zeros(nio*lin_points); B = -eye(nio*lin_points); D = zeros(nio*lin_points);
C = gi * blkdiag(Ci,Ci,Ci,Ci,Ci); % 5 lin points
C0ss = ss(A,B,C,D);

F0 = ss(eye(ny*lin_points) * tf([1 0],[1 1]));    % weight filter for y (highpass)
F1 = ss(eye(nz*lin_points) * tf([1 0],[1 1e-3])); % weight filter for z (highpass)

%% Name IOs
for i = 1:lin_points
    for j = 1:nio
        seq = nio*(i-1)+j;
        ii = ['_' num2str(i) '_' num2str(j)];
        F0.u{seq} =   ['y' ii];
        F0.y{seq} =   ['v' ii];
        F1.u{seq} =   ['z' ii];
        F1.y{seq} =   ['zz' ii];
        C0ss.u{seq} = ['v' ii];
        C0ss.y{seq} = ['u' ii];
    end
end

%% Connect the controller and the plant together
opt = connectOptions('Simplify',false);

C1ss = connect(F0,C0ss,F0.u,C0ss.y,opt); % tunable controller with filters
T0 = connect(G,C1ss,G.u(contains(G.u,'w')),G.y(contains(G.y,'z')),opt); % closed-loop plant
T1 = connect(T0,F1,T0.u,F1.y,opt); % closed-loop plant with output filter

%% Set-up the optimizer
rng('default')
opt = hinfstructOptions('Display','iter','RandomStart',50,...
    'UseParallel',true,'TolGain',0.01,'MaxFrequency',1e5);

%% Optimize the controller gains
tic
[Topt,gamma,info] = hinfstruct(T1,opt)
toc
beep

%% Output the controller params
% Kdiag = diag(Topt.Blocks.Ci.Value)
% Kfull = diag(Topt.Blocks.Ci.Value)
Ksingle = diag(Topt.Blocks.gi.Value)
% save Kfull

%% Plot singular values
flim = {1,1e5}; % Hz
flimexp = {0,5}; % Hz
pts = 1000;
yax = logspace(flimexp{1},flimexp{2},pts);

svOL =      sigma(OL,2*pi*yax);
svdiag =    sigma(CLopt_diag,2*pi*yax);
svsingle =  sigma(CLopt_single,2*pi*yax);
svfull =    sigma(CLopt_full,2*pi*yax);

% Get maximum singular values
svmaxOL = max(svOL,[],1);
svmaxdiag = max(svdiag,[],1);
svmaxsingle = max(svsingle,[],1);
svmaxfull = max(svfull,[],1);

%% Plot singular values

close all
% Absolute gains
figure
semilogx(yax,mag2db(svmaxOL),'r',yax,mag2db(svmaxsingle),'m',...
         yax,mag2db(svmaxdiag),'b',yax,mag2db(svmaxfull),'g');
title('Singular values');
xlabel('Frequency (Hz)'); ylabel('Absolute magnitude (dB)');
grid on
legend('Open-loop','Optimal decentralized gain (single)',...
       'Optimal decentralized gain (multiple)',...
       'Optimal centralized gain','Location','best')

% Relative attenuations
figure
semilogx(yax,mag2db(svmaxOL)-mag2db(svmaxsingle),'m',...
         yax,mag2db(svmaxOL)-mag2db(svmaxdiag),'b',...
         yax,mag2db(svmaxOL)-mag2db(svmaxfull),'g');
title('Open-loop attenuation');
xlabel('Frequency (Hz)'); ylabel('Attenuation (dB)');
grid on
legend('Optimal decentralized gain (single)',...
       'Optimal decentralized gain (multiple)',...
       'Optimal centralized gain','Location','best')