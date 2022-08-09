function H = dirCosMatrixH(node_coords,incidence_table)
    nn = length(node_coords);
    ne = length(incidence_table);

    H = zeros(6*ne,ne);
    for e = 1:ne
        ri = incidence_table(e,1)'; rj = incidence_table(e,2)';
        ue = normalize(node_coords(rj,:) - node_coords(ri,:),'norm')';
        H(6*e-5:6*e,e) = [-ue; ue]; % h'
    end
end

