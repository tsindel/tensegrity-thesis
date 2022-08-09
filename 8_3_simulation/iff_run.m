
%% clear out
clear all;
close all;
clc;

%% data load
% model
model_data;
%%
save('model.mat');
% inverse kinematics
load('ik.mat');
% ctc
ctc_data;
%%
load l0_c.mat
load t.mat
%%
L0_c = [t; l0_c]';
%%
load Ksingle_alt

%% initial position and velocity of mechanism
s_0 = s_d(:,:,1);
v_0 = v_d(:,:,1);

%% simulate
out = sim('iff_sim','ReturnWorkspaceOutputs','on');

%% process the results
time = out.angvels.Time(out.angvels.Time>0.5);

% Velocities
transvels = out.transvels.Data(out.transvels.Time>0.5,:);
angvels = out.angvels.Data(out.angvels.Time>0.5,:);

% Position
disps = out.displacement.Data(out.displacement.Time>0.5,:);
eulangles = quat2eul(out.quat.Data(out.quat.Time>0.5,:),'ZYX'); % ZXZ...yaw->pitch->roll

% Energy
dissipation = out.dissipation.Data(out.dissipation.Time>0.5,:);

% % Input noise signal
top_noise_sig = out.top_noise_out.Data(out.top_noise_out.Time>0.5,:);
bot_noise_sig = out.bot_noise_out.Data(out.bot_noise_out.Time>0.5,:);

%% Cable forces
% No vibrations
cabforces = out.cabforces;

%% Choose quantities to save
% No vibration
% time_0 = time - 0.5;
% transvels_0 = transvels;
% angvels_0 = angvels;
% disps_0 = disps;
% eulangles_0 = eulangles;
% save time_0
% save transvels_0
% save angvels_0
% save disps_0
% save eulangles_0

% WHITE NOISE
% Open-loop vibration
% time_OL = time - 0.5;
% transvels_OL = transvels;
% angvels_OL = angvels;
% disps_OL = disps;
% eulangles_OL = eulangles;
% save time_OL
% save transvels_OL
% save angvels_OL
% save disps_OL
% save eulangles_OL

% IFF vibration
% time_iff = time - 0.5;
% transvels_iff = transvels;
% angvels_iff = angvels;
% disps_iff = disps;
% eulangles_iff = eulangles;
% save time_iff
% save transvels_iff
% save angvels_iff
% save disps_iff
% save eulangles_iff
% save dissipation
% 
% save top_noise_sig
% save bot_noise_sig

%% FORCE PULSE
% Open-loop vibration
% time_OLf = time - 0.5;
% transvels_OLf = transvels;
% angvels_OLf = angvels;
% disps_OLf = disps;
% eulangles_OL = eulangles;
% save time_OLf
% save transvels_OLf
% save angvels_OLf
% save disps_OLf
% save eulangles_OLf

% IFF vibration
% time_ifff = time - 0.5;
% transvels_ifff = transvels;
% angvels_ifff = angvels;
% disps_ifff = disps;
% eulangles_ifff = eulangles;
% save time_ifff
% save transvels_ifff
% save angvels_ifff
% save disps_ifff
% save eulangles_ifff
% save dissipation_f

%% Task-space trajectory plot
figure
layout = tiledlayout(1,2);
ax1 = nexttile;
plot(time,disps)
grid on
ylabel('Displacement (m)')
legend('x','y','z','Location','best')
ax2 = nexttile;
plot(time,eulangles*180/pi)
grid on
ylabel('Rotation (deg)')
legend('Yaw','Pitch','Roll','Location','best')
linkaxes([ax1,ax2],'x');
title(layout,'Task-space trajectory')
xlabel(layout,'Time (s)')

%%

beep
