function Pd = deltaSelectMatrix(ne)
    Pd = zeros(6*ne);
    for e = 1:ne
        Pd(6*e-5:6*e,6*e-5:6*e) = [eye(3) -eye(3); -eye(3) eye(3)];
    end
end

