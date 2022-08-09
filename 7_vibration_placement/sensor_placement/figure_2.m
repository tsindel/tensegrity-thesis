kappa = linspace(0,5,100);
po1 = 1./(2*kappa.^2+1);

close all
figure
plot(kappa,po1,'linewidth',2)
xlabel('{k_s^b/k_s^c}')
ylabel('p_1^o')