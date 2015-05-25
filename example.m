clear all;
rng('shuffle');

% Add DeepLearnToolbox to path
addpath(genpath('DeepLearnToolbox'));

% How many games to play
n = 1000;
% Number of groups for averaging
k = 10;

% Creates new agent with following parameters:
opts.exploration_steps = 0;
opts.exploration_rate = 0.05;
opts.discount_rate = 0;
opts.learning_rate = 0.001; 
opts.momentum = 0.95; 
opts.layers = [1000];
opts.preprocess = @(x) log2(max(x, 1));
opts.activation_function = 'relu';
opts.dropout_fraction = 0;
opts.weight_penalty = 0;
opts.minibatch_size = 100;
a = NNAgent(opts);
% Plays n games
results_nn = a.play(n);

% Plays n games by making random moves
b = RandomAgent();
results_random = b.play(n);

c = GreedyAgent();
results_greedy = c.play(n);

d = CornerAgent();
results_corner = d.play(n);

% Plot results.
figure;
results = reshape([results_nn; results_greedy; results_corner; results_random], 4, k, n/k);
errorbar(mean(results, 3)', std(results, 0, 3)');
legend('NNAgent', 'GreedyAgent', 'CornerAgent', 'RandomAgent');

figure;
results = reshape([results_nn; results_random], 2, k, n/k);
errorbar(mean(results, 3)', std(results, 0, 3)');
legend('NNAgent', 'RandomAgent');
