# Matlab 2048

An agent playing game [2048](http://gabrielecirulli.github.io/2048/) using deep Q-learning in Matlab.

How to download the code:
```
git clone git@github.com:tambetm/matlab2048.git
cd matlab2048
git submodule init
git submodule update
```
Last three lines are required to download [DeepLearnToolbox](https://github.com/rasmusbergpalm/DeepLearnToolbox).

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

% Creates new agent with 
%  - exploration rate 0.05, 
%  - discount rate 0.9, 
%  - learning rate 0.01, 
%  - momentum 0, 
%  - two layers 256 units each,
%  - minibatch size 32.
a = NNAgent(0.05, 0.9, 0.01, 0, [256 256], 32);
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
