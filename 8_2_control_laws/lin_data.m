%% Linearization data
lin_points = 5;
start_gap = 0.5; % we dont linearize in this gap

% Modify derivative block for linearization (1...linearize, 0...simulate)
linderiv = 1;

% Compute the linearization times
lin_times = start_gap + linspace(0,T-start_gap,lin_points);