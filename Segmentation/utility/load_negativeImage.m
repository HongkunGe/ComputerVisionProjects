function [image2,num_elem2] = load_negativeImage(current_folder, downsampleRate)

dir_input2 = [current_folder  'data/TrainingImage/castle_entry_dense/urd/'];
im_elem2 = dir(fullfile(dir_input2, '*.png'));
num_elem2 = numel(im_elem2);

image2 = cell(num_elem2,1);
for i = 1:num_elem2
    disp(['loading negative image' num2str(i)] );
    image2{i}.im  = im2double(imread(fullfile(dir_input2,im_elem2(i).name)));
    image2{i}.im  = imresize(image2{i}.im, downsampleRate);
end
end