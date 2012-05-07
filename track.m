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
      if T.target.dc(1) == 0 && T.target.dc(2) == 0 
          T.target.BB_p = T.target.BB_q + eps;
          
      end
      %update bounding box
      T.target.BB_p(1) = T.target.BB_p(1) - T.target.dc(1);
      T.target.BB_p(2) = T.target.BB_p(2) - T.target.dc(2);
      
      
      
      %training examples acquisition for g(A) evalutation
      pos_feature = [];
      neg_feature = [];
      for(i=1:size(T.target.pos_offset,1))
          rect = T.target.BB_p+T.target.pos_offset(i,:);
          if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
              subImg= im2double(imcrop(frame,rect));
              pos_feature=[pos_feature; get_histogram_feature(subImg, rect, 225)'];
          end
      end
      for(i=1:size(T.target.neg_offset,1))
          rect = T.target.BB_p+T.target.neg_offset(i,:);
          if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
              subImg= im2double(imcrop(frame,rect));
              neg_feature=[neg_feature; get_histogram_feature(subImg, rect, 225)'];
          end
      end
      
      g=G(T.target.A, pos_feature', neg_feature')         
      if(g<T.target.G*0.8)
        feature_positive = size(pos_feature,1)
        feature_negative = size(neg_feature,1)
        sample= [pos_feature; neg_feature];
        label = [ones(size(pos_feature,1),1) zeros(size(pos_feature,1),1); zeros(size(neg_feature,1),1) ones(size(neg_feature,1),1)];
        A = T.target.A;
        [Anew,fX,i] = minimize(A(:),'nca_obj',5,sample,label);
        T.target.A = reshape(Anew,225,225);
      end
      T.target.G = g;
  end

%end
return