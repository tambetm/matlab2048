# Matlab 2048

An agent playing game [2048](http://gabrielecirulli.github.io/2048/) using deep Q-learning in Matlab.

**NB!** I never got this code to learn too well, improvements are welcome!

How to download the code:
```
git--recursive clone https://github.com/tambetm/matlab2048.git
```

The code uses my fork of [DeepLearnToolbox](https://github.com/rasmusbergpalm/DeepLearnToolbox) to implement neural network.

How to run it:
```
clear all;
rng('shuffle');

% Add DeepLearnToolbox to path
addpath(genpath('DeepLearnToolbox'));

% How many games to play
n = 100;
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

% Plot results.
figure;
results = reshape([results_nn; results_random], 2, k, n/k);
errorbar(mean(results, 3)', std(results, 0, 3)');
legend('NNAgent', 'RandomAgent');
```

To see the moves agent makes and predicted Q-values play just one game:
```
EDU>> a.play(1)
     0     0     0     0
     0     0     0     2
     0     0     0     0
     0     2     0     0

DOWN(random)
Reward: 0
     0     0     0     0
     0     0     0     0
     0     0     2     0
     0     2     0     2

Q-values: 53.3039         49.4      51.5175      50.7218
UP(predicted)
Reward: 0
     0     2     2     2
     0     0     0     0
     0     0     2     0
     0     0     0     0

Q-values: 62.8255      62.2575      72.6659      63.6495
DOWN(predicted)
Reward: 4
     0     0     0     0
     0     0     0     2
     0     0     0     0
     0     2     4     2

...

Q-values: 64.0637      65.0713      65.0745      64.7698
DOWN(predicted)
Reward: 4
     2     4     2     8
     4    64     8    16
     8    16     2     4
    16     4    32     2

     1   616


ans =

   616
```

Q-values are in the order of UP, RIGHT, DOWN, LEFT.
