%function q = get_histogram_feature(subIm, BB, m)
function q = get_histogram_feature(T, subIm, m)

q = zeros(m,1)'; 
 
U = get_U(subIm, m);
%K = get_K(subIm); %già normalizzato, pixel centrati e la relativa distanza dal centro
K = T.target.K;
if(size(U,1) ~= size(K,1))
    display('dimensioni diverse');
    %adattiamo la subIm dell' esempio di dimensioni diverse, mettendola
    %uguale a quella del target
    if(size(subIm,1) > size(T.target.subIm,1))
        %una riga in più rispetto al target -> togliamo una riga
        subIm = subIm(1:size(T.target.subIm,1) - 1, :, :);
    else if(size(subIm,1) < size(T.target.subIm,1))
         %una riga in meno rispetto al target -> aggiungiamo una riga
         %mettiamo tutti zeri per semplicità
         subIm = [ subIm; zeros(1, size(subIm,2), 3) ];
        end
    end
    if(size(subIm,2) > size(T.target.subIm,2))
        %una colonna in più rispetto al target -> togliamo una colonna
        subIm = subIm(:, 1:size(T.target.subIm,2) - 1, :);
    else if(size(subIm,2) < size(T.target.subIm,2))
         %una colonna in meno rispetto al target -> aggiungiamo una colonna
         %mettiamo tutti zeri per semplicità
         subIm = [ subIm, zeros(size(subIm,1),1, 3) ];
        end
    end
    U = get_U(subIm, m);

%    pause();
end
q = U' * K;
q = q ./ norm(q,2);

%q = q + 0.001 ;
%q = q ./ sum(q);
%sum(q)

end