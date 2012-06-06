function d = BBdistance( BB1, BB2 )
  d= sqrt((BB1(1)+(BB1(3)/2) - BB2(1)+(BB2(3)/2))^2 + (BB1(2)+(BB1(4)/2) - BB2(2)+(BB2(4)/2))^2);
end

