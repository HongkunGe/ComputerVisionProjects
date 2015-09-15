function [image,num_elem] = load_positiveImage(current_folder, downsampleRate)

dir_input = [current_folder 'data/TrainingImage/castle_dense/urd/'];
im_elem = dir(fullfile(dir_input, '*.png'));
num_elem = numel(im_elem);
image = cell(num_elem,1);
for i = 1:num_elem
    disp(['loading positive image' num2str(i)] );
    image{i}.im  = im2double(imread(fullfile(dir_input,im_elem(i).name)));
    image{i}.im  = imresize(image{i}.im, downsampleRate);
    load([dir_input im_elem(i).name(1:4) '_rect.mat']);
    image{i}.rect = rect;   % Need MORE TEST.
    
%     I1 = imcrop(image{i}.im,image{i}.rect{1}*downsampleRate);
%     imshow(I1)
end