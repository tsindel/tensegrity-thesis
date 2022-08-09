%% vykresleni struktury
figure_plot = 1;
if(figure_plot==1)
  figure(10);
  clf;
  grid on;
  axis equal;
  xlabel('x');
  ylabel('y');
  zlabel('z');
  view(16, 22);
  node_plot(N);
  bar_plot(B, N);
  cable_plot(C, N);
  platform_plot(N, [1 2 3]);
  platform_plot(N, [7 8 9]);
  hold on
  phi=[0:0.1:2*pi];
  plot3(r_base*cos(phi), r_base*sin(phi), 0*phi, '--k');
  plot3(r_mid*cos(phi), r_mid*sin(phi), 0*phi+v1, '--k');
  plot3(r_top*cos(phi), r_top*sin(phi), 0*phi+v1+v2, '--k');
  %end platform coordinate system
  Sp=(sum(N([7 8 9], :))/3);
  plot3(Sp(1), Sp(2), Sp(3), '.k', 'MarkerSize', 10);
  plot3([Sp(1), N(7, 1)], [Sp(2), N(7, 2)], [Sp(3), N(7, 3)], '-r', 'LineWidth', 1)% X-axis RED
  plot3([Sp(1), Sp(1)], [Sp(2), Sp(2)], [Sp(3), Sp(3)+r_base], '-b', 'LineWidth', 1)% Z-axis BLUE
  Yax=cross([0 0 1], [N(7, :)-Sp]);
  plot3([Sp(1), Sp(1)+Yax(1)], [Sp(2), Sp(2)+Yax(2)], [Sp(3), Sp(3)+Yax(3)], '-g', 'LineWidth', 1)% Y-axis GREEN

  %vykresleni_souradnicovych systemu tyci 1-3
  Sg=[2.0 0     0
      0   2.0   0
      0   0   2.0];
  csys_plot([0 0 0], Sg);
  
  %vykresleni_souradnicovych systemu tyci 1-3
  S1=matrix_S(N(1, :), N(5,:));
  csys_plot(N(1, :), S1);
  S2=matrix_S(N(2, :), N(6,:));
  csys_plot(N(2, :), S2);
  S3=matrix_S(N(3, :), N(4,:));
  csys_plot(N(3, :), S3);
end
