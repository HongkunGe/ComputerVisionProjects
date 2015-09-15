function [ output_args ] = movieMaker( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin ==0
    dir_input = '/Users/hkge1991/Documents/Academic/course/Computer Vision/Assignment/Assignment_2/';
    dir_input2 = '/Users/hkge1991/Documents/Academic/course/Computer Vision/Assignment/Assignment_2/Distortion/';    
    dir_output = '/Users/hkge1991/Documents/Academic/course/Computer Vision/Assignment/Assignment_2/';
end
writerObj = VideoWriter('DollyZoom.avi');
writerObj.FrameRate = 15;
open(writerObj);

for step = 0:90
    fname = sprintf('SampleOutput%03d.jpg',step);
    im = imread([dir_input fname]);
    imshow(im);
    frame = getframe(gca);
    writeVideo(writerObj,frame);
end
close(writerObj);

end

% f = figure;
% for step = 0:1
%     fname = sprintf('SampleOutput%03d.jpg',step);
%     im = imread([dir_input2 fname]);
%     imshow(im);
%     v.frames(step+1) = getframe(gca);
%     v.times(step+1) = (step+1)/15;
% end
% close(f);
% mmwrite('DollyRoom.wmv',v);