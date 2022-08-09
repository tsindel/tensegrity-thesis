%% plot the results
clear
close all

load time_0
load disps_0
load eulangles_0
load transvels_0
load angvels_0

load time_OL
load disps_OL
load eulangles_OL
load transvels_OL
load angvels_OL

load time_iff
load disps_iff
load eulangles_iff
load transvels_iff
load angvels_iff

load top_noise_sig
load bot_noise_sig

load disps
load disps_d
load eulangles
load eulangles_d
load time_smooth

%% Upsample signals to have the same number of samples

[~,idx]=max([length(time_0) length(time_OL) length(time_iff)]);
if idx == 1
    timemax = time_0;
elseif idx == 2
    timemax = time_OL;
elseif idx == 3
    timemax = time_iff;
end

disps_0 = interp1(time_0,disps_0,timemax);
eulangles_0 = interp1(time_0,eulangles_0,timemax);
transvels_0 = interp1(time_0,transvels_0,timemax);
angvels_0 = interp1(time_0,angvels_0,timemax);

disps_OL = interp1(time_OL,disps_OL,timemax);
eulangles_OL = interp1(time_OL,eulangles_OL,timemax);
transvels_OL = interp1(time_OL,transvels_OL,timemax);
angvels_OL = interp1(time_OL,angvels_OL,timemax);

disps_iff = interp1(time_iff,disps_iff,timemax);
eulangles_iff = interp1(time_iff,eulangles_iff,timemax);
transvels_iff = interp1(time_iff,transvels_iff,timemax);
angvels_iff = interp1(time_iff,angvels_iff,timemax);

dissipation = interp1(time_iff,dissipation,timemax);

%% Error signals
du = disps_OL - disps_0;
dea = eulangles_OL - eulangles_0;
dv = transvels_OL - transvels_0;
dom = angvels_OL - angvels_0;

du1 = disps_iff - disps_0;
dea1 = eulangles_iff - eulangles_0;
dv1 = transvels_iff - transvels_0;
dom1 = angvels_iff - angvels_0;

% Fix NaN problem
du(isnan(du))=0; dea(isnan(dea))=0; dv(isnan(dv))=0; dom(isnan(dom))=0;
du1(isnan(du1))=0; dea1(isnan(dea1))=0; dv1(isnan(dv1))=0; dom1(isnan(dom1))=0;

%% Power spectra (average power attenuation)

u_att = (bandpower(du) - bandpower(du1)) ./ ...
         bandpower(du) * 100 % relative average attenuation in percent

a_att = (bandpower(dea) - bandpower(dea1)) ./ ...
         bandpower(dea) * 100 % relative average attenuation in percent

v_att = (bandpower(dv) - bandpower(dv1)) ./ ...
         bandpower(dv) * 100 % relative average attenuation in percent

om_att = (bandpower(dom) - bandpower(dom1)) ./ ...
         bandpower(dom) * 100 % relative average attenuation in percent

% Disturbance signal characteristics
RMStop = mean(sqrt(mean(top_noise_sig.^2)))
RMSbot = mean(sqrt(mean(bot_noise_sig.^2)))

%% Plotting the results
close all

tsm = time_smooth(time_smooth>0.5) - 0.5;

% Smooth responses
figure
plot(tsm,(disps - disps_d)*1e3)
grid on
title('Task-space displacement CTC error')
xlabel('Time (s)')
ylabel('Error (mm)')
legend('x','y','z','Location','best')

figure
plot(tsm,(eulangles - eulangles_d)*180/pi)
grid on
title('Task-space angular CTC error')
xlabel('Time (s)')
ylabel('Error (deg)')
legend('Yaw','Pitch','Roll','Location','best')

%% Vibrations
%% White noise
figure
layout = tiledlayout(2,1,'TileSpacing','compact');
ax1 = nexttile;
plot(timemax,du*1e3,'Color',[1 0 0 0.75])
hold on
plot(timemax,du1*1e3,'b','LineWidth',1)
y1 =ylabel('Displacement (mm)');

ff=get(gca,'Children');
legend([ff(3),ff(4)],'With active damping','Without active damping',...
       'Location','best','Location','northoutside','Orientation',...
       'horizontal')

ax2 = nexttile;
plot(timemax,transvels_OL,'Color',[1 0 0 0.5],'LineWidth',1)
hold on
plot(timemax,transvels_iff,'b','LineWidth',1)
y2 = ylabel('Velocity (m/s)');

linkaxes([ax1,ax2],'x');
title(layout,'Disturbance rejection error')
xlabel(layout,'Time (s)')

ydist = 0.07;
set(y1, 'Units', 'Normalized', 'Position', [-ydist, 0.5, 0]);
set(y2, 'Units', 'Normalized', 'Position', [-ydist, 0.5, 0]);

%%
figure
plot(timemax,du*1e3,'Color',[1 0 0 0.75])
hold on
plot(timemax,du1*1e3,'b','LineWidth',1)
grid on
title('Displacement error')
xlabel('Time (s)')
ylabel('Error (mm)')
ff=get(gca,'Children');
legend([ff(3),ff(4)],'With active damping','Without active damping',...
       'Location','best')

% euler angle errors (yaw,pitch,roll)
figure
plot(timemax,dea*1e3,'Color',[1 0 0 0.75])
hold on
plot(timemax,dea1*1e3,'b','LineWidth',1)
grid on
title('Angular error')
xlabel('Time (s)')
ylabel('Error (deg)')
ff=get(gca,'Children');
legend([ff(3),ff(4)],'With active damping','Without active damping',...
       'Location','best')

% translational velocities
figure
plot(timemax,transvels_OL,'Color',[1 0 0 0.5],'LineWidth',1)
hold on
plot(timemax,transvels_iff,'b','LineWidth',1)
hold off
grid on
title('Translational velocity error')
xlabel('Time (s)'); ylabel('v (m/s)');
ff=get(gca,'Children');
legend([ff(3),ff(4)],'With active damping','Without active damping',...
       'Location','best')

% angular velocities
figure
plot(timemax,dom,'Color',[1 0 0 0.5],'LineWidth',1)
hold on
plot(timemax,dom1,'b','LineWidth',1)
hold off
grid on
title('Closed-loop angular velocity comparison')
xlabel('Time (s)'); ylabel('\omega (rad/s)');
ff=get(gca,'Children');
legend([ff(3),ff(4)],'With active damping','Without active damping',...
       'Location','best')
%% Energy dissipation
load dissipation
load dissipation_f

figure
layout = tiledlayout(2,2,'TileSpacing','compact');

ax1 = nexttile;
plot(timemax,dissipation)
y1 = ylabel('Dissipation power (W)');
t1 = title('White noise');

ax2 = nexttile;
plot(timemax,dissipation_f(6:end,:))
t2 = title('Force impulse');

ax3 = nexttile;
plot(timemax,mag2db(dissipation))
y2 = ylabel('Dissipation power (dB)');

ax4 = nexttile;
plot(timemax,mag2db(dissipation_f(6:end,:)))

linkaxes([ax1,ax2,ax3,ax4],'x');
linkaxes([ax3,ax4],'y');
xlabel(layout,'Time (s)')

title(layout,{'Energy dissipation by IFF control',' '});
h = legend('1','2','3','4','5','6','Orientation','vertical',...
    'Location','southeastoutside');
title(h,'Cable #')

ydist = 0.15; tdist = 0.1;
set(y1, 'Units', 'Normalized', 'Position', [-ydist, 0.5, 0]);
set(y2, 'Units', 'Normalized', 'Position', [-ydist, 0.5, 0]);
set(t1, 'Units', 'Normalized', 'Position', [0.5, 1+tdist, 0]);
set(t2, 'Units', 'Normalized', 'Position', [0.5, 1+tdist, 0]);

