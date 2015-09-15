function [ displacement] = imageAlignment_CVAssignment_1(path)
% This is the First Assignment of Computer Vision.
%   input: "path" is the file path of image data.
%   output: "displacement" is the displacement vector used to align the
%           channels. 
Input=imread(path);
input=im2double(Input);

cut=10;
cut2=25;
[rTemp,cTemp]=size(input);
rTemp=fix(rTemp/3);
MAXOFFSET=15;
imagePartitionTemp=zeros(rTemp,cTemp,3);% Can be primzed.
r=rTemp-2*cut;
c=cTemp-2*cut;
imagePartition=zeros(r,c,3);
offsetImage1=zeros(r+2*MAXOFFSET,c+2*MAXOFFSET);
offsetImage2=zeros(r+2*MAXOFFSET,c+2*MAXOFFSET);
minSSDOffset.image=zeros(r+2*MAXOFFSET,c+2*MAXOFFSET,3);
minSSDOffset.offset=zeros(2,2);
for i=1:3
    imagePartitionTemp(:,:,i)=input((rTemp*(i-1)+1):rTemp*i,1:cTemp);
    imagePartition(:,:,i)=imagePartitionTemp((cut+1):(end-cut),(cut+1):(end-cut),i);
end
set=1:3;
corr=zeros(2,1);
minCorr=inf(2,1);

for i=2
    complementarySet=setdiff(set,i);
    minSSDOffset.image((1:r)+MAXOFFSET,(1:c)+MAXOFFSET,i)=imagePartition(:,:,i);
    for offset1=-MAXOFFSET:MAXOFFSET
        for offset2=-MAXOFFSET:MAXOFFSET
            offsetImage1((1:size(imagePartition(:,:,complementarySet(1)),1))+MAXOFFSET+offset1,...
                (1:size(imagePartition(:,:,complementarySet(1)),2))+MAXOFFSET+offset2)=imagePartition(:,:,complementarySet(1));
%             Temp=abs(normxcorr2(imagePartition(:,:,i),offsetImage1));
%             corr(1)=sum(Temp(:));
            %[ypeak,xpeak]=find(corr==max(corr(:)));
            corr(1)=SSD(imagePartition(:,:,i),offsetImage1,MAXOFFSET);
            if corr(1)<minCorr(1)
                minCorr(1)=corr(1);
                minSSDOffset.offset(1,:)=[offset1,offset2];
                minSSDOffset.image(:,:,complementarySet(1))=offsetImage1;
            end
        end
    end
    for  offset3=-MAXOFFSET:MAXOFFSET
        for  offset4=-MAXOFFSET:MAXOFFSET
            offsetImage2((1:size(imagePartition(:,:,complementarySet(2)),1))+MAXOFFSET+offset3,...
                (1:size(imagePartition(:,:,complementarySet(2)),2))+MAXOFFSET+offset4)=imagePartition(:,:,complementarySet(2));
%             Temp=abs(normxcorr2(imagePartition(:,:,i),offsetImage2));
%             corr(2)=sum(Temp(:));
            % corr(2)=sum(sum(abs(normxcorr2(imagePartition(:,:,i),offsetImage2))));
            corr(2)=SSD(imagePartition(:,:,i),offsetImage2,MAXOFFSET);
            if corr(2)<minCorr(2)
                minCorr(2)=corr(2);
                minSSDOffset.offset(2,:)=[offset3,offset4];
                minSSDOffset.image(:,:,complementarySet(2))=offsetImage2;
            end
        end
    end
end
displacement=minSSDOffset.offset;
%clf
figure(5);
imshow(minSSDOffset.image((cut2+1):(end-cut2),(cut2+1):(end-cut2),3:-1:1));%
end


function [ssd]=SSD(a,b,Maxoffset)
Temp=(a-b((Maxoffset+1):(end-Maxoffset),(Maxoffset+1):(end-Maxoffset))).^2;
ssd=sum(Temp(:));
end
