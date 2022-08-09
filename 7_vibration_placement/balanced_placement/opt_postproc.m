%%  Compute functions in different configs separately
load('POPT'); load('MAXSIG_LOCS');
nc=15;
parameters_dvoupatrak;
%% Relative to 'ns' sensors
rel_note = 'the same # of sensors';
Results = zeros(nc,11);
nc = 15;
for ns = 1:nc
    pOpt = [zeros(1,6) POPT(ns,:)]; % only for cables: e=7:end
    
    % Get mode number of LOM mode
    ofvec = objFcnVector(pOpt,mse,kse,le0,dle0,incidence_table,NODE_COORDS,...
                         j_bc,x_bc,MAXSIG_LOCS(:,:,ns));
    [~,idxLOM] = min(ofvec);

    % Compute function values in configs for the optimal interactor placement
    fOpt1st = OFvector(1,pOpt,mse,kse,le0,dle0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXSIG_LOCS(:,:,ns));
    fOpt2nd = OFvector(2,pOpt,mse,kse,le0,dle0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXSIG_LOCS(:,:,ns));
    fOptLOM = OFvector(idxLOM,pOpt,mse,kse,le0,dle0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXSIG_LOCS(:,:,ns));
              % LOM - least controllable mode

    % Compute mean and deviations for the configurations
    val1st = mean(fOpt1st); err1st_p = max(fOpt1st) - val1st; err1st_n = val1st - min(fOpt1st);    
    val2nd = mean(fOpt2nd); err2nd_p = max(fOpt2nd) - val2nd; err2nd_n = val2nd - min(fOpt2nd);
    valLOM = mean(fOptLOM); errLOM_p = max(fOptLOM) - valLOM; errLOM_n = valLOM - min(fOptLOM);  

    % Concatenste and save results
    Results(ns,:) = [ns val1st err1st_p err1st_n val2nd err2nd_p ...
                     err2nd_n valLOM errLOM_p errLOM_n idxLOM];
end
% Relative to 'ns' interactors

%% Relative to 1 sensor
rel_note = 'single sensor';
Results = zeros(nc,11);
for ns = 1:nc
    pOpt = [zeros(1,6) POPT(ns,:)]; % only for cables: e=7:end
    
    % Get mode number of LOM mode
    ofvec = objFcnVector(pOpt,mse,kse,le0,dle0,incidence_table,NODE_COORDS,...
                         j_bc,x_bc,MAXSIG_LOCS(:,:,1));
    [~,idxLOM] = min(ofvec);

    % Compute function values in configs for the optimal interactor placement
    fOpt1st = OFvector(1,pOpt,mse,kse,le0,dle0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXSIG_LOCS(:,:,1));
    fOpt2nd = OFvector(2,pOpt,mse,kse,le0,dle0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXSIG_LOCS(:,:,1));
    fOptLOM = OFvector(idxLOM,pOpt,mse,kse,le0,dle0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXSIG_LOCS(:,:,1));
              % LOM - least controllable mode

    % Compute mean and deviations for the configurations
    val1st = mean(fOpt1st); err1st_p = max(fOpt1st) - val1st; err1st_n = val1st - min(fOpt1st);    
    val2nd = mean(fOpt2nd); err2nd_p = max(fOpt2nd) - val2nd; err2nd_n = val2nd - min(fOpt2nd);
    valLOM = mean(fOptLOM); errLOM_p = max(fOptLOM) - valLOM; errLOM_n = valLOM - min(fOptLOM);  

    % Concatenste and save results
    Results(ns,:) = [ns val1st err1st_p err1st_n val2nd err2nd_p ...
                     err2nd_n valLOM errLOM_p errLOM_n idxLOM];
end
% Relative to 1 sensor

%% Plot results
close all

figure(1)
errscale = .2; % scale down the spread
errorbar(1:nc,Results(:,2),errscale*Results(:,4),errscale*Results(:,3),...
         '-o','Markersize',8,'MarkerFaceColor','g','LineWidth',0.8);
hold on
errorbar(1:nc,Results(:,5),errscale*Results(:,7),errscale*Results(:,6),...
         '-o','Markersize',8,'MarkerFaceColor','b','LineWidth',0.8);
hold on
errorbar(1:nc,Results(:,8),errscale*Results(:,10),errscale*Results(:,9),...
         '-o','Markersize',8,'MarkerFaceColor','r','LineWidth',0.8);
hold on
text(1:nc,Results(:,8),num2str(Results(:,11)),'FontWeight','normal',...
     'VerticalAlignment','top','HorizontalAlignment','left');

% Adjust details
title(['Best balanced interaction plot (relative to ' rel_note ')']);
xlabel('Number of interactors'); ylabel('DEBI (1)');
upb = max(Results(:,[2 5 8]),[],'all');
lwb = min(Results(:,[2 5 8]),[],'all');
vertmargin = 0.1 * abs(upb - lwb);
axis([0.5 nc+0.5 lwb-vertmargin upb+vertmargin]); grid on; xticks([1:nc]);
LOMstr = 'Least energy HSV (with index)';
legend({'First SV','Second SV',LOMstr},'Location','southeast');

