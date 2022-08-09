%%  Compute functiona in different configs separately
load('AOPT'); load('MAXBA_LOCS');

%% Relative to 'na' actuators
rel_note = 'the same # of actuators';
Results = zeros(nc,11);
for na = 1:nc
    aOpt = [zeros(1,6) AOPT(na,:)]; % only for cables: e=7:end
    
    % Get mode number of LCM mode
    idxLCM = getIdxMinOF(aOpt,mse,kse,le0,dle0,incidence_table,NODE_COORDS,...
                         j_bc,x_bc,MAXBA_LOCS(:,:,na));
                     
    % Compute function values in configs for the optimal actuator placement
    fOpt1st = OFvector(1,aOpt,mse,kse,le0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXBA_LOCS(:,:,na));
    fOpt2nd = OFvector(2,aOpt,mse,kse,le0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXBA_LOCS(:,:,na));
    fOptLCM = OFvector(idxLCM,aOpt,mse,kse,le0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXBA_LOCS(:,:,na));
              % LCM - least controllable mode

    % Compute mean and standard deviation for the configurationa
    val1st = mean(fOpt1st); err1st_p = max(fOpt1st) - val1st; err1st_n = val1st - min(fOpt1st);    
    val2nd = mean(fOpt2nd); err2nd_p = max(fOpt2nd) - val2nd; err2nd_n = val2nd - min(fOpt2nd);
    valLCM = mean(fOptLCM); errLCM_p = max(fOptLCM) - valLCM; errLCM_n = valLCM - min(fOptLCM);  

    % Concatenate and save results
    Results(na,:) = [na val1st err1st_p err1st_n val2nd err2nd_p ...
                     err2nd_n valLCM errLCM_p errLCM_n idxLCM];
end
% Relative to 'na' actuators

%% Relative to 1 actuator
rel_note = 'single actuator';
Results = zeros(nc,11);
for na = 1:nc
    aOpt = [zeros(1,6) AOPT(na,:)]; % only for cables: e=7:end
    
    % Get mode number of LCM mode
    idxLCM = getIdxMinOF(aOpt,mse,kse,le0,dle0,incidence_table,NODE_COORDS,...
                         j_bc,x_bc,MAXBA_LOCS(:,:,1));

    % Compute function values in configs for the optimal actuator placement
    fOpt1st = OFvector(1,aOpt,mse,kse,le0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXBA_LOCS(:,:,1));
    fOpt2nd = OFvector(2,aOpt,mse,kse,le0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXBA_LOCS(:,:,1));
    fOptLCM = OFvector(idxLCM,aOpt,mse,kse,le0,incidence_table,...
              NODE_COORDS,j_bc,x_bc,MAXBA_LOCS(:,:,1));
              % LCM - least controllable mode

    % Compute mean and standard deviation for the configurationa
    val1st = mean(fOpt1st); err1st_p = max(fOpt1st) - val1st; err1st_n = val1st - min(fOpt1st);    
    val2nd = mean(fOpt2nd); err2nd_p = max(fOpt2nd) - val2nd; err2nd_n = val2nd - min(fOpt2nd);
    valLCM = mean(fOptLCM); errLCM_p = max(fOptLCM) - valLCM; errLCM_n = valLCM - min(fOptLCM);  

    % Concatenate and save results
    Results(na,:) = [na val1st err1st_p err1st_n val2nd err2nd_p ...
                     err2nd_n valLCM errLCM_p errLCM_n idxLCM];
end
% Relative to 1 actuator

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
title(['Best controllability plot (relative to ' rel_note ')']);
xlabel('Number of actuators'); ylabel('Relative controllability (1)');
upb = max(Results(:,[2 4 6]),[],'all');
lwb = min(Results(:,[2 4 6]),[],'all');
vertmargin = 0.1 * abs(upb - lwb);
axis([0.5 nc+0.5 lwb-vertmargin upb+vertmargin]); grid on; xticks([1:nc]);
LCMstr = 'Least controllable mode (with index)';
legend({'First mode','Second mode',LCMstr},'Location','southeast');

