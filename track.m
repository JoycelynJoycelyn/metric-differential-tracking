function T = track(T, frame)
  if isfield(T,'target')

      %calcolo della distribuzione p (candidate distribution)
      subIm = imcrop(frame, T.target.BB_p);

      T.target.subIm = im2double(subIm);
     % T.target.subIm = T.target.subIm / 255.0;
      T.target.p = get_histogram_feature(T, T.target.subIm, 225);%, T.target.i_c, T.target.j_c);


      %optimal displacement to calculate (delta_c)
      T.target.dc = get_dc(T);
      display('delta c =' );
      T.target.dc
      
      if T.target.dc(1) == 0 && T.target.dc(2) == 0 
          T.target.BB_p = T.target.BB_p + eps;
          
      end
      %update bounding box
      T.target.BB_p(1) = T.target.BB_p(1) + T.target.dc(1);
      T.target.BB_p(2) = T.target.BB_p(2) + T.target.dc(2);
      rectangle('Position', T.target.BB_p, 'EdgeColor', 'g');

      
      
      %training examples acquisition for g(A) evalutation
      neg_feature = [];
     % neg_offset = [];
      pos_feature = [];
     % pos_offset = [];
      soglia_pos=0.85;
    soglia_neg=0.3;
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
          drawnow;
%          %campioni= 5;
         campioni_pos = 5;
         campioni_neg = 15;
%         rng('default');
        while(size(pos_feature,1) < campioni_pos || size(neg_feature,1) < campioni_neg)
         offset = ceil((min(T.target.BB_p(3), T.target.BB_p(4))/4) * randn(1,2));
         offset = [offset 0 0];
         rect = obj_box+offset;
         if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
             inters=intersectBB(obj_box,rect);
%             
             if(inters>soglia_pos && size(pos_feature,1) < campioni_pos)
                 %positive sample
                 subImg= im2double(imcrop(frame,rect));
                 feature= get_histogram_feature(T ,subImg, 225)';
               %  pos_offset =[pos_offset; offset];
                pos_feature = [pos_feature; feature]; 
                %disegnamo il campione positivo sul frame
           %     rectangle('Position', rect, 'EdgeColor', 'r');
                drawnow;
             end
             if(inters<soglia_neg && size(neg_feature,1) < campioni_neg)
            
            %if(size(neg_feature,1) < campioni_neg)
                %negative sample
                     subImg= im2double(imcrop(frame,rect));
                     feature= get_histogram_feature(T, subImg, 225)';
             %        neg_offset = [neg_offset; offset];
                     neg_feature = [neg_feature; feature];
                     %disegnamo il campione negativo sul frame
           %          rectangle('Position', rect, 'EdgeColor', 'y');
                     drawnow;
            end
            
        end

      end
       
      T.target.pos_feature_tot = [ T.target.pos_feature_tot; pos_feature ];
      T.target.neg_feature_tot = [ T.target.neg_feature_tot; neg_feature ];
      %T.target.pos_feature_tot =  pos_feature ;
      T.target.neg_feature_tot =  neg_feature ;
    if(size(T.target.pos_feature_tot,1) > 4*campioni_pos)
       T.target.pos_feature_tot = T.target.pos_feature_tot(campioni_pos + 1:size(T.target.pos_feature_tot,1),:);
    end
    if(size(T.target.neg_feature_tot,1) > 2*campioni_neg)
      T.target.neg_feature_tot = T.target.neg_feature_tot(campioni_neg + 1:size(T.target.neg_feature_tot,1),:);  
    end
       
       %g=G(T.target.A, T.target.pos_feature_tot', T.target.neg_feature_tot')  
      g = G_vect(T.target.A, T.target.pos_feature_tot', T.target.neg_feature_tot')
      if(abs(g) > abs(T.target.G)*1.3 || isnan(g) == 1)%|| g > T.target.G*1.25 || isinf(abs(g)) == 1 )
      %if(abs(g) > 10^(-4) || isnan(g) == 1 || isinf(abs(g)) == 1 )
        %T.target.pos_feature_tot = T.target.pos_feature_tot(1:size(T.target.pos_feature_tot,1) - size(pos_feature,1), :);
        %T.target.neg_feature_tot = T.target.neg_feature_tot(1:size(T.target.neg_feature_tot,1) - size(neg_feature,1), :);  
        feature_positive = size(T.target.pos_feature_tot,1);
        feature_negative = size(T.target.neg_feature_tot,1);
        sample= [T.target.pos_feature_tot; T.target.neg_feature_tot];
        label = [ones(feature_positive,1) zeros(feature_positive,1); zeros(feature_negative,1) ones(feature_negative,1)];
        %A = T.target.A;
        A = eye(225);
        %A = [eye(50) zeros(50,175)];
        %A = [ones(1,112) zeros(1,113);zeros(1,112) ones(1,113)];
        %A = [eye(50) eye(50) eye(50) eye(50) ones(50,25)];
        [Anew,fX,i] = minimize(A(:),'nca_obj',5,sample,label);
        T.target.A = reshape(Anew,225,225);
        %T.target.pos_feature_tot = [];
        %T.target.neg_feature_tot = [];
        %T.target.G = g;
        T.target.G = G_vect(T.target.A, T.target.pos_feature_tot', T.target.neg_feature_tot');
      end
      %T.target.G = g;
  end

return