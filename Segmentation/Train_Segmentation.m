clc
clear all 
close all

current_folder = 'C:\Users\Yue Guo\Dropbox\Hongkun_Ge\Segmentation\';
%'/Users/hkge1991/Documents/Academic/MATLAB/CVproject/Segmentation/';
addpath(genpath(current_folder));

%% Read original image and crop the image to get the tractor.
  downsampleRate = 0.12;    % Related with patch size
 [image, num_elem]  = load_positiveImage(current_folder, downsampleRate);
 [image2,num_elem2] = load_negativeImage(current_folder, downsampleRate);

%% generate the positive sample, i.e. the sample from the tractor. 
patch_size  = 8;
sample_rate = 0.6;
SHOW_SAMPLE = 1;
[sample_positive, Y_sp, cnt_sample]  = getSamplePositive(image, patch_size, sample_rate, num_elem, downsampleRate, SHOW_SAMPLE);
%% generate the negative sample, i.e. the sample from the background.
sample_rate = 0.06;
[sample_negative, Y_sn, cnt_sample2] = getSampleNegative(image2, patch_size, sample_rate, num_elem2, downsampleRate, SHOW_SAMPLE);
X = [sample_positive, sample_negative];
Y = [Y_sp, Y_sn];

%%  Forward p*N training sample to SVM. 
disp('TRAINING SVM...');
kernel_type = 'Gaussian';
svm = svmTrain(X,Y,kernel_type);
%% Test the SVM. get the result of Y. 














