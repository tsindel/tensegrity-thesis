function Cs0 = Cs0Matrix(mse,kse,le0,dle0,incidence_table,node_coords,j_bc,x_bc)  
    % Constants
    d = 2/(1+sqrt(9-2*sqrt(2)*(1+sqrt(3))));
    barni_beta = [1 sqrt(2)-1 sqrt(3)-sqrt(2)]';
    ne = length(incidence_table);
    
    % Manipulation matrices
    iPi = invIncidenceMatrix(incidence_table,j_bc,x_bc);
    L0inv = diag(1./le0);
    B = zeros(3*ne,ne);
    for e = 1:ne
        B(3*e-2:3*e,e) = barni_beta;
    end
    Pd = deltaSelectMatrix(ne);
        
    % System matrices
    Mb = matrixMb(mse,le0,incidence_table,j_bc,x_bc);
    Kb = matrixKb(kse,le0,dle0,node_coords,incidence_table,j_bc,x_bc);

    % Eigenmodes
    [U,Omsq] = eig(Kb,Mb); U = orthoNormModal(U,Mb);
    invOm = diag(1./diag(Omsq).^0.5);

    % Length selection matrix
    Sl = absSortLenMatrix(Pd * iPi * U * (1./diag(Omsq.^0.5)));
    
    %% Pre-sensorical matrix
    Cs0 = d * kse(end) * L0inv * B' * Sl * Pd * iPi * U * invOm;
    
end