% Desc:   Trains a neural net given a training set with target values
%         and randomly selects training and validation data, training
%         either for the max number of networks, network convergence,
%         or increase in validation error.  Returns network and
%         performance. 
% 
% [NET,PERF, ERR] = trainnn(NET,IMVECTOR,TVECTOR,percent_val,iter)
function [NET,PERF, ERR] = trainnn(NET,IMVECTOR,TVECTOR,percent_val,iter)

% Setup validation and test sets
N_IMS = size(IMVECTOR,2);
CHOICE  = rand(1,N_IMS) > percent_val;
V_TRAIN = find(CHOICE);
V_VALID = find(1-CHOICE);
IM_TRAIN_V = IMVECTOR(:,V_TRAIN);
IM_TRAIN_R = TVECTOR (:,V_TRAIN);
IM_VALID_V = IMVECTOR(:,V_VALID);
IM_VALID_R = TVECTOR (:,V_VALID);
% fprintf(1,'Training set quantity:   #%d\n', size(IM_TRAIN_V,2));
% fprintf(1,'Validation set quantity: #%d\n', size(IM_VALID_V,2));

% Setup net parameters
NET.trainParam.epochs = 1000;
NET.trainParam.goal   = 0.0001;
NET.trainParam.show=100; % traing plot to display

% NET.inputweights{1,1}.initFcn='rands';
% NET.biases{1}.initFcn='rands';
% NET=init(NET); %initialisation
% NET.trainParam.show=1000; % traing plot to display
% NET.trainParam.lr=0.2; % learning rate
% NET.trainParam.mc=0.1; % momentum coefficients
% NET.trainParam.epochs=5000; % total interations
% NET.trainParam.goal=0.0015;  % accuracy 

TRAIN_OUT = simnn(NET,IM_TRAIN_V);
VALID_OUT = simnn(NET,IM_VALID_V);
PERF = [];
ERR  = [];
PERF = [PERF; 0, (1-(sum(abs(TRAIN_OUT-IM_TRAIN_R)./1.8)./(size(TRAIN_OUT,2)))), ...
                 (1-(sum(abs(VALID_OUT-IM_VALID_R)./1.8)./(size(VALID_OUT,2))))];
ERR  = [ERR;  0, ((sum(abs(TRAIN_OUT-IM_TRAIN_R))./(size(TRAIN_OUT,2))).^2), ...
                 ((sum(abs(VALID_OUT-IM_VALID_R))./(size(VALID_OUT,2))).^2)];

% Train for specified number of iterations
for i=1:iter,
  fprintf(1,'Starting iteration %d\n', i);
%   figure,
  drawnow;
  [NET, TR] = train(NET, IM_TRAIN_V, IM_TRAIN_R);
  TRAIN_OUT = simnn(NET,IM_TRAIN_V);
  VALID_OUT = simnn(NET,IM_VALID_V);
  %[TRAIN_OUT; IM_TRAIN_R]
  %[VALID_OUT; IM_VALID_R]
  PERF = [PERF; i, (1-(sum(abs(TRAIN_OUT-IM_TRAIN_R)./1.8)./(size(TRAIN_OUT,2)))), ...
                   (1-(sum(abs(VALID_OUT-IM_VALID_R)./1.8)./(size(VALID_OUT,2))))];
  ERR  = [ERR;  i, ((sum(abs(TRAIN_OUT-IM_TRAIN_R))./(size(TRAIN_OUT,2))).^2), ...
                   ((sum(abs(VALID_OUT-IM_VALID_R))./(size(VALID_OUT,2))).^2)];
end





