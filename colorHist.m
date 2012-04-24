function h = colorHist(frame,BB, bins)
% compute color histogram of dimension bins x bins x bins 
    sub_img = imcrop(frame,BB);
    
    if (nargin <= 2)
       bins = 8;
    end


    z = size(sub_img ,3);
    clip2 = zeros(size(sub_img ,1),size(sub_img ,2));

    f = 1;
    for i = 1:z
       clip2 = clip2 + f*floor(sub_img(:,:,i)*bins/256);
       f=f*bins;
    end
    
    %make 1-D vector
    data = zeros(numel(clip2),1);
    data(:) = clip2(:);
    
    %compute histogram
    h = hist(data, 0:(f-1));
    
    % histogram normalization
    h = h / sum(h);
end