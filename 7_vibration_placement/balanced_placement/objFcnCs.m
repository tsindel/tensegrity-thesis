function OF = objFcnCs(i,p,mse,kse,le0,dle0,incidence_table,node_coords,j_bc,x_bc)

    % Interactor placement matrices
    Ss = selectionMatrix(p,'sensor'); % define sensor occupation from vector input
    Sa = selectionMatrix(p,'actuator'); % define actuator occupation from vector input
    
    %% Manipulation matrices
    Pi = incidenceMatrix(incidence_table,j_bc,x_bc);
    H = dirCosMatrixH(node_coords,incidence_table);
    
    % Jacobians
    Js = Ss * H' * Pi';
    Ja = Pi * H * Sa;
    
    %% System matrices
    Mb = matrixMb(mse,le0,incidence_table,j_bc,x_bc);
    Kb = matrixKb(kse,le0,dle0,node_coords,incidence_table,j_bc,x_bc);

    % Eigenmodes
    [U,Omsq] = eig(Kb,Mb); U = orthoNormModal(U,Mb);
    Om = Omsq.^(1/2); Omi = diag(1./diag(Om));
    
    %% State-space formulation
    Del = 0.2 * eye(size(Om)); % abritrary (identify from model)
    A = [zeros(size(Om)) Om; -Om -Del];
    B = [zeros(size(Om,1),nnz(p)); U' * Ja];
    C = [kse(end) * diag(1./le0(logical(p))) * Js * U * Omi zeros(nnz(p),size(Om,2))];
    D = zeros(nnz(p));

    SYS = ss(A,B,C,D);
    
    % Hankel singular values (balanced system)
    sig = hankelsv(SYS);
    
    % Objective function for the i-th STATE
    OF = sig(i);
    
end
