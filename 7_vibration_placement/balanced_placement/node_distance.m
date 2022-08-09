%% vzdalenost uzlu

function distance=node_distance(N, N1, N2)

distance=sqrt((N(N2, 1)-N(N1, 1))^2 + (N(N2, 2)-N(N1, 2))^2 + (N(N2, 3)-N(N1, 3))^2);