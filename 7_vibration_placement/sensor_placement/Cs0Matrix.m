function Cs0 = Cs0Matrix(mse,kse,le0,dle0,incidence_table,node_coords,j_bc,x_bc)
    % Manipulation matrices
    iPi = invIncidenceMatrix(incidence_table,j_bc,x_bc);
    L0inv = diag(1./le0);
    H = dirCosMatrixH(node_coords,incidence_table);
        
    % System matrices
    Mb = matrixMb(mse,le0,incidence_table,j_bc,x_bc);
    Kb = matrixKb(kse,le0,dle0,node_coords,incidence_table,j_bc,x_bc);

    % Eigenmodes
    [U,~] = eig(Kb,Mb); U = orthoNormModal(U,Mb);
    
    %% Pre-sensorical matrix
    Cs0 = kse(end) * L0inv * H' * iPi * U;
    
end