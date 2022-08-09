function S = selectionMatrix(p,interactor)
    S0 = diag(p);
    if strcmp(interactor,'sensor')
        S = S0(any(S0,1),:);
    elseif strcmp(interactor,'actuator')
        S = S0(:,any(S0,2));
    end
end

