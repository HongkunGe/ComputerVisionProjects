function [ output_args ] = depthMap(dir_input, refer_idx, WINDOW )
% DEPTHMAP 
%  
% dir_input = ...
% MAC OS X   '/Users/hkge1991/Dropbox/PlaneSweep/data/castle_entry_dense 1/urd/';
% MAC OS X   '/Users/hkge1991/Dropbox/PlaneSweep/data/fountain_dense/urd/';
% WINDOWS    'C:\Users\Yue Guo\Dropbox\PlaneSweep\data\fountain_dense\urd\';
%    
% MAC OS X   '/Users/hkge1991/Documents/Academic/MATLAB/CVproject/PlaneSweep/data/fountain_dense/urd/';
%% load the images and relevant data
im_elem = dir(fullfile(dir_input, '*.png'));
camera_elem = dir(fullfile(dir_input, '*.png.camera'));
bnd_elem = dir(fullfile(dir_input, '*.png.bounding'));
p_elem = dir(fullfile(dir_input, '*.png.P'));

num_elem = numel(im_elem);
num_elem = num_elem-3;
image = cell(num_elem, 1);

for i = 1:num_elem
    disp(['loading image' num2str(i)] );
    image{i}.im  = im2double(imread(fullfile(dir_input,im_elem(i).name)));
    image{i}.im  = imresize(image{i}.im,0.2);
    
    k =  fopen(fullfile(dir_input,camera_elem(i).name),'r');
    temp = fscanf(k, '%f');
    image{i}.K   = reshape(temp(1:9),3,3)' ;    % Transpose
    image{i}.K   = image{i}.K ./5;    
    image{i}.K(3,3) = 1;
    
    image{i}.R_t = reshape(temp(13:21),3,3)';
    image{i}.C   = temp(22:24);
    image{i}.t   = -image{i}.R_t' * image{i}.C;
    fclose(k);
    
    k =  fopen(fullfile(dir_input,bnd_elem(i).name),'r');
    image{i}.bnd = reshape(fscanf(k, '%f'),3,2)';                   % NEED more TEST here
    fclose(k);
    
    k =  fopen(fullfile(dir_input,p_elem(i).name),'r');
    image{i}.P = reshape(fscanf(k, '%f'),4,3)';
    fclose(k);
end
%% Sample the depth. Compute the range of depth. 
%  Transform the bounding boxes into reference camera coordinate frames.
%  Seek the minimal and maximal depth. 
%  Choose one image as reference the others are source images. 

% refer_idx = 5;   % floor(median(1:num_elem));     %Choose the image as the reference image
bnd_refer = cell(num_elem,1);
bnd_refer{refer_idx} = [];
for surc_idx = [1:refer_idx-1, refer_idx+1:num_elem]
    bnd_refer{surc_idx} = to_refer(image{surc_idx}.bnd, image{refer_idx});
    depthfar_c(surc_idx)  = max(bnd_refer{surc_idx}(3,:));
    depthnear_c(surc_idx) = min(bnd_refer{surc_idx}(3,:));
end
sample_num = 850;
depthfar = min(depthfar_c([1:refer_idx-1, refer_idx+1:num_elem]));   % ?????????????????????
depthnear = min(depthnear_c([1:refer_idx-1, refer_idx+1:num_elem]));
depthSample = linspace(depthnear,depthfar,sample_num);            % to use the sample of depth 
depthDisparity = linspace(1 /depthnear,1 /depthfar,sample_num);   % to use the sample of disparity 

%% Implement the plane sweep algorithm to get the depth map.
%  At each hypothesis plan, calculate the Homography for each of the source image.
% transform the point in the source image to the reference image
% compute the SSD between the reference image and transformed source
% image.
NORMAL = [0 0 -1];   % need more TEST!!
min_SSD = inf(size(image{refer_idx}.im(:,:,1)));  % optimal_SSD == min_SSD
optimal_depth = zeros(size(min_SSD)) + depthfar;
clf;
figure
tic
for depth_idx = floor(sample_num*0.75): sample_num
    disp(['Sweep ' num2str(depth_idx) ' The depth: ' num2str(depthDisparity(depth_idx))]);
    
    for surc_idx = [1:refer_idx-1, refer_idx+1:num_elem]
        K2 = image{refer_idx}.K;    K1 = image{surc_idx}.K;
        R2 = image{refer_idx}.R_t'; R1 = image{surc_idx}.R_t';
        t2 = image{refer_idx}.t;    t1 = image{surc_idx}.t;
        H = K2*(R2/R1 - (t2-R2/R1*t1)*NORMAL ./ depthSample(depth_idx)) /(K1);
        transed_surc{surc_idx} = imtransform(image{surc_idx}.im,...
                                             maketform('projective', H'),...   % NEED MORE CONFIRMATION
                                             'XData', [1, size(image{refer_idx}.im,2)],...
                                             'YData', [1, size(image{refer_idx}.im,1)] );
                                         
        SSD = imgSSD(transed_surc{surc_idx}, image{refer_idx}.im, WINDOW);
        opt_idx = min_SSD > SSD;
        min_SSD(opt_idx) = SSD(opt_idx);
        optimal_depth(opt_idx) = 1./depthDisparity(depth_idx);
        
    end
    
    subplot 121
    imshow(image{refer_idx}.im);
    subplot 122
    imagesc(optimal_depth);colorbar; drawnow;
end
toc
end



