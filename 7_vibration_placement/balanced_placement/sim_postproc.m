% Sampling indexes
samples = 7;

% extract node coordinates
node_logs = out.logsout{3}.Values;

set = settling_time; sim = sim_time; T = sim - set;

sample_times = set * ones(samples,1) + T *[0 1/3 5/12 1/2 5/6 11/12 1]'; % ad hoc
sample_idx = interp1(node_logs.Time,1:node_logs.Length,sample_times,'nearest');

% Nodes
nodes_ = -1 * node_logs.Data(sample_idx,:);
for s = 1:samples
    NODE_COORDS(:,:,s) = reshape(nodes_(s,:),3,9)';
end

save(join(['NODE_COORDS_' num2str(samples)]))