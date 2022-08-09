load NODE_COORDS_7

% init
parameters_dvoupatrak;

% Params for objective function
mse = [b_A .* b_rho; c_specific_mass * ones(15,1)];
kse = [b_k; ks];
le_init = elemLengths(incidence_table,NODE_COORDS(:,:,1)); % initial lengths (depends on geometry)
le0 = le_init * (1-contr_ratio); % free lengths (after prestress) - arbitrary (we choose)
dle0 = le_init - le0;

% Number of elements
ne = length(incidence_table); nn = length(node_coords);
nc = nnz(not(strut_vect)); % number of cables - max number of actuators

% Optimization options
lb = zeros(ne,1); ub = [zeros(ne-nc,1); ones(nc,1)]; intCon = 1:ne;
options = optimoptions('ga','CrossoverFrac',0.8,'PopulationSize',500,...
    'MaxStallGenerations',20,'FunctionTolerance',1e-6,'Generations',50,...
        'Display','off','UseParallel',true,'UseVectorized',false,...
        'PlotFcn','gaplotbestf');

modes = {'first','second','worst'};

%% Compute maximum energy transferable from the mode to "ns" sensors
MAXCS_LOCS = zeros(3*nn-nnz(x_bc),samples,nc); prog = 0;
for ns = 1:nc % num of actuators given
    for i = 1:3*nn-nnz(x_bc) % kinematically valid DOF
        for op = 1:samples % operating point given
            prog = prog + 1;
            disp(['Progress ' num2str(prog) '/' num2str((3*nn-nnz(x_bc))*nc*samples)])
            % find best configuration of "ns" actuators for a given
            % mode "i" through all the samples
            Cs0 = Cs0Matrix(mse,kse,le0,dle0,incidence_table,...
                            NODE_COORDS(:,:,op),j_bc,x_bc);
            OF1 = @(s) -objFcnCs(i,s,Cs0);
            [~,fval] =  ga(OF1,ne,[ones(1,ne); -ones(1,ne)],[ns; -ns],...
                       [],[],lb,ub,[],intCon,options);
            MAXCS_LOCS(i,op,ns) = -fval;
        end
    end
end
save('MAXCS_LOCS','MAXCS_LOCS');

%%  SENSOR PLACEMENT OPTIMIZATION
% maximize observability of the worst mode relative to 'ns' sensors
SOPT = zeros(nc);
for ns = 1:nc
    disp(['Computing for ' num2str(ns) '/' num2str(nc) ' sensors'])
    % maximize minCsNorm -> minimize -minCsNorm
    % 'worst' - according to Bruant and Proslier 2005, other options: 'first', 'second'
    OF2 = @(s) -multPtsOF(s,mse,kse,le0,dle0,incidence_table,NODE_COORDS,...
                          j_bc,x_bc,MAXCS_LOCS(:,:,ns)); % scalar
    [sOpt,fval] = ga(OF2,ne,[ones(1,ne); -ones(1,ne)],[ns; -ns],[],[],lb,ub,[],...
                     intCon,options); % find the optimal actuator placement
    disp(['Objective fcn value: ' num2str(-fval)])
    SOPT(ns,:) = sOpt(end-nc+1:end);
    pause(1)
end
save('SOPT','SOPT');

