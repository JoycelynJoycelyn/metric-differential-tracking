function T = track(T, frame)
  if isfield(T,'target')

      %calcolo della distribuzione p (candidate distribution)
      subIm = imcrop(frame, T.target.BB_p);

      T.target.subIm = im2double(subIm);
      T.target.subIm = T.target.subIm / 255.0;
      T.target.p = get_histogram_feature(T.target.subIm, T.target.BB_p, 225);%, T.target.i_c, T.target.j_c);


      %optimal displacement to calculate (delta_c)
      T.target.dc = get_dc(T);
      T.target.dc
      %update bounding box
      T.target.BB_p(1) = T.target.BB_p(1) - T.target.dc(1);
      T.target.BB_p(2) = T.target.BB_p(2) - T.target.dc(2);
  
  end

%end
return