function Hinf = hinfdiag(plant,k)
    plant.Blocks.gi.Value = 1;
    plant.Blocks.Ci.Value = diag(k);
    Hinf = mag2db(norm(plant,Inf));
end

