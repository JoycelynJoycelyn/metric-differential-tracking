function A = train( frame , obj_box)



    %numero di campioni true= (2 x true_sample + 1)^2
    obj_box=ceil(obj_box);
    h=rg_hist(imcrop(frame,obj_box));
    positive_sample=50; 
    negative_sample=50;
    soglia_pos=0.8;
    soglia_neg=0.3;


    pos_feature = [];
    neg_feature = [];
    
    
    N=getNeighbor(obj_box,positive_sample,1,size(frame));
    
    i=1;
    while(size(pos_feature,1) < positive_sample)
        rect = N(i,:);
        subImg= im2double(imcrop(frame,rect));
%         i_c = round(rect(3)/2 + rect(1));
%         j_c = round(rect(4)/2 + rect(2));
        feature= get_histogram_feature(subImg, rect, 225)';%, i_c, j_c)';
        pos_feature = [pos_feature; feature];
        i=i+1;
    end
    
    offset=1;
    
    while(size(neg_feature,1) < negative_sample)
        N = getNeighborWithOffset(obj_box,offset,size(frame));
        for i=1:size(N,1)
            rect = N(i,:);
            subImg= im2double(imcrop(frame,rect));
    %         i_c = round(rect(3)/2 + rect(1)); 
    %         j_c = round(rect(4)/2 + rect(2));
            inters=intersectBB(obj_box,rect);
            feature= get_histogram_feature(subImg, rect, 225)';%, i_c, j_c)';
            if(inters<soglia_neg && size(neg_feature,1) < negative_sample)
                neg_feature = [neg_feature; feature];
            end
        end
        offset = offset+1;
    end
    
        
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
    A = eye(225);
    [Anew,fX,i] = minimize(A(:),'nca_obj',5,sample,label);
    A = reshape(Anew,225,225);
    
end

