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

%% Compute maximum energy transferable to the modes from "na" actuators
MAXBA_LOCS = zeros(3*nn-nnz(x_bc),samples,nc); prog = 0;
for na = 1:nc % num of actuators given
    for i = 1:3*nn-nnz(x_bc) % kinematically valid DOF
        for op = 1:samples % operating point given
            prog = prog + 1;
            disp(['Progress ' num2str(prog) '/' num2str((3*nn-nnz(x_bc))*nc*samples)])
            % find best configuration of "na" actuators for a given
            % mode "i" through all the samples
            OF1 = @(a) -objFcnBa(i,a,mse,kse,le0,dle0,incidence_table,...
                        NODE_COORDS(:,:,op),j_bc,x_bc);
            [~,fval] = ga(OF1,ne,[ones(1,ne); -ones(1,ne)],[na; -na],...
                       [],[],lb,ub,[],intCon,options);
            MAXBA_LOCS(i,op,na) = -fval;
        end
    end
end
save('MAXBA_LOCS','MAXBA_LOCS');


%%  Genetic algorithm (no configuration weights)
AOPT = zeros(nc,nc);
for na = 1:nc
    disp(['Computing for ' num2str(na) '/' num2str(nc) ' actuators'])
    % maximize minBaNorm -> minimize -minBaNorm
    % 'worst' - according to Bruant and Proslier 2005, other options: 'first', 'second'
    OF2 = @(a) -multPtsOF(a,mse,kse,le0,incidence_table,NODE_COORDS,...
                j_bc,x_bc,MAXBA_LOCS(:,:,na)); % scalar
    [aOpt,fval] = ga(OF2,ne,[ones(1,ne); -ones(1,ne)],[na; -na],[],[],lb,ub,[],...
                     intCon,options); % find the optimal actuator placement
    disp(['Objective fcn value: ' num2str(-fval)])
    AOPT(na,:) = aOpt(end-nc+1:end);
    pause(1)
end
save('AOPT','AOPT');
%%  Compute functions in different configs separately
Results = zeros(nc,11);
for na = 1:nc
    aOpt = [zeros(1,6) AOPT(na,:)];
    
    % Get mode number of LCM mode
    idxLCM = getIdxMinOF(aOpt,mse,kse,le0,incidence_table,NODE_COORDS,...
             j_bc,x_bc,MAXBA_LOCS(:,:,na));

    % Compute function values in configs for the optimal actuator placement
    fOpt1st = OFvector(1,aOpt,mse,kse,le0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXBA_LOCS(:,:,na));
    fOpt2nd = OFvector(2,aOpt,mse,kse,le0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXBA_LOCS(:,:,na));
    fOptLCM = OFvector(idxLCM,aOpt,mse,kse,le0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXBA_LOCS(:,:,na));
              % LCM - least controllable mode

    % Compute mean and standard deviation for the configurations
    val1st = mean(fOpt1st); err1st_p = max(fOpt1st) - val1st; err1st_n = val1st - min(fOpt1st);    
    val2nd = mean(fOpt2nd); err2nd_p = max(fOpt2nd) - val2nd; err2nd_n = val2nd - min(fOpt2nd);
    valLCM = mean(fOptLCM); errLCM_p = max(fOptLCM) - valLCM; errLCM_n = valLCM - min(fOptLCM);  

    % Concatenate and save results
    Results(na,:) = [na val1st err1st_p err1st_n val2nd err2nd_p ...
                     err2nd_n valLCM errLCM_p errLCM_n idxLCM];
end

