function T = train( frame , obj_box, positive_sample, negative_sample,T)



    %numero di campioni true= (2 x true_sample + 1)^2
    obj_box=ceil(obj_box);
    h=rg_hist(imcrop(frame,obj_box));
%     positive_sample=10; 
%     negative_sample=10;
    soglia_pos=0.65;
    soglia_neg=0.005;


    pos_feature = [];
    pos_offset = [];
    neg_feature = [];
    neg_offset = [];
    while(size(pos_feature,1) < positive_sample || size(neg_feature,1) < negative_sample)
        offset = (min(obj_box(3), obj_box(4))/2) * randn(1,2);
        offset = [offset 0 0];
        rect = obj_box+offset;
        if(rect(1)>0 && rect(2)>0 && (rect(1)+rect(3))<size(frame,2) && (rect(2)+rect(4))<size(frame,1))
            
            inters=intersectBB(obj_box,rect);
            inters
            if(inters<soglia_neg && size(neg_feature,1) < negative_sample)
                     subImg= im2double(imcrop(frame,rect));
                     feature= get_histogram_feature(subImg, rect, 225)';
                     neg_offset = [neg_offset; offset];
                     neg_feature = [neg_feature; feature];
                     %disegnamo il campione negativo sul frame
                     rectangle('Position', rect, 'EdgeColor', 'y');
                     drawnow;
            end

            if(inters>soglia_pos && size(pos_feature,1) < positive_sample)
                subImg= im2double(imcrop(frame,rect));
                feature= get_histogram_feature(subImg, rect, 225)';
                pos_offset =[pos_offset; offset];
                pos_feature = [pos_feature; feature]; 
                %disegnamo il campione positivo sul frame
                rectangle('Position', rect, 'EdgeColor', 'r');
                drawnow;
            end
        end

    end
    
    feature_positive = size(pos_feature,1)
    feature_negative = size(neg_feature,1)
    sample= [pos_feature; neg_feature];
    label = [ones(size(pos_feature,1),1) zeros(size(pos_feature,1),1); zeros(size(neg_feature,1),1) ones(size(neg_feature,1),1)];
    %A = [eye(100) zeros(100,125)];
    %A = eye(225);
        A = [eye(50) zeros(50,175)];
        [Anew,fX,i] = minimize(A(:),'nca_obj',5,sample,label);
        T.target.A = reshape(Anew,50,225);
    T.target.G = G(A, pos_feature',neg_feature')
    
    T.target.pos_offset = pos_offset;
    T.target.neg_offset = neg_offset;
    T.target.pos_feature_tot = [ T.target.pos_feature_tot; pos_feature ];
     T.target.neg_feature_tot = [ T.target.neg_feature_tot; neg_feature ];
    
    G(A, pos_feature',neg_feature')
    
% randn(2,1)    
return 

