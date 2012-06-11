function T = track(T, frame)
  if isfield(T,'target')

      %calcolo della distribuzione p (candidate distribution)
      subIm = imcrop(frame, T.target.BB_p);

      T.target.subIm = im2double(subIm);
     % T.target.subIm = T.target.subIm / 255.0;
      T.target.p = get_histogram_feature(T, T.target.subIm, 216);%, T.target.i_c, T.target.j_c);
      
      

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

      write = fopen('file.txt', 'a+');
      fprintf(write, '%f,%f,%d,%d\n', T.target.BB_p);
      fclose(write);
      
      
      %training examples acquisition for g(A) evalutation
      neg_feature = [];
     % neg_offset = [];
      %pos_feature = [get_histogram_feature(T, im2double(imcrop(frame, T.target.BB_p)), 216)'];
      pos_feature = [];
      obj_box = T.target.BB_p;

     
     pos_offset_ind = [];
     neg_offset_ind = [];
     
     %random_offset_permutation = 0 fa prendere sempre gli stessi offset,
     %altrimenti effettua una permutazioni degli indici per prendere gli
     %offset in maniera casuale tra quelli usati nella fase di train
     %
     if(T.random_offset_permutation)
        pos_offset_ind = randperm(size(T.target.offset.pos,1));
        neg_offset_ind = randperm(size(T.target.offset.neg_rect,1));
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
              pos_feature=[pos_feature; get_histogram_feature(T, subImg, 216)'];
          end
     end
     
     % calcolo nuovi campioni negativi
     i=1;
     %for i=1:T.campioni_neg_track
     while (size(neg_feature,1)<T.campioni_neg_track && i<=size(T.target.offset.neg_rect,1))
          if(isempty(neg_offset_ind))
           % rect = T.target.offset.neg_rect(i,:);
            rect = T.target.offset.neg(i,:) + T.target.BB_p;
          else
            %rect = T.target.offset.neg_rect(neg_offset_ind(i),:);
            rect = T.target.offset.neg(neg_offset_ind(i),:) + T.target.BB_p;
          end
          inters=intersectBB(T.target.BB_p,rect);
          if(inters<T.soglia_neg && BBdistance(T.target.BB_p,rect) < sqrt(T.target.BB_p(3)^2 + T.target.BB_p(4)^2) + 50)
            if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
                  subImg= im2double(imcrop(frame,rect));
                neg_feature=[neg_feature; get_histogram_feature(T, subImg, 216)'];
            end
          end
          i=i+1;
     end
     while(size(neg_feature,1)<T.campioni_neg_track)
        %rect = ceil([   [size(frame,2) size(frame,1)].*rand(1,2)    obj_box(3) obj_box(4)]);
        %offset = [obj_box(1)-rect(1) obj_box(2)-rect(2) 0 0];
      %  if(T.frame_number == 84 || T.frame_number == 85 || T.frame_number == 83)
      %      pause();
      %  end
        offset = ceil([    [obj_box(3)/1 obj_box(4)/1] .* randn(1,2)    0 0]);
        rect = offset + T.target.BB_p;
        inters=intersectBB(T.target.BB_p,rect);
        if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
           if(inters<T.soglia_neg && BBdistance(T.target.BB_p,rect) < sqrt(T.target.BB_p(3)^2 + T.target.BB_p(4)^2) + 50) 
               T.target.offset.neg_rect =[T.target.offset.neg_rect;rect];
                T.target.offset.neg =[T.target.offset.neg; offset];
                subImg= im2double(imcrop(frame,rect));
                neg_feature=[neg_feature; get_histogram_feature(T, subImg, 216)'];
           end
        end
     end
%      while(size(pos_feature,1) < T.num_sample_positivi  || size(neg_feature,1) < T.num_sample_negativi)
%         %rect = ceil([   [size(frame,2) size(frame,1)].*rand(1,2)    obj_box(3) obj_box(4)]);
%         offset = ceil([    [obj_box(3) obj_box(4)].*randn(1,2)    0 0]);
%         %offset = ceil((min(obj_box(3), obj_box(4))/4) * randn(1,2));
%         %offset = [offset 0 0];
%         %offset = [obj_box(1)-rect(1) obj_box(2)-rect(2) 0 0];
%         rect = obj_box+offset;
%         if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
%             
%             inters=intersectBB(obj_box,rect);
%             
%             if(inters>T.soglia_pos && size(pos_feature,1) < T.num_sample_positivi)
%                 %positive sample
%                 T.target.offset.pos = [T.target.offset.pos ; offset];
%                 subImg= im2double(imcrop(frame,rect));
%                 feature= get_histogram_feature(T, subImg, 216)';
%              %   pos_offset =[pos_offset; offset];
%                 pos_feature = [pos_feature; feature]; 
%                 %disegnamo il campione positivo sul frame
%                 %rectangle('Position', rect, 'EdgeColor', 'r');
%                 %drawnow;
%             end
%             if(inters<T.soglia_neg && size(neg_feature,1) < T.num_sample_negativi)
%             %if(size(neg_feature,1) < negative_sample && inters < T.soglia_pos)
%                 %negative sample
%                      T.target.offset.neg=[T.target.offset.neg;offset];
%                      T.target.offset.neg_rect =[T.target.offset.neg_rect;rect]
%                      subImg= im2double(imcrop(frame,rect));
%                      feature= get_histogram_feature(T, subImg, 216)';
%                %      neg_offset = [neg_offset; offset];
%                      neg_feature = [neg_feature; feature];
%                      %disegnamo il campione negativo sul frame
%                      %rectangle('Position', rect, 'EdgeColor', 'y');
%                      %drawnow;
%             end
%             
%         end
% 
%     end
          obj_box = T.target.BB_p;
          %drawnow;

     %aggiungo i nuovi campioni a quelli ricavati precedentemente  
if(~isempty(pos_feature))
     T.target.pos_feature_tot = [ T.target.pos_feature_tot; pos_feature ];
end
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
      label = [ones(size(T.target.pos_feature_tot,1),1) zeros(size(T.target.pos_feature_tot,1),1); zeros(size(T.target.neg_feature_tot,1),1) ones(size(T.target.neg_feature_tot,1),1)];
      %%T.target.G = G_vect(T.target.A, pos_feature',neg_feature');
      %label = [ones(size(pos_feature,1),1) zeros(size(pos_feature,1),T.tot_campioni_neg); zeros(size(neg_feature,1),1) eye(T.tot_campioni_neg)];
      [T.target.F T.target.dF] =  nca_obj(T.target.A_min(:), sample, label);
      T.target.F = - T.target.F;
     
%     
%     T.target.F
%     g
%     pause();
    
      g = T.target.F;
      if(g>-10e-15)
        dat = [-10e-15; T.frame_number];
      else
        dat = [g; T.frame_number];
      end
      T.target.G_hist = [T.target.G_hist dat];
      if(size(T.target.G_hist,2)>20)
            T.target.G_hist = T.target.G_hist(:,size(T.target.G_hist,2)-20:size(T.target.G_hist,2));
      end
      if(g>0)
        ordine_grand = 0
      else
        ordine_grand = floor(log10(abs(g)));
        if(ordine_grand<0)
           if(ordine_grand<-12)
               ordine_grand = 12;
           else
                   ordine_grand = abs(ordine_grand);
           end
        else
           ordine_grand = 0;
        end
      end
      %al = normcdf(ordine_grand,0,20);
      %al = ordine_grand/12;
      al = 1;
      T.target.A = al*T.target.A_min + (1-al)*eye(216);
%       if(abs(g) > 1.0e-5 )
%          [Anew,fX,i] = minimize(T.target.A_min(:),'nca_obj',1,sample,label);
%          while(nca_obj(Anew, sample, label)>1.0e-5)
%             [Anew,~,i] = minimize(Anew,'nca_obj',1,sample,label);
%          end
%          T.target.A_min = reshape(Anew,216,216);
%       end
%       %if(abs(g) > abs(T.target.G)*1.3)% || isnan(g) == 1)%|| g > T.target.G*1.25 || isinf(abs(g)) == 1 )
%       if(abs(g) > T.threshold || isnan(g) == 1 || isinf(abs(g)) == 1 )
%         T.target.pos_feature_tot = T.target.pos_feature_tot(1:size(T.target.pos_feature_tot,1) - size(pos_feature,1), :);
%         %T.target.neg_feature_tot = T.target.neg_feature_tot(1:size(T.target.neg_feature_tot,1) - size(neg_feature,1), :);  
%         feature_positive = size(T.target.pos_feature_tot,1);
%         feature_negative = size(T.target.neg_feature_tot,1);
%         sample= [T.target.pos_feature_tot; T.target.neg_feature_tot];
%         label = [ones(feature_positive,1) zeros(feature_positive,1); zeros(feature_negative,1) ones(feature_negative,1)];
%         %label = [ones(size(pos_feature,1),1) zeros(size(pos_feature,1),T.tot_campioni_neg); zeros(size(neg_feature,1),1) eye(T.tot_campioni_neg)];
%         %A = T.target.A;
%         %A = eye(216);
%         %A = [eye(50) zeros(50,175)];
%         %A = [ones(1,112) zeros(1,113);zeros(1,112) ones(1,113)];
%         %A = [eye(50) eye(50) eye(50) eye(50) ones(50,25)];
%         
%         [Anew,fX,i] = minimize(T.target.A_min(:),'nca_obj',1,sample,label);
%         while(nca_obj(Anew, sample, label)>1.0e-5)
%             [Anew,~,i] = minimize(Anew,'nca_obj',1,sample,label);
%         end
%         %[Anew,fX,i] = minimize(T.target.A(:),'nca_obj',5,sample,label);
%         T.target.A_min = reshape(Anew,216,216);
%         %T.target.pos_feature_tot = [];
%         %T.target.neg_feature_tot = [];
%         %T.target.G = g;
%         %T.target.G = G_vect(T.target.A, T.target.pos_feature_tot', T.target.neg_feature_tot');
%         %T.target.G = G_vect(T.target.A, pos_feature',neg_feature');
%         [T.target.F T.target.dF] =  nca_obj(T.target.A_min(:), sample, label);
%         T.target.F = - T.target.F;
%         T.target.G = T.target.F;
%     
% %     T.target.F
% %     T.target.G
%         dat = [T.target.G; T.frame_number];
%         T.target.G_hist = [T.target.G_hist dat];
%         if(size(T.target.G_hist,2)>20)
%             T.target.G_hist = T.target.G_hist(:,size(T.target.G_hist,2)-20:size(T.target.G_hist,2));
%         end
%       end
      
      subplot('Position',[0.1 0.05 0.75 0.25]);
      semilogy(T.target.G_hist(2,:) , T.target.G_hist(1,:));
      xlim([T.target.G_hist(2,1) T.target.G_hist(2,size(T.target.G_hist,2))+1]);
      ylim([-10^2 -10^-16]);
      ylabel('G(A)')
      xlabel('Frame Number')
      subplot('Position',[0.9 0.05 0.03 0.25])
      bar(al+0.01);
      ylim([0 1]);
      set(gca,'YTick',0:1:1);
      set(gca,'YTickLabel',{'Id' , 'A'});
      set(gca,'XTickLabel',[]);
      set(gca,'color',[1 0 0]);
      subplot('Position',[0.1 0.35 0.85 0.6]);
      % T.target.G = g;
  end

return