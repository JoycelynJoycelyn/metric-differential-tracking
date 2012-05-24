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
     

     
     pos_offset_ind = [];
     neg_offset_ind = [];
     
     %random_offset_permutation = 0 fa prendere sempre gli stessi offset,
     %altrimenti effettua una permutazioni degli indici per prendere gli
     %offset in maniera casuale tra quelli usati nella fase di train
     %
     if(T.random_offset_permutation)
        pos_offset_ind = randperm(size(T.target.offset.pos,1));
        neg_offset_ind = randperm(size(T.target.offset.neg,1));
     end
     
     % calcolo nuovi campioni positivi
     for i=1:T.campioni_pos_track
          if(isempty(pos_offset_ind))
            rect = T.target.BB_p+T.target.offset.pos(i,:);
          else
            rect = T.target.BB_p+T.target.offset.pos(pos_offset_ind(i),:);
          end
          if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
              subImg= im2double(imcrop(frame,rect));
              pos_feature=[pos_feature; get_histogram_feature(T, subImg, 225)'];
          end
     end
     
     % calcolo nuovi campioni negativi
     for i=1:T.campioni_neg_track
          if(isempty(neg_offset_ind))
            rect = T.target.BB_p+T.target.offset.neg(i,:);
          else
            rect = T.target.BB_p+T.target.offset.neg(neg_offset_ind(i),:);
          end
          if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
              subImg= im2double(imcrop(frame,rect));
              neg_feature=[neg_feature; get_histogram_feature(T, subImg, 225)'];
          end
     end
          obj_box = T.target.BB_p;
          drawnow;

     %aggiungo i nuovi campioni a quelli ricavati precedentemente  
     T.target.pos_feature_tot = [ T.target.pos_feature_tot; pos_feature ];
     T.target.neg_feature_tot = [ T.target.neg_feature_tot; neg_feature ];
    
     if(size(T.target.pos_feature_tot,1) > T.tot_campioni_pos)
        T.target.pos_feature_tot = T.target.pos_feature_tot(size(T.target.pos_feature_tot,1) - T.tot_campioni_pos + 1:size(T.target.pos_feature_tot,1),:);
     end
     if(size(T.target.neg_feature_tot,1) > T.tot_campioni_neg)
       T.target.neg_feature_tot = T.target.neg_feature_tot(size(T.target.neg_feature_tot,1) - T.tot_campioni_neg + 1:size(T.target.neg_feature_tot,1),:);  
     end
       
       %g=G(T.target.A, T.target.pos_feature_tot', T.target.neg_feature_tot')
      
      %g = G_vect(T.target.A, T.target.pos_feature_tot', T.target.neg_feature_tot')
      sample= [T.target.pos_feature_tot; T.target.neg_feature_tot];
      label = [ones(T.tot_campioni_pos,1) zeros(T.tot_campioni_pos,1); zeros(T.tot_campioni_neg,1) ones(T.tot_campioni_neg,1)];
      %%T.target.G = G_vect(T.target.A, pos_feature',neg_feature');
      %label = [ones(size(pos_feature,1),1) zeros(size(pos_feature,1),T.tot_campioni_neg); zeros(size(neg_feature,1),1) eye(T.tot_campioni_neg)];
      [T.target.F T.target.dF] =  nca_obj(T.target.A(:), sample, label);
      T.target.F = - T.target.F;
%     
%     T.target.F
%     g
%     pause();
    
      g = T.target.F
      dat = [g; T.frame_number];
      T.target.G_hist = [T.target.G_hist dat];
       if(size(T.target.G_hist,2)>30)
            T.target.G_hist = T.target.G_hist(:,size(T.target.G_hist,2)-30:size(T.target.G_hist,2));
        end
      %if(abs(g) > abs(T.target.G)*1.3)% || isnan(g) == 1)%|| g > T.target.G*1.25 || isinf(abs(g)) == 1 )
%       if(abs(g) > T.threshold || isnan(g) == 1 || isinf(abs(g)) == 1 )
%         T.target.pos_feature_tot = T.target.pos_feature_tot(1:size(T.target.pos_feature_tot,1) - size(pos_feature,1), :);
%         %T.target.neg_feature_tot = T.target.neg_feature_tot(1:size(T.target.neg_feature_tot,1) - size(neg_feature,1), :);  
%         feature_positive = size(T.target.pos_feature_tot,1);
%         feature_negative = size(T.target.neg_feature_tot,1);
%         sample= [T.target.pos_feature_tot; T.target.neg_feature_tot];
%         label = [ones(feature_positive,1) zeros(feature_positive,1); zeros(feature_negative,1) ones(feature_negative,1)];
%         %label = [ones(size(pos_feature,1),1) zeros(size(pos_feature,1),T.tot_campioni_neg); zeros(size(neg_feature,1),1) eye(T.tot_campioni_neg)];
%         %A = T.target.A;
%         %A = eye(225);
%         %A = [eye(50) zeros(50,175)];
%         %A = [ones(1,112) zeros(1,113);zeros(1,112) ones(1,113)];
%         %A = [eye(50) eye(50) eye(50) eye(50) ones(50,25)];
%         
%         [Anew,fX,i] = minimize(T.target.A(:),'nca_obj',1,sample,label);
%         while(nca_obj(Anew, sample, label)>1.0e-5)
%             [Anew,fX,i] = minimize(Anew,'nca_obj',1,sample,label);
%         end
%         %[Anew,fX,i] = minimize(T.target.A(:),'nca_obj',5,sample,label);
%         T.target.A = reshape(Anew,225,225);
%         %T.target.pos_feature_tot = [];
%         %T.target.neg_feature_tot = [];
%         %T.target.G = g;
%         %T.target.G = G_vect(T.target.A, T.target.pos_feature_tot', T.target.neg_feature_tot');
%         %T.target.G = G_vect(T.target.A, pos_feature',neg_feature');
%         [T.target.F T.target.dF] =  nca_obj(T.target.A(:), sample, label);
%         T.target.F = - T.target.F;
%         T.target.G = T.target.F;
%     
% %     T.target.F
% %     T.target.G
%         dat = [T.target.G; T.frame_number];
%         T.target.G_hist = [T.target.G_hist dat];
%         if(size(T.target.G_hist,2)>30)
%             T.target.G_hist = T.target.G_hist(:,size(T.target.G_hist,2)-30:size(T.target.G_hist,2));
%         end
%       end
      subplot('Position',[0.1 0.05 0.85 0.25]);
      semilogy(T.target.G_hist(2,:) , T.target.G_hist(1,:));
      subplot('Position',[0.1 0.35 0.85 0.6]);
      % T.target.G = g;
  end

return