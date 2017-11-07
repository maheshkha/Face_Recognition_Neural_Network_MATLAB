function testnn()
clc
close all
% Min/Max values for each input
PR = [0 1; 
      0 1];
% Size of hidden/output layer
S = [5 1];
% Cols - Input vectors, each col diff. vector
TI = [0 0 1 1;
      0 1 0 1];
% Cols - Target output for each vector   
TO = [-.9 .9 .9 -.9];
% Unit type for hidden and output layers
T = {'tansig' 'tansig'};
% Create neural net
net = newff(PR,S,T,'traingdm');

% Simulate and plot
Y1 = sim(net, TI);
subplot(1,3,1);
plot([1 2 3 4], Y1);

% Set number of training epochs and error
subplot(1,3,2);
net.trainParam.epochs = 500;
net.trainParam.goal   = 0.001;

% Train
[net, tr] = train(net, TI, TO);
%tr.perf  % - trace of performance error [epochs+1]

% Simulate and plot
Y1 = sim(net, TI);
subplot(1,3,3);
plot([1 2 3 4], Y1);


      