function Kb = matrixKb(kse,le0,dle0,node_coords,incidence_table,j_bc,x_bc)
    ne = length(incidence_table);

    Ke = zeros(6*ne);
    for e = 1:ne
        ri = incidence_table(e,1)'; rj = incidence_table(e,2)';
        le = norm(node_coords(rj,:) - node_coords(ri,:));
        ue = (node_coords(rj,:) - node_coords(ri,:))' / le;
        h = [-ue; ue]';
        dle = le - le0(e);
        R = [-eye(3); eye(3)];
        % elemental tangent stiffness
        Ke(6*e-5:6*e,6*e-5:6*e) = kse(e) * (1/le * (h'*h) + (dle + ...
                                  dle0(e))/le/le0(e) * (R*R' - (R*ue)...
                                  * (R*ue)'));
    end
    Pi = incidenceMatrix(incidence_table,j_bc,x_bc);
    Kb = Pi * Ke * Pi';
end

