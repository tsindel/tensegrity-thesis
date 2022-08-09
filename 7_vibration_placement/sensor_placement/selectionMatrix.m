function S = selectionMatrix(s)
    S0 = diag(s); S = S0(any(S0,2),:);
end

