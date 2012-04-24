function S = get_S(M, A)

    S = (M'*(A'*A)*M) \ ( M'*(A'*A));

end