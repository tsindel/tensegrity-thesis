
%% clear out
clear all;
close all;
clc;

%% data load
model_data;
ik_data;

%% calculation simulation
out_ik = sim('ik_sim','ReturnWorkspaceOutputs','on');

%% data cut-off
t_d = out_ik.t';
s_d = out_ik.s;
v_d = out_ik.v;
a_d = out_ik.a;
q_d = out_ik.q';
qt_d = out_ik.qt';
qtt_d = out_ik.qtt';

%% data save
save('ik.mat','t_d','s_d','v_d','a_d','q_d','qt_d','qtt_d');

%% results
% upper base
figure(7);
set(gcf,'Units','Normalized','OuterPosition',[0,0,1,1]);

subplot(6,3,1);
hold on;
grid on;
plot(t_d,q_d(13,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('q_u_b_,_d_,_x [m]');

subplot(6,3,2);
title('upper base');
hold on;
grid on;
plot(t_d,qt_d(13,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qt_u_b_,_d_,_x [m/s]');

subplot(6,3,3);
hold on;
grid on;
plot(t_d,qtt_d(13,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qtt_u_b_,_d_,_x [m/s^2]');

subplot(6,3,4);
hold on;
grid on;
plot(t_d,q_d(14,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('q_u_b_,_d_,_y [m]');

subplot(6,3,5);
hold on;
grid on;
plot(t_d,qt_d(14,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qt_u_b_,_d_,_y [m/s]');

subplot(6,3,6);
hold on;
grid on;
plot(t_d,qtt_d(14,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qtt_u_b_,_d_,_y [m/s^2]');

subplot(6,3,7);
hold on;
grid on;
plot(t_d,q_d(15,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('q_u_b_,_d_,_z [m]');

subplot(6,3,8);
hold on;
grid on;
plot(t_d,qt_d(15,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qt_u_b_,_d_,_z [m/s]');

subplot(6,3,9);
hold on;
grid on;
plot(t_d,qtt_d(15,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qtt_u_b_,_d_,_z [m/s^2]');

subplot(6,3,10);
hold on;
grid on;
plot(t_d,q_d(16,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('q_u_b_,_d_,_\phi_x [rad]');

subplot(6,3,11);
hold on;
grid on;
plot(t_d,qt_d(16,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qt_u_b_,_d_,_\phi_x [rad/s]');

subplot(6,3,12);
hold on;
grid on;
plot(t_d,qtt_d(16,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qtt_u_b_,_d_,_\phi_x [rad/s^2]');

subplot(6,3,13);
hold on;
grid on;
plot(t_d,q_d(17,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('q_u_b_,_d_,_\phi_y [rad]');

subplot(6,3,14);
hold on;
grid on;
plot(t_d,qt_d(17,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qt_u_b_,_d_,_\phi_y [rad/s]');

subplot(6,3,15);
hold on;
grid on;
plot(t_d,qtt_d(17,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qtt_u_b_,_d_,_\phi_y [rad/s^2]');

subplot(6,3,16);
hold on;
grid on;
plot(t_d,q_d(18,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('q_u_b_,_d_,_\phi_z [rad]');

subplot(6,3,17);
hold on;
grid on;
plot(t_d,qt_d(18,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qt_u_b_,_d_,_\phi_z [rad/s]');

subplot(6,3,18);
hold on;
grid on;
plot(t_d,qtt_d(18,:),'-r','LineWidth',1);
xlabel('t_d [s]');
ylabel('qtt_u_b_,_d_,_\phi_z [rad/s^2]');

% rods
for r = 6:-1:1
    figure(r);
    set(gcf,'Units','Normalized','OuterPosition',[0,0,1,1]);
    str = ['rod ',int2str(int8(r))];
    
    subplot(2,3,1);
    hold on;
    grid on;
    plot(t_d,q_d((r-1)*2+1,:),'-r','LineWidth',1);
    xlabel('t_d [s]');
    ylabel('q_r_,_d_,_x [rad]');
    
    subplot(2,3,2);
    title(str);
    hold on;
    grid on;
    plot(t_d,qt_d((r-1)*2+1,:),'-r','LineWidth',1);
    xlabel('t_d [s]');
    ylabel('qt_r_,_d_,_x [rad/s]');
    
    subplot(2,3,3);
    hold on;
    grid on;
    plot(t_d,qtt_d((r-1)*2+1,:),'-r','LineWidth',1);
    xlabel('t_d [s]');
    ylabel('qtt_r_,_d_,_x [rad/s^2]');
    
    subplot(2,3,4);
    hold on;
    grid on;
    plot(t_d,q_d((r-1)*2+2,:),'-r','LineWidth',1);
    xlabel('t_d [s]');
    ylabel('q_r_,_d_,_y [rad]');
    
    subplot(2,3,5);
    hold on;
    grid on;
    plot(t_d,qt_d((r-1)*2+2,:),'-r','LineWidth',1);
    xlabel('t_d [s]');
    ylabel('qt_r_,_d_,_y [rad/s]');
    
    subplot(2,3,6);
    hold on;
    grid on;
    plot(t_d,qtt_d((r-1)*2+2,:),'-r','LineWidth',1);
    xlabel('t_d [s]');
    ylabel('qtt_r_,_d_,_y [rad/s^2]');
end
