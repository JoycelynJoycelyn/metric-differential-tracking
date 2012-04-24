function N = getNeighbor(obj_box,positive_sample,step_positive,limit)
    s=ceil((sqrt(positive_sample)-1)/2);
    N=[];
    for i=(-s):s
        for j=(-s):s
            if(obj_box(1)+(step_positive*i)>0 && obj_box(2)+(step_positive*j)>0 && (obj_box(1)+(step_positive*i)+obj_box(3))<limit(2) && (obj_box(2)+(step_positive*j)+obj_box(4))<limit(1))
                N = [ N ; obj_box(1)+(step_positive*i),obj_box(2)+(step_positive*j),obj_box(3),obj_box(4)];
            end
        end
    end

end

