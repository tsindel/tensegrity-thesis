function OF = OFvector(i,p,mse,kse,le0,dle0,incidence_table,NODE_COORDS,...
                       j_bc,x_bc)
    OF = 0;
    for op = 1:length(NODE_COORDS(1,1,:))
        OF = OF + objFcnCs(i,p,mse,kse,le0,dle0,incidence_table,...
                           NODE_COORDS(:,:,op),j_bc,x_bc);
    end

