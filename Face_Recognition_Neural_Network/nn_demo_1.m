clc
close all
clear all

%input
P = [0 1 2 3 4 5 6 7 8 9 10];

%initialise NN
net = newff([0 10],[5 1],{'tansig' 'purelin'});
Y = sim(net,P);

%target output
T = [0 1 2 3 4 3 2 1 0 3 4];
plot(P,T,P,Y,'r');

net.trainParam.epochs = 50;

% net.trainparam.show=1000;
% net.trainparam.epochs=10500;
% net.trainparam.goal=.00001;
% net.trainparam.mingrad=1.0000e-018
% net.trainparam.min_grad=1.0000e-018

%training started
net = train(net,P,T);

save network_50epochs net;

Y = sim(net,P);
figure,
plot(P,T,P,Y,'r')