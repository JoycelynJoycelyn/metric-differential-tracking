function N = getNeighborWithOffset(obj_box,offset,limit)
     N=[];
     j=-offset;
     for i=-offset:offset
        if(obj_box(1)+(i)>0 && obj_box(2)+(j)>0 && (obj_box(1)+(i)+obj_box(3))<limit(1) && (obj_box(2)+(j)+obj_box(4))<limit(2))
            N = [ N ; obj_box(1)+(i),obj_box(2)+(j),obj_box(3),obj_box(4)];
        end
     end
     
     j=offset;
     for i=-offset:offset
        if(obj_box(1)+(i)>0 && obj_box(2)+(j)>0 && (obj_box(1)+(i)+obj_box(3))<limit(1) && (obj_box(2)+(j)+obj_box(4))<limit(2))
            N = [ N ; obj_box(1)+(i),obj_box(2)+(j),obj_box(3),obj_box(4)];
        end
     end
     
     i=-offset;
     for j=-offset:offset
        if(obj_box(1)+(i)>0 && obj_box(2)+(j)>0 && (obj_box(1)+(i)+obj_box(3))<limit(1) && (obj_box(2)+(j)+obj_box(4))<limit(2))
            N = [ N ; obj_box(1)+(i),obj_box(2)+(j),obj_box(3),obj_box(4)];
        end
     end
     
     i=offset;
     for j=-offset:offset
        if(obj_box(1)+(i)>0 && obj_box(2)+(j)>0 && (obj_box(1)+(i)+obj_box(3))<limit(1) && (obj_box(2)+(j)+obj_box(4))<limit(2))
            N = [ N ; obj_box(1)+(i),obj_box(2)+(j),obj_box(3),obj_box(4)];
        end
     end
     
end

