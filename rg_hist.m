function h = rg_hist( frame )
    frame = double(frame);
    RGB = sum(frame, 3)+eps;
    r = frame(:,:,1) ./ RGB;
    g = frame(:,:,2) ./ RGB;
    
    %tra 0 e 14
    r = round(r*14);
    g = round(g*14);

    b = r + g * 15 +1;
    b = reshape(b,1,size(b,1)*size(b,2));
    h = hist(b,225); 
    h = h ./sum(h);

end

