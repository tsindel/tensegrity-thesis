close all

load plantsys

nio = 6; % number of collocated pairs

plotoptions = sigmaoptions;
plotoptions.FreqUnits = 'Hz';
plotoptions.Grid = 'on';
plotoptions.XLim = {[1,1e5]};

openLoop = lft(plantsys,ss(zeros(nio),zeros(nio),zeros(nio),zeros(nio)));
F0 = ss(eye(nio) * tf([1 0],[1 1]));    % weight filter for y (highpass)

%% Full H-infinity controller synthesis
[Kfull,CLfull,~] = hinfsyn(plantsys,nio,nio);

%% Define SS and name IOs
load HinfSS;
C0same = ss(zeros(nio),-eye(nio),diag(0.003*ones(nio,1)),zeros(nio));
C0diag = ss(zeros(nio),-eye(nio),diag(Kdiag),zeros(nio));
% C0full = ss(zeros(nio),-eye(nio),Kfull,zeros(nio));
C0hinf = HinfSS;

for i = 1:nio
    F0.u{i} =     ['y' num2str(i)];     F0.y{i} = ['v' num2str(i)];
    C0same.u{i} = ['v' num2str(i)]; C0same.y{i} = ['u' num2str(i)];
    C0diag.u{i} = ['v' num2str(i)]; C0diag.y{i} = ['u' num2str(i)];
    C0full.u{i} = ['v' num2str(i)]; C0full.y{i} = ['u' num2str(i)];
    C0hinf.u{i} = ['v' num2str(i)]; C0hinf.y{i} = ['u' num2str(i)];
end

%% Diagonal gain IFF (same for all)
figure(4);

CTRsame = connect(F0,C0same,F0.u,C0same.y); % append the controller to a high-pass filter
CLsame = lft(plantsys,CTRsame);
sigmaplot(openLoop,'r',CLsame,'b',plotoptions);

title('Diagonal gain matrix IFF');
legend({'Open-loop','Closed-loop'});

%% Diagonal gain IFF
figure(1);

CTRdiag = connect(F0,C0diag,F0.u,C0diag.y); % append the controller to a high-pass filter
CLdiag = lft(plantsys,CTRdiag);
sigmaplot(openLoop,'r',CLdiag,'b',plotoptions);

title('Diagonal gain matrix IFF');
legend({'Open-loop','Closed-loop'});

%% Full gain IFF
figure(2);

CTRfull = connect(F0,C0full,F0.u,C0full.y); % append the controller to a high-pass filter
CLfull = lft(plantsys,CTRfull);
sigmaplot(openLoop,'r',CLfull,'b',plotoptions);

title('Full gain matrix IFF');
legend({'Open-loop','Closed-loop'});

%% Full gain general Hinf
figure(3);

CTRhinf = connect(F0,C0hinf,F0.u,C0hinf.y); % append the controller to a high-pass filter
CLhinf = lft(plantsys,CTRhinf);
sigmaplot(openLoop,'r',CLhinf,'b',plotoptions);

title('Full gain matrix general Hinf');
legend({'Open-loop','Closed-loop'});

%% Compute Hinf norms for all three cases (max Hinf norm across all linpoints)
wlim = {1,1e5};

% Open-loop
for i = 1:lin_points
    [sv0,~] = sigma(openLoop(:,:,i,1),wlim);
    SV(i) = max(sv0,[],'all');
end
Hinf_OL = mag2db(max(SV))

% Single-gain IFF
[sv1,~] = sigma(CLopt_single,wlim);
SV = max(sv1,[],'all');
Hinf_singleiff = mag2db(max(SV))

% Diagonal IFF
[sv2,~] = sigma(CLopt_diag,wlim);
SV = max(sv2,[],'all');
Hinf_diagiff = mag2db(max(SV))

% Full IFF
[sv3,~] = sigma(CLopt_full,wlim);
SV = max(sv3,[],'all');
Hinf_fulliff = mag2db(max(SV))

