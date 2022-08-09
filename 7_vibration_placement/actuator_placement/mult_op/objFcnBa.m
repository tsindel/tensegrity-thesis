function OF = objFcnBa(row,a,mse,kse,le0,dle0,incidence_table,node_coords,j_bc,x_bc)
    %% Computes the sum of squares of each row %%
    % accept "a" as logical vector of dims (ne,1)
    if length(a) ~= length(incidence_table)
        disp('ERROR: Wrong dimensions of either vector "a" or incidence table.')
        return
    end

    % Transformation matrices
    H = dirCosMatrixH(node_coords,incidence_table);
    Pi = incidenceMatrix(incidence_table,j_bc,x_bc);
    
    % System matrices
    Mb = matrixMb(mse,le0,incidence_table,j_bc,x_bc);
    Kb = matrixKb(kse,le0,dle0,node_coords,incidence_table,j_bc,x_bc);

    %% Eigenmodes
    [U,~] = eig(Kb,Mb); U = orthoNormModal(U,Mb);

    %% Actuation matrix decomposition
    Ba = U' * Pi * H * diag(a);
    
    %% Objective function
    OF = sum(Ba(row,:).^2);
end

