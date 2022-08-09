load NODE_COORDS_7

% init
parameters_dvoupatrak;

% Optimization options
lb = zeros(ne,1); ub = [zeros(ne-nc,1); ones(nc,1)]; intCon = 1:ne;
options = optimoptions('ga','CrossoverFrac',0.8,'PopulationSize',200,...
          'MaxStallGenerations',5,'FunctionTolerance',1e-6,'Generations',50,...
          'Display','off','UseParallel',true,'UseVectorized',false,...
          'PlotFcn','gaplotbestf');

modes = {'first','second','worst'};

%% Compute maximum energy transferable betw. the mode and the interactor
MAXSIG_LOCS = zeros(2*(3*nn-nnz(x_bc)),nc); prog = 0;
for ni = 1:nc % num of interactors
    MAXSIG_LOCS_NI = zeros(2*(3*nn-nnz(x_bc)),1);
    for i = 1:2*(3*nn-nnz(x_bc)) % kinematically valid state DOF
        prog = prog + 1;
        disp(['Progress ' num2str(prog) '/' num2str(2*(3*nn-nnz(x_bc))*nc)])
        
        % find best configuration of "ni" interactors for a given
        % mode "i" through all the samples
        OF1 = @(p) -OFvector(i,p,mse,kse,le0,dle0,incidence_table,...
                            NODE_COORDS,j_bc,x_bc);
        
        [~,fval] = ga(OF1,ne,[ones(1,ne); -ones(1,ne)],[ni; -ni],...
                      [],[],lb,ub,[],intCon,options);
        MAXSIG_LOCS_NI(i) = -fval;
        MAXSIG_LOCS(i,ni) = -fval;
    end
    save(['MAXSIG_LOCS/MAXSIG_LOCS_' num2str(ni)],'MAXSIG_LOCS_NI');
end
save('MAXSIG_LOCS','MAXSIG_LOCS');

%%  INTERACTOR PLACEMENT OPTIMIZATION
% maximize potential of the worst mode relative to 'ni' interactors
POPT = zeros(nc); load MAXSIG_LOCS;
for ni = 1:nc
    disp(['Computing for ' num2str(ni) '/' num2str(nc) ' interactors'])
    OF2 = @(p) -multPtsOF(p,mse,kse,le0,dle0,incidence_table,NODE_COORDS,...
                          j_bc,x_bc,MAXSIG_LOCS(:,ni)); % scalar
    [pOpt,fval] = ga(OF2,ne,[ones(1,ne); -ones(1,ne)],[ni; -ni],[],[],lb,ub,[],...
                     intCon,options); % find the optimal interactor placement
    disp(['Objective fcn value: ' num2str(-fval)])
    POPT(ni,:) = pOpt(end-nc+1:end);
    pause(1)
end
save('POPT','POPT');

