function OF = multPtsOF(a,mse,kse,le0,incidence_table,NODE_COORDS,...
              j_bc,x_bc,MAXBA_LOCS_NA)
    % Computes the objective function through all operating points    
    nn = length(NODE_COORDS(:,1,1)); OFVEC = zeros(3*nn-nnz(x_bc),1);
    le_init = elemLengths(incidence_table,NODE_COORDS(:,:,1));
    dle0 = le_init - le0;
    for i = 1:3*nn-nnz(x_bc) % compute sum of sums of squares for the i-th mode
        OFivec = 0;
        for op = 1:length(NODE_COORDS(1,1,:))
            OFivec = OFivec + objFcnBa(i,a,mse,kse,le0,dle0,incidence_table,...
                     NODE_COORDS(:,:,op),j_bc,x_bc) / MAXBA_LOCS_NA(i,op);
        end
        OFVEC(i) = OFivec;
    end
    OF = min(OFVEC) / length(NODE_COORDS(1,1,:));
end

