function Pi = incidenceMatrix(incidence_table,j_bc,x_bc)
    if 3 * length(j_bc) ~= length(x_bc)
        disp('Boundary conditions specified incorrectly.')
        return
    end

    ne = length(incidence_table);         % number of elements
    nn = length(unique(incidence_table)); % number of nodes
    
    Pi = zeros(3*nn,6*ne);
    for e = 1:ne    % for all elements
        for i = 1:2 % for both local nodes
            j = incidence_table(e,i); % get the global node number
            Pi(3*j-2:3*j,6*(e-1)+3*i-2:6*(e-1)+3*i) = eye(3);
        end
    end
    
    % Matrix modification - boundary conditions
    BCvec = zeros(length(x_bc),1);
    for k = 1:length(j_bc)
        j = j_bc(k);
        BCvec(3*j-2:3*j) = x_bc(3*j-2:3*j).*(3*j-2:3*j)';
    end
    Pi(BCvec(BCvec~=0),:) = [];
end

