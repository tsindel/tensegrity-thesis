clear

%% Define the plant
load linsys
minsys = ss(linsys,'min');

%% Check the stability
close all
pzplot(minsys)

%%
nio = 6; % number of collocated control loops
G = minsys; %...create linear state-space plant G

%% Full Hinf control synthesis
[Kfull,CLfull,~] = hinfsyn(G,nio,nio);