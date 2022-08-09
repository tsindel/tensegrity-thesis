%%% vykresleni uzlu

function vykresli_uzly(N)

hold on;
for(i=1:size(N, 1))
  plot3(N(i, 1), N(i, 2), N(i, 3), 'ko', 'MarkerSize', 6, 'LineWidth', 2)
  text(N(i, 1), N(i, 2), N(i, 3)-0.02, ['N', num2str(i)]);
end;
hold off;