function OF = minBaNorm(mode,a,mse,kse,le0,dle0,incidence_table,...
              node_coords,j_bc,x_bc,maxBa_locs_na,dispOF)
    %% OF for one configuration %%
    %% Finds the minimum of sums of squares for one configuration %%
    nn = length(node_coords);
    if strcmp(mode,'first')
        OF = objFcnBa(1,a,mse,kse,le0,dle0,incidence_table,node_coords,...
             j_bc,x_bc) / maxBa_locs_na(1);
    elseif strcmp(mode,'second')
        OF = objFcnBa(2,a,mse,kse,le0,dle0,incidence_table,node_coords,...
             j_bc,x_bc) / maxBa_locs_na(2);
    elseif strcmp(mode,'worst')
        Ba_norm = zeros(3*nn-nnz(x_bc),1);
        for i = 1:3*nn-nnz(x_bc) % compute sum of squares for the i-th mode
            Ba_norm(i) = objFcnBa(i,a,mse,kse,le0,dle0,incidence_table,...
                         node_coords,j_bc,x_bc) / maxBa_locs_na(i);
            % *maxBa_locs is a matrix of values: each row is for mode,
            % each column for number of actuators
        end
        OF = min(Ba_norm);
    else
        disp('ERROR: Wrong eigenmode specified')
        return
    end
    if isinf(OF)
        disp('ERROR: Infinite controllability - physically unfeasible.')
        return
    elseif dispOF
        disp(['Objective function: ' num2str(OF)])
    end
end

