function in = pointInBox(point,box)
in=0;
if( (box(1)<point(1) && point(1)<box(1)+box(3))  && (box(2)<point(2) && point(2)<box(2)+box(4)))
   in=1; 
end
end

