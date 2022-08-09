
%% mechanism dimensions
% lower base
w_lb = 0.195;
W_lb = 0.205;
t_lb = 0.01;
h_lb = 0.04;
% lower base - position
O_lb = [0;0;0;0;0;0];
% upper base
w_ub = 0.195;
W_ub = 0.205;
t_ub = 0.01;
h_ub = 0.04;
h_e = 0.02;
% bases angles
Fi_b_z = [0;2/3;4/3;1/3;3/3;5/3]*pi;
% bars
l_r = 0.36*ones(6,1);
d_r = 0.01*ones(6,1);

%% physical parameters of the mechanism
Ro_lb = 2700;
Ro_ub = 2700;
Ro_r = 2700;

%% gravity
g = [0,0,-9.80665];

%% Cable properties
ksc = 1.79e5; % [N/m*m=N] specific stiffness ks [N] per meter length
bsc = 17;    % [Ns/m] specific damping coefficient per meter length

%% Piezoelectric transducer (sensor+actuator) parameters
ka = 11.86e6; % [N/m] stiffness (act 12 N/um, sens 1.05 kN/um)
la00 = 61e-3; %  m ... initial length
max_stroke = 120e-6; % m

%% Vibration injection parameters
% white noise power spectral density
top_noise = 1000/5263*15*5e-4; % force excitation
bot_noise = 1000/5263*1e-10;   % kinematic excitation
ts_noise = 1.6e-4; % white noise sampling time

%% other options
linderiv = 0; % 0...simulation; 1...linearization
t_dist = 0.1; % vibration (disturbance) activation time
openloop = 1; % high authority control is executed in open loop - faster
gain_iff = 65;