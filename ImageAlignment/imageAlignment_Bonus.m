function [ displacement_SSD,displacement_NCC ] = imageAlignment_CVAssignment_Bonus( path )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
minSize=128;domain=6;cut=150;
imageRaw=imread(path);
image=im2double(imageRaw);

[r,c]=size(image);
r=fix(r/3);
imagePartitionTemp=reshape([image(1:r,1:c),image((1+r):2*r,1:c),image((1+2*r):3*r,1:c)],r,c,3);
imagePartition=imagePartitionTemp((cut+1):(r-cut),(cut+1):(c-cut),:);
offset1=imageAlignmentPyramidSSD(imagePartition(:,:,2),imagePartition(:,:,1),minSize,domain);
offset3=imageAlignmentPyramidSSD(imagePartition(:,:,2),imagePartition(:,:,3),minSize,domain);
imageResult=reshape([circshift(imagePartition(:,:,1),offset1),imagePartition(:,:,2),...
                     circshift(imagePartition(:,:,3),offset3)],...
                     size(imagePartition(:,:,1),1),size(imagePartition(:,:,1),2),3);
figure(1);
imshow(imageResult(:,:,3:-1:1));
displacement_SSD=[offset1;offset3];

offset1=imageAlignmentPyramidNCC(imagePartition(:,:,2),imagePartition(:,:,1),minSize,domain);
offset3=imageAlignmentPyramidNCC(imagePartition(:,:,2),imagePartition(:,:,3),minSize,domain);
imageResult=reshape([circshift(imagePartition(:,:,1),offset1),imagePartition(:,:,2),...
                     circshift(imagePartition(:,:,3),offset3)],...
                     size(imagePartition(:,:,1),1),size(imagePartition(:,:,1),2),3);
figure(2);
imshow(imageResult(:,:,3:-1:1));
displacement_NCC=[offset1;offset3];
end

function [offset]=imageAlignmentPyramidSSD(imageT,imageS,minSize,domain)
minCov=realmax;
if size(imageS,1)<minSize
    % get the rough offset
    for i=-domain:domain
        for j=-domain:domain
            imageOffset=circshift(imageS,[i,j]);
            cov=SSD(imageOffset,imageT);
            if cov<minCov
                minCov=cov;
                offset=[i,j];
            end
        end
    end
else  % roughtOffset*2 move the image 
    imageTPyrmd=impyramid(imageT,'reduce');
    imageSPyrmd=impyramid(imageS,'reduce');
    roughOffset=imageAlignmentPyramidSSD(imageTPyrmd,imageSPyrmd,minSize,domain);
    roughOffset=2*roughOffset;
    for i = (roughOffset(1)-domain):(roughOffset(1)+domain)
        for j = (roughOffset(2)-domain):(roughOffset(2)+domain)
            imageOffset=circshift(imageS,[i,j]);
            cov=SSD(imageOffset,imageT);
            if cov<minCov
                minCov=cov;
                offset=[i,j];
            end
        end
    end
end
end

function [offset]=imageAlignmentPyramidNCC(imageT,imageS,minSize,domain)
maxCorr=-realmax;
if size(imageS,1)<minSize
    % get the rough offset
    for i=-domain:domain
        for j=-domain:domain
            imageOffset=circshift(imageS,[i,j]);
            corr=NCC(imageOffset,imageT);
            if corr>maxCorr
                maxCorr=corr;
                offset=[i,j];
            end
        end
    end
else  % roughtOffset*2 move the image 
    imageTPyrmd=impyramid(imageT,'reduce');
    imageSPyrmd=impyramid(imageS,'reduce');
    roughOffset=imageAlignmentPyramidNCC(imageTPyrmd,imageSPyrmd,minSize,domain);
    roughOffset=2*roughOffset;
    for i = (roughOffset(1)-domain):(roughOffset(1)+domain)
        for j = (roughOffset(2)-domain):(roughOffset(2)+domain)
            imageOffset=circshift(imageS,[i,j]);
            corr=NCC(imageOffset,imageT);
            if corr>maxCorr
                maxCorr=corr;
                offset=[i,j];
            end
        end
    end
end
end

function [ corr ]=NCC(imageOffset,imageT)
corr=dot(imageOffset(:),imageT(:))/norm(imageOffset(:))/norm(imageOffset(:));
end

function [covariance]=SSD(imageOffset,imageT)
covariance=sum(sum((imageOffset-imageT).^2));
end

