function Mb = matrixMb(mse,le0,incidence_table,j_bc,x_bc)
    ne = length(incidence_table);
    me = mse.*le0; % mse...elem. specific mass, le0...elem. free length

    Me = zeros(6*ne);
    for e = 1:ne
        Me(6*e-5:6*e,6*e-5:6*e) = me(e) * [2*eye(3) -eye(3); -eye(3) 2*eye(3)];
    end
    Pi = incidenceMatrix(incidence_table,j_bc,x_bc);
    Mb = Pi * Me * Pi';
end

