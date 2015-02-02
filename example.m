clear all;
rng('shuffle');

% Add DeepLearnToolbox to path
addpath(genpath('DeepLearnToolbox'));

% How many games to play
n = 100;
% Number of groups for averaging
k = 10;

% Creates new agent with 
%  - exploration rate 0.05, 
%  - discount rate 0.9, 
%  - learning rate 0.01, 
%  - momentum 0, 
%  - two layers 256 units each,
%  - no preprocessing
%  - sigmoidal activation function
%  - no dropout
%  - no weight decay
%  - minibatch size 32.
a = NNAgent(0.05, 0.9, 0.01, 0, [256 256], @(x) x, 'sigm', 0, 0, 32);
% Plays n games
results_nn = a.play(n);

% Plays n games by making random moves
b = RandomAgent();
results_random = b.play(n);

% Plot results.
figure;
results = reshape([results_nn; results_random], 2, k, n/k);
errorbar(mean(results, 3)', std(results, 0, 3)');
legend('NNAgent', 'RandomAgent');
