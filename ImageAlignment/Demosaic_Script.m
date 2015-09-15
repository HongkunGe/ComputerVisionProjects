
input=imread('crayons_mosaic.bmp');
figure(3)
imshow(input)
reference=imread('crayons.jpg');
reference=im2double(reference);
input=im2double(input);
r=[1 0; 0 0];
g=[0 1; 1 0];
b=[0 0; 0 1];
[row,col]=size(input);
Rin=input.*repmat(r,row/2,col/2);
Gin=input.*repmat(g,row/2,col/2);
Bin=input.*repmat(b,row/2,col/2);
P1=[1 0 1;
   0 0 0;
   1 0 1];P1=P1/4;
P2=[0 1 0;
   0 0 0;
   0 1 0];P2=P2/2;
P3=[0 1 0;
   1 0 1;
   0 1 0];P3=P3/4;
P4=[0 0 0;
   1 0 1;
   0 0 0];P4=P4/2;
P5=[0 0 0;
   0 1 0;
   0 0 0];
R=imfilter(Rin,P1)+imfilter(Rin,P2)+imfilter(Rin,P4)+imfilter(Rin,P5);
MR=P1+P2+P4+P5
G=imfilter(Gin,P3)+imfilter(Gin,P5);
MG=P3+P5
B=imfilter(Bin,P1)+imfilter(Bin,P2)+imfilter(Bin,P4)+imfilter(Bin,P5);
MB=P1+P2+P4+P5
figure(1)
imageRGB=reshape([R,G,B],row,col,3);
imshow(imageRGB);
figure(2)
cut=0;       %%%  Cut the rectangular border if needed. if cut==0,no cutting is operated.
dffrnc=(imageRGB-reference).^2;
dffrnc3=sum(dffrnc,3);

[xm,ym]=meshgrid((1+cut):row-cut,(1+cut):col-cut);
colormap hsv;
h=pcolor(xm',ym',dffrnc3((1+cut):row-cut,(1+cut):col-cut));
set(h,'facecolor','interp');
colorbar;
figure(4)
surf(xm',ym',dffrnc3((1+cut):row-cut,(1+cut):col-cut),'facecolor','b');

colorbar;
% set(gcf,'color','default');

% bias=abs(imageRGB-reference);
% bias3=sum(bias,3);
averageBias=sum(sum(dffrnc3((1+cut):row-cut,(1+cut):col-cut)))/(row-2*cut)/(col-2*cut)
maxBias=max(max(dffrnc3((1+cut):row-cut,(1+cut):col-cut)))
[XM,YM]=find(max(dffrnc3(:))==dffrnc3)
