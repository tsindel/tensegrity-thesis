function out = pickOFIdx(a,mse,kse,le0,incidence_table,NODE_COORDS,...
              j_bc,x_bc,MAXBA_LOCS_NA,output)
    outs = multPtsOF(a,mse,kse,le0,incidence_table,NODE_COORDS,...
                     j_bc,x_bc,MAXBA_LOCS_NA);
    out = outs(output);
end

