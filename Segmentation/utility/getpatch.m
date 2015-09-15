function [sample, num_sample] = getpatch(image, ps, sample_rate, SCATTER_SHOW)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

[r,c,v] = size(image);
rn = floor(r/ps);
cn = floor(c/ps);
num_sample = ceil(rn * cn * sample_rate);
r_idx = randi([1, r-ps+1], num_sample, 1);
c_idx = randi([1, c-ps+1], num_sample, 1);
if SCATTER_SHOW == 1
    imshow(image);
    hold on
    scatter(c_idx, r_idx, 'y');
    hold off
end
sample = zeros(ps*ps*3, num_sample);  % RGB is different in two places.
for i = 1:num_sample
    patch = image(r_idx(i):r_idx(i)+ps-1, c_idx(i):c_idx(i)+ps-1, :);  % here 
    sample(:, i) = patch(:);
end
end

