function U = orthoNormModal(V,M)
    % we normalize eigenvectors to be orthogonal, because Matlab does not
    % guarantee orthogonality on its own (https://www.mathworks.com/help/matlab/ref/eig.html)
    m = length(V');
    U = zeros(size(V));
    for i = 1:m
        U(:,i) = V(:,i) / sqrt(V(:,i)' * M * V(:,i));
    end
end

