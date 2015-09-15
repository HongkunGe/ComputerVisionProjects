i=1;
dir_input = '/Users/hkge1991/Documents/Academic/MATLAB/CVproject/Segmentation/data/TrainingImage/castle_dense/urd/';
image_name = dir(fullfile(dir_input, '*.png'));
I = imread(fullfile(dir_input, image_name(i).name));
imshow(I)
load([dir_input image_name(i).name(1:4) '_rect.mat'])
I1 = imcrop(I,rect{1});
imshow(I1)