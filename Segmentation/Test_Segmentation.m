disp('TESTING SVM...');
current_folder = 'C:\Users\Yue Guo\Dropbox\Hongkun_Ge\Segmentation\';
dir_testImage = [current_folder 'data/TestingImage/castle_dense_large/urd/'];
im_test = dir(fullfile(dir_testImage, '*.png'));
num_test = numel(im_test);
testImage = cell(num_test,1);

for i = 1:num_test
    disp(['loading image' num2str(i)] );
    figure(i)
    testImage{i}.im  = im2double(imread(fullfile(dir_testImage,im_test(i).name)));
    testImage{i}.im  = imresize(testImage{i}.im, downsampleRate);
    [Xt, N] = fullPatch(testImage{i}.im, patch_size);
%%  Testing SVM
    subplot 311
    imshow(testImage{i}.im);
    result = svmTest(svm, Xt, kernel_type);
    [r_test,c_test,v] = size(testImage{i}.im);
    Yt = reshape(result.Y, r_test-patch_size+1, c_test-patch_size+1);
    subplot 312
    RAW = combineImage(Yt, testImage{i}.im);
    imshow(RAW);
 %% Morphological process
    hsize = [5,5]; 
    sigma = 1;
    h = fspecial('gaussian', hsize, sigma);
    Yt = imfilter(Yt, h);
    Yt(Yt>0) = 1;
    se = strel('disk',6);
    Yt = imerode(Yt, se);    
    se = strel('disk',9);
    Yt = imdilate(Yt, se);
    
%%  Show the final result
    subplot 313
    FINAL = combineImage(Yt, testImage{i}.im);  
    imshow(FINAL);
end