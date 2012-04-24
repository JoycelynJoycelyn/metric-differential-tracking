function H = get_histogram(BoundingBox,frame)
  
  sub_image = imcrop(frame,BoundingBox);
  
  T.R = imhist(sub_image(:,:,1),75);
  T.R = T.R ./ (BoundingBox(3)*BoundingBox(4));
  %H.R=H.R./norm(H.R,1);
  T.G = imhist(sub_image(:,:,2),75);
  T.G = T.G ./ (BoundingBox(3)*BoundingBox(4));
  %H.G=H.G./norm(H.G,1);
  
  T.B= imhist(sub_image(:,:,3),75);
  T.B = T.B ./ (BoundingBox(3)*BoundingBox(4));
  %H.B=H.B./norm(H.B,1);
  
  H = [T.R; T.G; T.B];
  %size(H)
  
  m = size(1); 
  
  

return