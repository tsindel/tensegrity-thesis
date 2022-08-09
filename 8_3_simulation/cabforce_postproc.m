clear

load cabforces_0
load cabforces_OL
load cabforces_iff

%% Upsample signals to have the same number of samples

[~,idx]=max([length(cabforces_0.Time) length(cabforces_OL.Time) length(cabforces_iff.Time)]);
if idx == 1
    timemax = cabforces_0.Time(cabforces_0.Time>0.5);
elseif idx == 2
    timemax = cabforces_OL.Time(cabforces_OL.Time>0.5);
elseif idx == 3
    timemax = cabforces_iff.Time(cabforces_iff.Time>0.5);
end

f0 = interp1(cabforces_0.Time(cabforces_0.Time>0.5,:),cabforces_0.Data(cabforces_0.Time>0.5,:),timemax);
f1 = interp1(cabforces_OL.Time(cabforces_OL.Time>0.5,:),cabforces_OL.Data(cabforces_OL.Time>0.5,:),timemax);
f2 = interp1(cabforces_iff.Time(cabforces_iff.Time>0.5,:),cabforces_iff.Data(cabforces_iff.Time>0.5,:),timemax);

%% Force deviations
df1 = f1 - f0; df2 = f2 - f0;

%% Plot
close all

figure
layout = tiledlayout(1,2);
ax1 = nexttile;
plot(timemax-0.5,df1)
ylim([-200;+200])
title('Open-loop')
grid on
ax2 = nexttile;
plot(timemax-0.5,df2)
ylim([-200;+200])
title('Closed-loop')
grid on
linkaxes([ax1,ax2],'x');
title(layout,'Force deviation')
xlabel(layout,'Time (s)')
ylabel(layout,'\Delta F_c (N)')
h = legend('1','2','3','4','5','6','Orientation','vertical',...
    'Location','eastoutside');
title(h,'Cable #')