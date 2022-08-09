plant = T1;
opts = optimset('Display','iter','MaxIter',200);
fun = @(k) hinfdiag(plant,k);
X0 = X*ones(6,1);
X = fminsearch(fun,X0,opts);