function A = train( frame , obj_box, positive_sample, negative_sample)



    %numero di campioni true= (2 x true_sample + 1)^2
    obj_box=ceil(obj_box);
    h=rg_hist(imcrop(frame,obj_box));
%     positive_sample=10; 
%     negative_sample=10;
    soglia_pos=0.8;
    soglia_neg=0.05;


    pos_feature = [];
    neg_feature = [];
    
    while(size(pos_feature,1) < positive_sample || size(neg_feature,1) < negative_sample)
        offset = 10* randn(1,2);
        offset = [offset 0 0];
        rect = obj_box+offset;
        if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
            subImg= im2double(imcrop(frame,rect));
            feature= get_histogram_feature(subImg, rect, 225)';
            inters=intersectBB(obj_box,rect);

            if(inters<soglia_neg && size(neg_feature,1) < negative_sample)
                     neg_feature = [neg_feature; feature];
                     %disegnamo il campione negativo sul frame
                     rectangle('Position', rect, 'EdgeColor', 'y');
                     drawnow;
            end

            if(inters>soglia_pos && size(pos_feature,1) < positive_sample)
                pos_feature = [pos_feature; feature]; 
                %disegnamo il campione positivo sul frame
                rectangle('Position', rect, 'EdgeColor', 'r');
                drawnow;
            end
        end

    end
    
%     N=getNeighbor(obj_box,positive_sample,1,size(frame));
%     
%     i=1;
%     while(size(pos_feature,1) < positive_sample)
%         rect = N(i,:);
%         subImg= im2double(imcrop(frame,rect));
%         feature= get_histogram_feature(subImg, rect, 225)';
%         pos_feature = [pos_feature; feature];
%         i=i+1;
%         %disegnamo il campione positivo sul frame
%         rectangle('Position', rect, 'EdgeColor', 'r');
%         drawnow;
% 
%     end
%     
%     offset=1;
%     
%     while(size(neg_feature,1) < negative_sample)
%         N = getNeighborWithOffset(obj_box,offset,size(frame));
%         for i=1:size(N,1)
%             rect = N(i,:);
%             subImg= im2double(imcrop(frame,rect));
%             inters=intersectBB(obj_box,rect);
%             feature= get_histogram_feature(subImg, rect, 225)';
%             if(inters<soglia_neg && size(neg_feature,1) < negative_sample)
%                 neg_feature = [neg_feature; feature];
%                 %disegnamo il campione negativo sul frame
%                 rectangle('Position', rect, 'EdgeColor', 'y');
%                 drawnow;
%             end
%         end
%         offset = offset+10;
%     end
    
        
%     step_orizzontale=ceil(size(frame,2)/((2*positive_sample)+1));
%     step_verticale =ceil(size(frame,1)/((2*positive_sample)+1));
%     
%     for i=0:((2*positive_sample))
%         for j=0:((2*positive_sample))
%             box=[i*step_orizzontale, j*step_verticale, step_orizzontale, step_verticale ];
%             if(~( pointInBox([box(1),box(2)],obj_box) || pointInBox([box(1)+box(3),box(2)],obj_box) || pointInBox([box(1),box(2)+box(4)],obj_box) || pointInBox([box(1)+box(3),box(2)+box(4)],obj_box) ))
%                 neg_feature = [neg_feature; rg_hist(imcrop(frame,box))];
%             end
%         end
%     end
    feature_positive = size(pos_feature,1)
    feature_negative = size(neg_feature,1)
    sample= [pos_feature; neg_feature];
    label = [ones(size(pos_feature,1),1) zeros(size(pos_feature,1),1); zeros(size(neg_feature,1),1) ones(size(neg_feature,1),1)];
    %A = [eye(100) zeros(100,125)];
    A = eye(225);
    G(A, pos_feature',neg_feature')
    
    [Anew,fX,i] = minimize(A(:),'nca_obj',5,sample,label);
    A = reshape(Anew,225,225);
    
    G(A, pos_feature',neg_feature')
    
% randn(2,1)    
end

