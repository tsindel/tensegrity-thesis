function le = elemLengths(incidence_table,node_coords)
    % Compute element lengths
    ne = length(incidence_table);
    le = zeros(ne,1);
    for e = 1:ne
        ri = incidence_table(e,1)'; rj = incidence_table(e,2)';
        le(e) = norm(node_coords(rj,:) - node_coords(ri,:));
    end
end

