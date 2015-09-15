function [sample_positive, Y_sp, cnt_sample] = getSamplePositive(image, patch_size, sample_rate, num_elem, downsampleRate, SHOW_SAMPLE)
sample_positive = []; % p*N
cnt_sample = 0;
for i = 1:num_elem
    for j = 1:3
        subimage = imcrop(image{i}.im, image{i}.rect{j} * downsampleRate);
        %  imshow(subimage);
        [sample_new, temp] = getpatch(subimage, patch_size, sample_rate, SHOW_SAMPLE);
        cnt_sample = cnt_sample + temp;
        sample_positive = [sample_positive, sample_new];
    end
end
Y_sp = ones(1, cnt_sample);
end