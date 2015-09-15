function SSD = imgSSD(I1,I2,WINDOW)
if size(I1,3) ~= size(I2,3)
    error('ERROR: Image size must match!');
end
if size(I1,3) == 1
    SSD = (I1 - I2).^2;
else if size(I1,3) == 3
        SSD = (I1(:,:,1) - I2(:,:,1)).^2 +...
              (I1(:,:,2) - I2(:,:,2)).^2 +...
              (I1(:,:,3) - I2(:,:,3)).^2; % maybe should have more tests.
    end
end
h = ones(WINDOW);
SSD = imfilter(SSD,h);
end