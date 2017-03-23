function X_OUT = REMI_NORMALIZATION(X)

    mx = max(X);
    mn = min(X);
    md = mean(X);

    X_OUT = ones(size(X,1),size(X,2));
    
    nn = size(X,2);
    for i=1:size(X,1)
        X_OUT(i,2:nn) = X(i,2:nn)./(mx(2:nn)-mn(2:nn));
        %X_OUT(i,2:3) = (X(i,2:3)-md(2:3))./(mx(2:3)-mn(2:3));
    end 

end
