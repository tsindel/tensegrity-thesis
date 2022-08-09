function S=matrix_S(A, B)

xA=A(1);
yA=A(2);
zA=A(3);
xB=B(1);
yB=B(2);
zB=B(3);

l=sqrt((xB-xA)^2 + (yB-yA)^2);
alpha=atan2(zB-zA, l);
beta=atan2(yB-yA, xB-xA);

k=[cos(alpha)*cos(beta); cos(alpha)*sin(beta); sin(alpha)];
i=[cos(beta+pi/2); sin(beta+pi/2); 0];
j=cross(k, i);
S=[i, j, k];