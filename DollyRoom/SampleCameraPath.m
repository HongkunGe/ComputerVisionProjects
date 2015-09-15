% Sample use of PointCloud2Image(...)
% 
% The following variables are contained in the provided data file:
%       BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size
% None of these variables needs to be modified


clc
clear all
% load variables: BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size)
load data.mat

data3DC = {BackgroundPointCloudRGB,ForegroundPointCloudRGB};
R       = eye(3);
move    = [0 0 -0.03]';


k = 1.0 : -0.02222 : -1;
for step = 0:90
    tic
    fname       = sprintf('SampleOutput%03d.jpg',step);
    display(sprintf('\nGenerating %s',fname));
    t           = step * move;
    distance    = 3.8663 + t(3);
    fy          = 600/(0.0797 + 0.5593) * distance;
    K(1,1)      = fy;
    
    fx          = 400/(0.3290 + 0.0589) * distance;
    K(2,2)      = fx;
    M           = K*[R t];  % t = -RC; R=eye(3) now; t = -C; C represents the coordinates 
                            % of the camera centre in the world coordinate
                            % frame. negative left. 
    im          = PointCloud2Image(M,data3DC,crop_region,filter_size);
    
    imNew = zeros(size(im));
    [ Y0, X0 ,~] = size(imNew);
    center = [round(Y0/2) round(X0/2) ];
    [xi,yi] = meshgrid(1:X0,1:Y0);
    xt = xi(:) - center(2);
    yt = yi(:) - center(1);
    R1 = sqrt(center(1)^2 + center(2)^2);
    r = sqrt(xt.^2 + yt.^2);
    r = r/R1;
    u = xt./(1+k(step+1)*r.^2);
    v = yt./(1+k(step+1)*r.^2);
    u = round(reshape(u,size(xi)) + center(2));
    v = round(reshape(v,size(yi)) + center(1));
    % u(u<1) = 1;
    % v(v<1) = 1;
    transformMap = cat(3,u,v);
    R1 = makeresampler('nearest','fill');
    imNew = tformarray(im,[],R1,[2 1],[1 2],[],transformMap,[]);
    
    imshow(imNew)
    
    % mkdir('distortion'); 
    imwrite(imNew, ['distortion/' fname]);
    toc    
    
    disp(['Camera Position:' num2str((3.8663-distance))  '  ']);
    disp(['Focal Length:' num2str(K(1,1)) ' ' num2str(K(2,2)) '  ']);
end
