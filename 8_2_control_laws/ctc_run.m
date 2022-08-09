
%% clear out
clear all;
close all;
clc;

%% data load
% model
model_data;
save('model.mat');
% inverse kinematics
load('ik.mat');
% ctc
ctc_data;

%% initial position and velocity of mechanism
s_0 = s_d(:,:,1);
v_0 = v_d(:,:,1);

%% calculation simulation
out_ctc = sim('ctc_sim','ReturnWorkspaceOutputs','on');

%% output data
t = out_ctc.t';
s = out_ctc.s;
v = out_ctc.v;
q = out_ctc.q';
qt = out_ctc.qt';
e = out_ctc.e';
F_c = out_ctc.F_c';
l_c = out_ctc.l_c';
l0_c = out_ctc.L0_c';

%% data save
save('ctc.mat','Kp','Kd','t','s','v','q','qt','e','F_c','l_c');

%% results
% cable forces
figure(9)
set(gcf,'Units','Normalized','OuterPosition',[0,0,1,1]);
sgtitle('cable forces');
for c = 1:1:18
    str_c = ['cable ',int2str(int8(c))];
    
    subplot(6,3,c);
    hold on;
    grid on;
    title(str_c);
    plot(t,F_c(c,:),'-b','LineWidth',1);
    xlabel('t [s]');
    ylabel('F_c [N]');
end

% upper base
figure(8);
set(gcf,'Units','Normalized','OuterPosition',[0,0,1,1]);
sgtitle('upper base');

subplot(3,2,1);
hold on;
grid on;
plot(t,q(13,:),'-b','LineWidth',1);
plot(t_d,q_d(13,:),'--r','LineWidth',1);
legend('actual','desired');
xlabel('t [s]');
ylabel('q_u_b_,_x [m]');

subplot(3,2,3);
hold on;
grid on;
plot(t,q(14,:),'-b','LineWidth',1);
plot(t_d,q_d(14,:),'--r','LineWidth',1);
legend('actual','desired');
xlabel('t [s]');
ylabel('q_u_b_,_y [m]');

subplot(3,2,5);
hold on;
grid on;
plot(t,q(15,:),'-b','LineWidth',1);
plot(t_d,q_d(15,:),'--r','LineWidth',1);
legend('actual','desired');
xlabel('t [s]');
ylabel('q_u_b_,_z [m]');

subplot(3,2,2);
hold on;
grid on;
plot(t,q(16,:),'-b','LineWidth',1);
plot(t_d,q_d(16,:),'--r','LineWidth',1);
legend('actual','desired');
xlabel('t [s]');
ylabel('q_u_b_,_\phi_x [rad]');

subplot(3,2,4);
hold on;
grid on;
plot(t,q(17,:),'-b','LineWidth',1);
plot(t_d,q_d(17,:),'--r','LineWidth',1);
legend('actual','desired');
xlabel('t [s]');
ylabel('q_u_b_,_\phi_y [rad]');

subplot(3,2,6);
hold on;
grid on;
plot(t,q(18,:),'-b','LineWidth',1);
plot(t_d,q_d(18,:),'--r','LineWidth',1);
legend('actual','desired');
xlabel('t [s]');
ylabel('q_u_b_,_\phi_z [rad]');

figure(7);
set(gcf,'Units','Normalized','OuterPosition',[0,0,1,1]);
sgtitle('upper base');

subplot(3,2,1);
hold on;
grid on;
plot(t,e(13,:),'-r','LineWidth',1);
xlabel('t [s]');
ylabel('e_u_b_,_x [m]');

subplot(3,2,3);
hold on;
grid on;
plot(t,e(14,:),'-r','LineWidth',1);
xlabel('t [s]');
ylabel('e_u_b_,_y [m]');

subplot(3,2,5);
hold on;
grid on;
plot(t,e(15,:),'-r','LineWidth',1);
xlabel('t [s]');
ylabel('e_u_b_,_z [m]');

subplot(3,2,2);
hold on;
grid on;
plot(t,e(16,:),'-r','LineWidth',1);
xlabel('t [s]');
ylabel('e_u_b_,_\phi_x [rad]');

subplot(3,2,4);
hold on;
grid on;
plot(t,e(17,:),'-r','LineWidth',1);
xlabel('t [s]');
ylabel('e_u_b_,_\phi_y [rad]');

subplot(3,2,6);
hold on;
grid on;
plot(t,e(18,:),'-r','LineWidth',1);
xlabel('t [s]');
ylabel('e_u_b_,_\phi_z [rad]');

% rods
for r = 6:-1:1
    str = ['rod ',int2str(int8(r))];
    
    figure(r);
    set(gcf,'Units','Normalized','OuterPosition',[0,0,1,1]);
    sgtitle(str);
    
    subplot(2,2,1);
    hold on;
    grid on;
    plot(t,q((r-1)*2+1,:),'-b','LineWidth',1);
    plot(t_d,q_d((r-1)*2+1,:),'--r','LineWidth',1);
    legend('actual','desired');
    xlabel('t [s]');
    ylabel('q_r_,_x [rad]');
    
    subplot(2,2,2);
    hold on;
    grid on;
    plot(t,e((r-1)*2+1,:),'-r','LineWidth',1);
    xlabel('t [s]');
    ylabel('e_r_,_x [rad]');
    
    subplot(2,2,3);
    hold on;
    grid on;
    plot(t,q((r-1)*2+2,:),'-b','LineWidth',1);
    plot(t_d,q_d((r-1)*2+2,:),'--r','LineWidth',1);
    legend('actual','desired');
    xlabel('t [s]');
    ylabel('q_r_,_y [rad]');
    
    subplot(2,2,4);
    hold on;
    grid on;
    plot(t,e((r-1)*2+2,:),'-r','LineWidth',1);
    xlabel('t [s]');
    ylabel('e_r_,_y [rad]');
end
