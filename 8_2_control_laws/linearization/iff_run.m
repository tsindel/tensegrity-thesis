
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

load l0_c.mat
load t.mat
L0_c = [t; l0_c]';

%% initial position and velocity of mechanism
s_0 = s_d(:,:,1);
v_0 = v_d(:,:,1);

%% simulate
sim('iff_sim');

%% extract simulation data
