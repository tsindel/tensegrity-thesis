%%% plot coordinate system

function csys_plot(P, S)

%plot scale
scale=0.1;
S=S*scale;
plot3([P(1), P(1)+S(1,1)], [P(2), P(2)+S(2,1)], [P(3), P(3)+S(3,1)], '-r'); %X-axis
plot3([P(1), P(1)+S(1,2)], [P(2), P(2)+S(2,2)], [P(3), P(3)+S(3,2)], '-g'); %Y-axis
plot3([P(1), P(1)+S(1,3)], [P(2), P(2)+S(2,3)], [P(3), P(3)+S(3,3)], '-b'); %Z-axis
