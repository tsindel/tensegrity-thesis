H = [0 -1 0 1 0 0 0 0 0 0 0 0;
     0 0 0 0 sqrt(2)/2*[-1 -1 1 1] 0 0 0 0;
     0 0 0 0 0 0 0 0 sqrt(2)/2*[1 -1 -1 1]]';
z2 = zeros(2); e2 = eye(2);
Pi = [z2 e2 z2 e2 z2 e2]

Js = H'*Pi';
Ja = Pi*H;