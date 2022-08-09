clear, close all

% Def params
steps = 1000;
z = logspace(-3,3,steps); % damping ratios ratio ... z = [0,inf]
kappa = logspace(0,6,steps); % stiffness ratio ... kappa = [0,inf]
eta = linspace(0,0.999,steps); % cable deformation ... eta = [0,1)

% Default constant values
kappa_ = 10; % strut 10x stiffer than cable
eta_ = 0.01; % one percent deformation
z_ = 1; % equal damping of 1st and 2nd mode

mu_cz = zeros(steps,1); mu_oz = zeros(steps,1);
for i = 1:steps
    d = sqrt(1+2^(1/2)*kappa_*(1-eta_));
    mu_cz(i) = 2*z(i)/d;
    mu_oz(i) = z(i)*(2*kappa_^2+1)/d;
end

mu_ck = zeros(steps,1); mu_ok = zeros(steps,1);
for i = 1:steps
    d = sqrt(1+2^(1/2)*kappa(i)*(1-eta_));
    mu_ck(i) = 2*z_/d;
    mu_ok(i) = z_*(2*kappa(i)^2+1)/d;
end

mu_ce = zeros(steps,1); mu_oe = zeros(steps,1);
for i = 1:steps
    d = sqrt(1+2^(1/2)*kappa_*(1-eta(i)));
    mu_ce(i) = 2*z_/d;
    mu_oe(i) = z_*(2*kappa_^2+1)/d;
end

%% Plot
close all

figure(1)
loglog(z,mu_cz,z,mu_oz,'Linewidth',1)
title('Gramian PC ratio vs. damping ratio ratio')
xlabel('z'); ylabel('\mu');
legend('Controllability','Observability','Location','best');
grid on

figure(2)
loglog(kappa,mu_ck,kappa,mu_ok,'Linewidth',1)
title('Gramian PC ratio vs. stiffness ratio')
xlabel('\kappa'); ylabel('\mu');
legend('Controllability','Observability','Location','best');
grid on

figure(3)
semilogy(eta,mu_ce,eta,mu_oe,'Linewidth',1)
title('Gramian PC ratio vs. cable inital deformation')
xlabel('\eta'); ylabel('\mu');
legend('Controllability','Observability','Location','best');
grid on