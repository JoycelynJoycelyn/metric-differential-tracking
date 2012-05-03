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
      
      %training examples acquisition
      %numero di campioni true= (2 x true_sample + 1)^2
        obj_box=ceil(T.target.BB_p);
        h=rg_hist(imcrop(frame,obj_box));
        soglia_pos=0.8;
        soglia_neg=0.12;

        pos_feature = [];
        neg_feature = [];

        N=getNeighbor(obj_box,4,1,size(frame));
        i=1;
        while(size(pos_feature,1) < 4)
            rect = N(i,:);
            subImg= im2double(imcrop(frame,rect));
            feature= get_histogram_feature(subImg, rect, 225)';
            pos_feature = [pos_feature; feature];
            i=i+1;
            %disegnamo il campione positivo sul frame
           % rectangle('Position', rect, 'EdgeColor', 'r');
           % drawnow;
        end
        offset=1;
    
        while(size(neg_feature,1) < 4)
            N = getNeighborWithOffset(obj_box,offset,size(frame));
            for i=1:size(N,1)
                rect = N(i,:);
                subImg= im2double(imcrop(frame,rect));
                inters=intersectBB(obj_box,rect);
                feature= get_histogram_feature(subImg, rect, 225)';
                if(inters<soglia_neg && size(neg_feature,1) < 4)
                    neg_feature = [neg_feature; feature];
                    %disegnamo il campione negativo sul frame
                %    rectangle('Position', rect, 'EdgeColor', 'y');
                %    drawnow;
                end
            end
            offset = offset+1;
        end
        
        T.target.pos_feature_tot = [ T.target.pos_feature_tot; pos_feature ];
        T.target.neg_feature_tot = [ T.target.neg_feature_tot; neg_feature ];
       
      % evaluation of g(A), and any metric adjustment 
      
  end

%end
return