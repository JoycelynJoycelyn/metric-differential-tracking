function T = track(T, frame)
  if isfield(T,'target')

      %calcolo della distribuzione p (candidate distribution)
      subIm = imcrop(frame, T.target.BB_p);

      T.target.subIm = im2double(subIm);
     % T.target.subIm = T.target.subIm / 255.0;
      T.target.p = get_histogram_feature(T.target.subIm, T.target.BB_p, 225);%, T.target.i_c, T.target.j_c);


      %optimal displacement to calculate (delta_c)
      T.target.dc = get_dc(T);
      T.target.dc
      if T.target.dc(1) == 0 && T.target.dc(2) == 0 
          T.target.BB_p = T.target.BB_p + eps;
          
      end
      %update bounding box
      T.target.BB_p(1) = T.target.BB_p(1) - T.target.dc(1);
      T.target.BB_p(2) = T.target.BB_p(2) - T.target.dc(2);
      
      
      
      %training examples acquisition for g(A) evalutation
      neg_feature = [];
     % neg_offset = [];
      pos_feature = [];
     % pos_offset = [];
      soglia_pos=0.6;
    soglia_neg=0.01;
%       for(i=1:size(T.target.pos_offset,1))
%           rect = T.target.BB_p+T.target.pos_offset(i,:);
%           if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
%               subImg= im2double(imcrop(frame,rect));
%               pos_feature=[pos_feature; get_histogram_feature(subImg, rect, 225)'];
%           end
%       end
%       for(i=1:size(T.target.neg_offset,1))
%           rect = T.target.BB_p+T.target.neg_offset(i,:);
%           if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
%               subImg= im2double(imcrop(frame,rect));
%               neg_feature=[neg_feature; get_histogram_feature(subImg, rect, 225)'];
%           end
%       end
        obj_box = T.target.BB_p;
        rectangle('Position', obj_box, 'EdgeColor', 'b');
        drawnow;
        %campioni= 5;
        campioni_pos = 5;
        campioni_neg = 15;
       while(size(pos_feature,1) < campioni_pos || size(neg_feature,1) < campioni_neg)
           
        offset = (min(T.target.BB_p(3), T.target.BB_p(4))/2) * randn(1,2);
        offset = [offset 0 0];
        rect = obj_box+offset;
        if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
            
            inters=intersectBB(obj_box,rect);
            
            if(inters>soglia_pos && size(pos_feature,1) < campioni_pos)
                subImg= im2double(imcrop(frame,rect));
                feature= get_histogram_feature(subImg, rect, 225)';
            %    pos_offset =[pos_offset; offset];
                pos_feature = [pos_feature; feature]; 
                %disegnamo il campione positivo sul frame
                rectangle('Position', rect, 'EdgeColor', 'r');
                drawnow;
            end

            if(inters<soglia_neg && size(neg_feature,1) < campioni_neg)
             subImg= im2double(imcrop(frame,rect));
             feature= get_histogram_feature(subImg, rect, 225)';
    %         neg_offset = [neg_offset; offset];
             neg_feature = [neg_feature; feature];
             %disegnamo il campione negativo sul frame
             rectangle('Position', rect, 'EdgeColor', 'y');
             drawnow;
            end
            
        end

      end
      
      T.target.pos_feature_tot = [ T.target.pos_feature_tot; pos_feature ];
      T.target.neg_feature_tot = [ T.target.neg_feature_tot; neg_feature ];
      if(size(T.target.pos_feature_tot,1)>3*campioni_pos)
        T.target.pos_feature_tot = T.target.pos_feature_tot(campioni_pos+1:size(T.target.pos_feature_tot,1),:);
      %  T.target.neg_feature_tot = T.target.neg_feature_tot(campioni+1:size(T.target.neg_feature_tot,1),:);  
      end
      if(size(T.target.neg_feature_tot,1)>3*campioni_neg)
      %  T.target.pos_feature_tot = T.target.pos_feature_tot(campioni+1:size(T.target.pos_feature_tot,1),:);
        T.target.neg_feature_tot = T.target.neg_feature_tot(campioni_neg+1:size(T.target.neg_feature_tot,1),:);  
      end
      
      g=G(T.target.A, T.target.pos_feature_tot', T.target.neg_feature_tot')         
      if(g < T.target.G*0.8 || g > T.target.G*1.2)
        feature_positive = size(T.target.pos_feature_tot,1)
        feature_negative = size(T.target.neg_feature_tot,1)
        sample= [T.target.pos_feature_tot; T.target.neg_feature_tot];
        label = [ones(feature_positive,1) zeros(feature_positive,1); zeros(feature_negative,1) ones(feature_negative,1)];
        %A = T.target.A;
        %A = eye(225);
        A = [eye(50) zeros(50,175)];
        [Anew,fX,i] = minimize(A(:),'nca_obj',5,sample,label);
        T.target.A = reshape(Anew,50,225);
        T.target.pos_feature_tot = [];
        T.target.neg_feature_tot = [];
        T.target.G = g;
      end
      
  end

%end
return