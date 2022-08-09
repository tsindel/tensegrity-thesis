%% Computing sensitivity matrices using LOCAL LINEARIZATION METHOD

clear
close all

% Load parameters
parameters_dvoupatrak;

%% Assign the model
mdl = 'dvoupatrak_15lan'; load_system(mdl);

sim_time = 5;
settling_time = 0.5;
prestress_cab = 0.95;

%% Main loop
out = sim(mdl)
