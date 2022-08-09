plant = T1;
opts = optimset('Display','iter');
fun = @(g) hinfsingle(plant,g);
X0 = 0;
X = fminsearch(fun,X0,opts)
beep