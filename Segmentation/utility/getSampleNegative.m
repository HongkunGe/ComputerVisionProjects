function [sample_negative, Y_sn, cnt_sample2] = getSampleNegative(image2, patch_size, sample_rate, num_elem2, downsampleRate, SHOW_SAMPLE)

sample_negative = []; % p*N
cnt_sample2 = 0;
for i = 1:num_elem2
        [sample_new, temp] = getpatch(image2{i}.im, patch_size, sample_rate, SHOW_SAMPLE);
        cnt_sample2 = cnt_sample2 + temp;
        sample_negative = [sample_negative, sample_new];
end
Y_sn = -ones(1, cnt_sample2);
end