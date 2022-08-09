%%vykresleni lan

function vykresli_lana(C, N)

hold on;

for(i=1:size(C, 1))
  plot3([N(C(i, 1), 1), N(C(i, 2), 1)], [N(C(i, 1), 2), N(C(i, 2), 2)], [N(C(i, 1), 3), N(C(i, 2), 3)], '-.m', 'LineWidth', 2)
  text((N(C(i, 1), 1)+N(C(i, 2), 1))/2, (N(C(i, 1), 2)+N(C(i, 2), 2))/2, (N(C(i, 1), 3)+N(C(i, 2), 3))/2, ['C', num2str(i), '(', num2str(C(i, 1)), '-',num2str(C(i, 2)), ')']);
end;


hold off;