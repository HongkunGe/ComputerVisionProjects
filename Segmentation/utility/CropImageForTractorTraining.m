% Crop Image
dir_input = '/Users/hkge1991/Documents/Academic/MATLAB/CVproject/Segmentation/data/TrainingImage/castle_dense/urd/';
image_name = dir(fullfile(dir_input, '*.png'));
num_im = numel(image_name);
for i = 1:num_im
    I = imread(fullfile(dir_input, image_name(i).name));
    rect = cell(3,1);
    for j = 1:3
    
    imshow(I);
    [~,rect{j}] = imcrop;
    
    end
    save([dir_input image_name(i).name(1:4) '_rect.mat'],'rect');
end