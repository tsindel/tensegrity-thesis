% spherical joint damping
bsj = 1e-2;

%% bar parameters
b_length = 0.3; %bar length
b_l = b_length * ones(6,1);
b_diameter = 0.015; %bar diameter
b_d = b_diameter * ones(6,1);
b_density = 2700; % bar material density
b_rho = b_density * ones(6,1);
b_modulus = 2e11; % Young modulus
b_E = b_modulus * ones(6,1);
AA = (pi * b_diameter^2) / 4; % bar cross-section area
b_A = AA * ones(6,1);
b_k = b_E .* b_A ./ b_l; % bar stiffness
b_b = zeros(size(b_k)); % bar damping

%% cable parameters
%stiffness is dependent on the cable length!!! => specific stiffness
c_specific_stiffness = 1e3; % N Newton per a meter * length meter
ks = c_specific_stiffness * ones(15,1);
c_specific_damping = 10; %cable damping N/(m/s)/m 
bs = c_specific_damping * ones(15,1);
c_specific_mass = 6e-3; % kg / m

%% parallel spring parameters
%spring free length is constant (initial position of the structure)
kpi = 1e2; % N/m
kp = kpi * ones(15,1);
bpi = 5; % parallel spring damping N/(m/s)/m 
bp = bpi * ones(15,1);

%% Structure geometry

% Initial contraction
contr_ratio = 0.1; % delta_le / le0

% Circumscribed circles radii
rot = -15; % tensegrity interlevel rotation (deg)
r_base = 0.1; %m
r_mid = 0.15; %m
r_top = 0.1; %m

% Point coords
xA=r_base*cos(210*pi/180);
yA=r_base*sin(210*pi/180);
xB=r_mid*cos((330+rot)*pi/180);
yB=r_mid*sin((330+rot)*pi/180);
xC=r_top*cos((210+rot)*pi/180);
yC=r_top*sin((210+rot)*pi/180);
v1=sqrt(b_length^2 - (xB-xA)^2 - (yB-yA)^2);
v2=sqrt(b_length^2 - (xC-xB)^2 - (yC-yB)^2);

% Global nodal coordinates (initial)
node_coords =  [r_base * cos(210*pi/180)       r_base * sin(210*pi/180)       0
                r_base * cos(330*pi/180)       r_base * sin(330*pi/180)       0 
                r_base * cos(90*pi/180)        r_base * sin(90*pi/180)        0 
                r_mid  * cos((210+rot)*pi/180) r_mid  * sin((210+rot)*pi/180) v1
                r_mid  * cos((330+rot)*pi/180) r_mid  * sin((330+rot)*pi/180) v1 
                r_mid  * cos((90+rot)*pi/180)  r_mid  * sin((90+rot)*pi/180)  v1
                r_top  * cos(210*pi/180)       r_top  * sin(210*pi/180)      (v1+v2)
                r_top  * cos(330*pi/180)       r_top  * sin(330*pi/180)      (v1+v2) 
                r_top  * cos(90*pi/180)        r_top  * sin(90*pi/180)       (v1+v2)];

% Incidence table (elements definition) (struts: 1-6, cables: 7-end)
incidence_table = [1 5
                   2 6
                   3 4
                   4 9
                   5 7
                   6 8
                   1 4
                   2 5
                   3 6
                   4 7
                   5 8
                   6 9
                   4 5
                   5 6
                   6 4
                   1 6
                   3 5
                   2 4
                   4 8
                   5 9
                   6 7];

%pocatecni volne delky lan
l0_init=cable_length(node_coords, incidence_table(7:end,:));
               
% vector defining where struts are among the incidence table
strut_vect = [ones(6,1); zeros(length(incidence_table)-6,1)];

% Boundary conditions
j_bc = [1 2 3]'; % global nodes affected by BCs
x_bc = [1 1 1 1 1 1 1 1 1]'; % node coordinates affected by BCs (x,y,z
                             % translation for i-th node respectively)

%% parametry platformy nahore (na ram pouze sfericka vazba)
%r_base jiz definovano vyse
t_top=0.005; %thickness of the top triangle
t_base=0.005; %thickness of the triangle base

%%pocatecni poloha
N = node_coords;
S1=matrix_S(N(1, :), N(5,:));
S2=matrix_S(N(2, :), N(6,:));
S3=matrix_S(N(3, :), N(4,:));
load Q4; load Q5; load Q6;
S4=qdcm(Q4.Data(end, :));
S5=qdcm(Q5.Data(end, :));
S6=qdcm(Q6.Data(end, :));

%%natoceni sour. systemu koncove platformy
load align_platform;
align_rotz=align_platform.Data(end, end);

%% Dalsi parametry

load NODE_COORDS_7.mat;

% Params for objective function
mse = [b_A .* b_rho; c_specific_mass * ones(15,1)];
kse = [b_k; ks];
le_init = elemLengths(incidence_table,NODE_COORDS(:,:,1)); % initial lengths (depends on geometry)
le0 = le_init * (1-contr_ratio); % free lengths (after prestress) - arbitrary (we choose)
dle0 = le_init - le0;

% Number of elements
ne = length(incidence_table); nn = length(node_coords);
nc = nnz(not(strut_vect)); % number of cables - max number of actuators
