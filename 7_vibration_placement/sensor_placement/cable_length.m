%%% vypocet volnych delek lan

function l0=cable_length(N, C)

for(i=1:size(C, 1))
  l0(i)=node_distance(N, C(i, 1), C(i, 2));
end;