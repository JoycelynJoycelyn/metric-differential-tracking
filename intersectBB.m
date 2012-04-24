function I =intersectBB(a,b)
    %restituisce un valore tra 0 e 1 che quantifica l'intersezione tra le
    %due BB
    [x y] = intersectgeoquad([a(1),a(1)+a(3)],[a(2),a(2)+a(4)],[b(1),b(1)+b(3)],[b(2),b(2)+b(4)]);
    if(isempty(x) && isempty(y))
        I=0;
    else
        intersArea = ( (x(2)-x(1)) * (y(2)-y(1)) );
        I=intersArea/(a(3)*a(4)+b(3)*b(4)-intersArea);
    end    
end

