function FINAL = combineImage(Yt, image)  
    temp = double(repmat(Yt,1,1,3));
    [crop_r,crop_c,v] = size(temp);
    final  = (image(1:crop_r,1:crop_c,:) .* temp);
    epis = 1e-8;
    idx_test = logical((final(:,:,1)<epis) .* (final(:,:,2)<epis) .* (final(:,:,3)<epis));
    f1 = final(:,:,1); f2 = final(:,:,2); f3 = final(:,:,3);
    f1(idx_test) = 1; f2(idx_test) = 1; f3(idx_test) = 0;
    FINAL = cat(3,f1,f2,f3);
end