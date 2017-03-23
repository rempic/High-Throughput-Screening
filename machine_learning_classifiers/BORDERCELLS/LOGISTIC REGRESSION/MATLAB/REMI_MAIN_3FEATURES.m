%% test SIGMOID
%x = (-10:10);
%y = REMI_2_SIGMOID(x);
%plot(x,y);


%% LOAD DATA
% REMI_DATA4.txt
% 1: DistanceNuclVoro/FeretNuclus, 
% 2:FeretVoronoi/FeretNuclus, 
% 3:y (isBorder? 1/0)
%d = importdata('REMI_DATA4.txt');

% REMI_DATA5.txt
% 1: DistanceNuclVoro/FeretNuclus, 
% 2:VoronoiArea/NuclusArea, 
% 3:y (isBorder? 1/0)
d = importdata('REMI_NEWDATA_MULT2.txt');

%% ORGANIZE
n  = size(d.data,2);

Xo = d.data(:,1:n-1);
%Xo = [ones(size(X,1),1),Xo]; %add X0

X = d.data(:,1:n-1);
X = [ones(size(X,1),1),X]; %add X0
y = d.data(:,n);




%% RESCALING
% I applied a log value to bring the values a bit closer
% I noticed that the training set values with y=1 have a big variance
YES_LOG=0;
if YES_LOG ==1
    for i=1:size(X,1)
        X(i,2:n) = log(X(i,2:n));
    end 
end
m = max(X);

%% NORMALIZATION
% The normalization in this case doesn't improve the outcome
%X = REMI_NORMALIZATION(X)

%% PLOT 
%fprintf(['Plotting data with + indicating (y = 1) examples and o ' ...
%         'indicating (y = 0) examples.\n']);

%plotData(X(:,2:n), y);


%% TEST the REMI_COSTFUNCTION
%theta = zeros(size(X,2), 1);
%[J, grad] = REMI_3_COSTFUNCTION(theta, X, y);


%% run the logistic regression
%options = optimset('GradObj', 'on', 'MaxIter', 100);%initial_theta = zeros(size(X,2), 1);
%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost 
%[theta_out, cost] = fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

% Set regularization parameter lambda to 1 (you should vary this)
lambda = 10;
initial_theta = zeros(size(X,2), 1);
options = optimset('GradObj', 'on', 'MaxIter', 400);
[theta_out, J, exit_flag] = fminunc(@(t)(costFunctionReg(t, X, y, lambda)), initial_theta, options);


%% SHOW DECISION BOUNDARY
%mn = min(X);
%mx = max(X);

%REMI_plotDecisionBoundary(theta_out, X, y, [mn(2), mx(2), mn(3), mx(3)]);


%% TEST THE OUTCOME
k0=1;
k1=1;
for i = 1:size(X,1)
    if y(i)==0
        if YES_LOG ==1
            x0(k0) =[ 1 log(Xo(i,:))] * theta_out;
        else
            x0(k0) =[ 1 Xo(i,:)] * theta_out;
        end
        
        y0(k0) = sigmoid(x0(k0));
        k0=k0+1;
    end
    if y(i)==1
        
        if YES_LOG ==1
            x1(k1) =[ 1 log(Xo(i,:))] * theta_out;
        else
            x1(k1) =[ 1 Xo(i,:)] * theta_out;
        end
        
        y1(k1) = sigmoid(x1(k1));
        k1=k1+1;
    end
end

figure;
plot(x0,y0, 'ob');
hold on;
plot(x1,y1, 'or');

p = predict(theta_out, X);

fprintf('Train Accuracy: %f\n', mean(double(p == y)) * 100);


