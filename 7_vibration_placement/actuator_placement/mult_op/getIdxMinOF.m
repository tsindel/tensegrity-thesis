function Idx = getIdxMinOF(a,mse,kse,le0,dle0,incidence_table,NODE_COORDS,...
               j_bc,x_bc,MAXBA_LOCS_NA)
    nn = length(NODE_COORDS(:,1,1)); OFVEC = zeros(3*nn-nnz(x_bc),1);
    for i = 1:3*nn-nnz(x_bc) % compute sum of sums of squares for the i-th mode
        OFivec = 0;
        for op = 1:length(NODE_COORDS(1,1,:))
            OFivec = OFivec + objFcnBa(i,a,mse,kse,le0,dle0,incidence_table,...
                     NODE_COORDS(:,:,op),j_bc,x_bc) / MAXBA_LOCS_NA(i,op);
        end
        OFVEC(i) = OFivec / length(NODE_COORDS(1,1,:));
    end
    [~,Idx] = min(OFVEC);
end

