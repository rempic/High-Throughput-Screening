function [J, grad] = REMI_3_COSTFUNCTION(theta, X,y )

% theta is nx1 (n features)
% X is mxn (m example by n features)
% y is mx1 (0,1 vector)
grad = zeros(size(theta));

m = size(X,1);

J = (1/m) * sum(y .* -log(REMI_2_SIGMOID(X*theta)) + (1-y) .* log(1-REMI_2_SIGMOID(X*theta)));


grad = (1/m) .* (REMI_2_SIGMOID(X*theta)-y)'*X;

end