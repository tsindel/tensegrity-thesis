%% Gramian energy ellipsoid plotter
z = [0 1 10 100 1000]'; % z = [0,inf]
kappa = [0 1 10 100 1000]'; % kappa = [0,inf]
eta = [0 0.2 0.4 0.6 0.8]'; % eta = [0,1)

frames = 5;

close all
figure
for i = 1:frames
    d = sqrt(1+kappa(i)*(sqrt(2)-eta(i)));
    mu_c = 2*z(i)/d;
    mu_o = z(i)*(2*kappa(i)^2+1)/d;
    h = ellipse(1,mu_c,0,0,0);
    hold on
end
hold off