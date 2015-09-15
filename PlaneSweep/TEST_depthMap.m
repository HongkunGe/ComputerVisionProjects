clc
clear all
close all
addpath(genpath('.'))
dir_input = ...
    'C:\Users\Yue Guo\Dropbox\Hongkun_Ge\PlaneSweep\data\fountain_dense\urd\';
refer_idx = 5;
WINDOW = 8;
depthMap(dir_input, refer_idx, WINDOW );