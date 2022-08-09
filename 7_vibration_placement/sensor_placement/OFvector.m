function OF = OFvector(i,s,mse,kse,le0,incidence_table,NODE_COORDS,...
                       j_bc,x_bc,MAXBA_LOCS_NA)
    OF = zeros(length(NODE_COORDS(1,1,:)),1);
    le_init = elemLengths(incidence_table,NODE_COORDS(:,:,1));
    dle0 = le_init - le0; % constant through all configurations
    for op = 1:length(NODE_COORDS(1,1,:))
        % initial lengths (free lengths in initial configuration)
        Cs0 = Cs0Matrix(mse,kse,le0,dle0,incidence_table,...
                        NODE_COORDS(:,:,op),j_bc,x_bc);
        OF(op) = objFcnCs(i,s,Cs0) / MAXBA_LOCS_NA(i,op);
    end
end

