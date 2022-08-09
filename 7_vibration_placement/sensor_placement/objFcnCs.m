function OF = objFcnCs(col,s,Cs0)
    
    S = selectionMatrix(s); % define sensor occupation from vector input
    Cs = S * Cs0;
    
    %% Objective function
    OF = sum(Cs(:,col).^2);
end

