%% Plot singular values

% Load gain data
% load Ksingle_alt
% load Kdiag_alt
load Ksingle_altf
load Kdiag_altf

% Create closed-loop plants
% load T1
load T1f
plant = T1;
% Single gain
plant.Blocks.Ci.Value = eye(6); plant.Blocks.gi.Value = Ksingle_altf;
plant1 = plant;
% Multi gain
plant.Blocks.gi.Value = 1; plant.Blocks.Ci.Value = diag(Kdiag_altf);
plant2 = plant;

% Axis params
flim = {1,1e5}; % Hz
flimexp = {0,5}; % Hz
pts = 1000;
yax = logspace(flimexp{1},flimexp{2},pts);

% Singular value bounds
% load OL
load OLf
svOL =      sigma(OL,2*pi*yax);
svsingle =  sigma(plant1,2*pi*yax);
svdiag =    sigma(plant2,2*pi*yax);

svmaxOL = max(svOL,[],1);
svmaxsingle = max(svsingle,[],1);
svmaxdiag = max(svdiag,[],1);

%% Hinf norms
HinfOL = mag2db(norm(OL,Inf));
Hinfsg = mag2db(norm(plant1,Inf));
Hinfdg = mag2db(norm(plant2,Inf));

dHinfsg = HinfOL - Hinfsg
dHinfdg = HinfOL - Hinfdg

%% Plot singular values

close all
% Absolute gains
figure
semilogx(yax,mag2db(svmaxOL),'r',yax,mag2db(svmaxsingle),'b',...
         yax,mag2db(svmaxdiag),'g');
title('Singular values');
xlabel('Frequency (Hz)'); ylabel('Absolute magnitude (dB)');
grid on
legend('Open-loop','Optimal decentralized gain (single)',...
       'Optimal decentralized gain (multiple)','Location','best')

% Relative attenuations
figure
semilogx(yax,mag2db(svmaxOL)-mag2db(svmaxsingle),'r',...
         yax,mag2db(svmaxOL)-mag2db(svmaxdiag),'b');
title('Open-loop attenuation');
xlabel('Frequency (Hz)'); ylabel('Attenuation (dB)');
grid on
legend('Optimal decentralized gain (single)',...
       'Optimal decentralized gain (multiple)','Location','best')