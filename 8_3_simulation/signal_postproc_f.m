%% plot the results
clear
close all

load time_0
load disps_0
load eulangles_0
load transvels_0
load angvels_0

load time_OLf
load disps_OLf
load eulangles_OLf
load transvels_OLf
load angvels_OLf

load time_ifff
load disps_ifff
load eulangles_ifff
load transvels_ifff
load angvels_ifff

load dissipation_f

%% Upsample signals to have the same number of samples

[~,idx]=max([length(time_0) length(time_OLf) length(time_ifff)]);
if idx == 1
    timemax = time_0;
elseif idx == 2
    timemax = time_OLf;
elseif idx == 3
    timemax = time_ifff;
end

disps_0n = interp1(time_0,disps_0,timemax);
eulangles_0n = interp1(time_0,eulangles_0,timemax);
transvels_0n = interp1(time_0,transvels_0,timemax);
angvels_0n = interp1(time_0,angvels_0,timemax);

disps_OLfn = interp1(time_OLf,disps_OLf,timemax);
eulangles_OLfn = interp1(time_OLf,eulangles_OLf,timemax);
transvels_OLfn = interp1(time_OLf,transvels_OLf,timemax);
angvels_OLfn = interp1(time_OLf,angvels_OLf,timemax);

disps_ifffn = interp1(time_ifff,disps_ifff,timemax);
eulangles_ifffn = interp1(time_ifff,eulangles_ifff,timemax);
transvels_ifffn = interp1(time_ifff,transvels_ifff,timemax);
angvels_ifffn = interp1(time_ifff,angvels_ifff,timemax);

dissipation_fn = interp1(time_ifff,dissipation_f,timemax);

%% Error signals
du = disps_OLfn - disps_0n;
dea = eulangles_OLfn - eulangles_0n;
dv = transvels_OLfn - transvels_0n;
dom = angvels_OLfn - angvels_0n;

du1 = disps_ifffn - disps_0n;
dea1 = eulangles_ifffn - eulangles_0n;
dv1 = transvels_ifffn - transvels_0n;
dom1 = angvels_ifffn - angvels_0n;

% Fix NaN problem
du(isnan(du))=0; dea(isnan(dea))=0; dv(isnan(dv))=0; dom(isnan(dom))=0;
du1(isnan(du1))=0; dea1(isnan(dea1))=0; dv1(isnan(dv1))=0; dom1(isnan(dom1))=0;

%% Power spectra (average power attenuation)
% Adjust the response time after the force pulse
du_ = du(timemax>35/(296/2),:);
du1_ = du1(timemax>35/(296/2),:);
dea_ = dea(timemax>35/(296/2),:);
dea1_ = dea1(timemax>35/(296/2),:);
dv_ = dv(timemax>35/(296/2),:);
dv1_ = dv1(timemax>35/(296/2),:);
dom_ = dom(timemax>35/(296/2),:);
dom1_ = dom1(timemax>35/(296/2),:);

u_att = (bandpower(du_) - bandpower(du1_)) ./ ...
         bandpower(du_) * 100 % relative average attenuation in percent

a_att = (bandpower(dea_) - bandpower(dea1_)) ./ ...
         bandpower(dea_) * 100 % relative average attenuation in percent

v_att = (bandpower(dv_) - bandpower(dv1_)) ./ ...
         bandpower(dv_) * 100 % relative average attenuation in percent

om_att = (bandpower(dom_) - bandpower(dom1_)) ./ ...
         bandpower(dom_) * 100 % relative average attenuation in percent

%% Plotting the results
close all

% Open-loop vibrations
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
plot(timemax,dea*180/pi,'Color',[1 0 0 0.75])
hold on
plot(timemax,dea1*180/pi,'b','LineWidth',1)
grid on
title('Angular error')
xlabel('Time (s)')
ylabel('Error (deg)')
ff=get(gca,'Children');
legend([ff(3),ff(4)],'With active damping','Without active damping',...
       'Location','best')

% translational velocities
figure
plot(timemax,transvels_OLfn,'Color',[1 0 0 0.5],'LineWidth',1)
hold on
plot(timemax,transvels_ifffn,'b','LineWidth',1)
hold off
grid on
title('Translational velocity error')
xlabel('Time (s)'); ylabel('v (m/s)');
ff=get(gca,'Children');
legend([ff(3),ff(4)],'With active damping','Without active damping',...
       'Location','best')

%% angular velocities
figure
plot(timemax,dom,'Color',[1 0 0 0.5],'LineWidth',1)
hold on
plot(timemax,dom1,'b','LineWidth',1)
hold off
grid on
title('Angular velocity error')
xlabel('Time (s)'); ylabel('\omega (rad/s)');
ff=get(gca,'Children');
legend([ff(3),ff(4)],'With active damping','Without active damping',...
       'Location','best')
   
%% Together
close all

fig = figure;
fig.Position = [500 10 96*[6 9]];

layout = tiledlayout(4,1,'TileSpacing','compact');
ax1 = nexttile;

plot(timemax,du*1e3,'Color',[1 0 0 0.75])
hold on
plot(timemax,du1*1e3,'b','LineWidth',1)
y1 = ylabel('Displacement (mm)');

ff=get(gca,'Children');
legend([ff(3),ff(4)],'With active damping','Without active damping',...
       'Location','northoutside','Orientation','horizontal')

ax2 = nexttile;
plot(timemax,dea*180/pi,'Color',[1 0 0 0.75])
hold on
plot(timemax,dea1*180/pi,'b','LineWidth',1)
y2 = ylabel('Angle (deg)');

ax3 = nexttile;
plot(timemax,transvels_OLfn,'Color',[1 0 0 0.5],'LineWidth',1)
hold on
plot(timemax,transvels_ifffn,'b','LineWidth',1)
y3 = ylabel('Velocity (m/s)');

ax4 = nexttile;
plot(timemax,dom,'Color',[1 0 0 0.5],'LineWidth',1)
hold on
plot(timemax,dom1,'b','LineWidth',1)
y4 = ylabel('Angular velocity (rad/s)');

linkaxes([ax1,ax2,ax3,ax4],'x');

title(layout,'Disturbance rejection error')
xlabel(layout,'Time (s)')

ydist = 0.05;
set(y1, 'Units', 'Normalized', 'Position', [-ydist, 0.5, 0]);
set(y2, 'Units', 'Normalized', 'Position', [-ydist, 0.5, 0]);
set(y3, 'Units', 'Normalized', 'Position', [-ydist, 0.5, 0]);
set(y4, 'Units', 'Normalized', 'Position', [-ydist, 0.5, 0]);

%% Energy dissipation
figure
layout = tiledlayout(1,2);
ax1 = nexttile;
plot(timemax,dissipation_fn)
ylabel('Dissipation power (W)')
ax2 = nexttile;
plot(timemax,mag2db(dissipation_fn))
ylabel('Dissipation power (dB)')
linkaxes([ax1,ax2],'x');
title(layout,'Energy dissipation by control')
xlabel(layout,'Time (s)')
h = legend('1','2','3','4','5','6','Orientation','vertical',...
    'Location','eastoutside');
title(h,'Cable #')

