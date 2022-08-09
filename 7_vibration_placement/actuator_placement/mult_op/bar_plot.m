%%vykresleni lan

function vykresli_lana(C, N)

hold on;

for(i=1:size(C, 1))
  plot3([N(C(i, 1), 1), N(C(i, 2), 1)], [N(C(i, 1), 2), N(C(i, 2), 2)], [N(C(i, 1), 3), N(C(i, 2), 3)], '-k', 'LineWidth', 3)
  text((N(C(i, 1), 1)+N(C(i, 2), 1))/2, (N(C(i, 1), 2)+N(C(i, 2), 2))/2, (N(C(i, 1), 3)+N(C(i, 2), 3))/2, ['B', num2str(i)]);
end;


hold off;