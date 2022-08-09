function OFVEC = objFcnVector(p,mse,kse,le0,dle0,incidence_table,NODE_COORDS,...
                              j_bc,x_bc,MAXSIG_LOCS_NI)
    % Computes the objective function through all operating points    
    nn = length(NODE_COORDS(:,1,1)); OFVEC = zeros(6*nn-2*nnz(x_bc),1);
    for i = 1:6*nn-2*nnz(x_bc) % compute sum of sum of i-th singular value across all operating points
        OFivec = 0;
        for op = 1:length(NODE_COORDS(1,1,:))
            OFivec = OFivec + objFcnCs(i,p,mse,kse,le0,dle0,...
                     incidence_table,NODE_COORDS(:,:,op),j_bc,x_bc) / ...
                     MAXSIG_LOCS_NI(i,op);
        end
        OFVEC(i) = OFivec;
    end
end

