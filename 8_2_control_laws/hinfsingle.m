function Hinf = hinfsingle(plant,g)
    plant.Blocks.Ci.Value = eye(6);
    plant.Blocks.gi.Value = g;
    Hinf = mag2db(norm(plant,Inf));
end

