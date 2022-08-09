function OF = multPtsOF(s,mse,kse,le0,dle0,incidence_table,NODE_COORDS,...
                        j_bc,x_bc,MAXCS_LOCS_NA)
    % Computes the objective function through all operating points    
    nn = length(NODE_COORDS(:,1,1)); OFVEC = zeros(3*nn-nnz(x_bc),1);
    for i = 1:3*nn-nnz(x_bc) % compute sum of sums of squares for the i-th mode
        OFivec = 0;
        for op = 1:length(NODE_COORDS(1,1,:))
            Cs0 = Cs0Matrix(mse,kse,le0,dle0,incidence_table,...
                            NODE_COORDS(:,:,op),j_bc,x_bc);
            OFivec = OFivec + objFcnCs(i,s,Cs0) / MAXCS_LOCS_NA(i,op);
        end
        OFVEC(i) = OFivec;
    end
    OF = min(OFVEC) / length(NODE_COORDS(1,1,:));
end

