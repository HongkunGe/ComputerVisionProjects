function [Xt, N] = fullPatch(image, ps)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

[r,c,v] = size(image);
N = 0;
Xt = zeros(ps*ps*3, (r-ps+1)*(c-ps+1));
for j = 1:c-ps+1
    for i = 1:r-ps+1
        patch = image(i:i+ps-1, j:j+ps-1, :);
        N = N + 1;
        Xt(:, N) = patch(:);
    end
end

end

