%% kresli platformu

function kresli_platformu(N, body)

hold on;
fill3(N(body, 1), N(body, 2), N(body, 3), [0.5 0.5 0.5]);
hold off;