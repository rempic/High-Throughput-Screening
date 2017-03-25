function [val] = REMI_2_SIGMOID(z)

    val = 1./(1+exp(-z));

end
