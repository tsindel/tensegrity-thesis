clear

%% Preprocess the data
load Xtab
nc = Xtab.cabnum(end);
X = table2array(Xtab); X = X(:,2:end);

%% Define the weigths
weights = [10 10 5 1 1 10]; % arbitrary
% order: {'xtilt'}{'ytilt'}{'zrot'}{'xshear'}{'yshear'}{'zext'}

%% Compute the quadratic form matrix Q
Q = zeros(nc);
for i = 1:6
    xi = normalize(X(:,i),'norm');
    Q = Q + weights(i) * (abs(xi*xi') - xi*xi');
end

%% Optimization options
lb = zeros(nc,1); ub = ones(nc,1); intCon = 1:nc;
options = optimoptions('ga','CrossoverFrac',0.8,'PopulationSize',50,...
    'MaxStallGenerations',10,'FunctionTolerance',1e-4,'Generations',30,...
    'UseParallel',false,'UseVectorized',false,'PlotFcn','gaplotbestf');

%% Optimize
S = @(c) -c*Q*c'; % quadratic form (input vector is a row vector)
for na = 1:nc
    disp(['Progress ' num2str(na) '/' num2str(nc)])
    [copt,fval] = ga(S,nc,[ones(1,nc); -ones(1,nc)],[na; -na],[],[],lb,ub,[],intCon,options);
    COPT(:,na) = copt; FVAL(:,na) = fval;
end

%% Plot the results
close all
figure
plot(-FVAL,'LineWidth',1,'Color','k')
xlim([1 nc])
grid on
xlabel('Number of actuators')
ylabel('CF (balanced sensitivity)')