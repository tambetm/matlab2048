load states_points

% keep only states, where we can clearly distinguish better move
%mask = (points(:,1) ~= points(:,2));
%states = states(mask, :);
%points = points(mask, 1:2);

nr_samples = size(states, 1);
nr_train = 10000;
nr_test = 1000;

% sample randomly from states and points
train_idx = randperm(nr_train);
test_idx = nr_train + randperm(nr_samples - nr_train, nr_test);

train_x = states(train_idx, :);
train_y = points(train_idx, 1:2);
test_x = states(test_idx, :);
test_y = points(test_idx, 1:2);

%save('train_test.mat', 'train_x', 'train_y', 'test_x', 'test_y');
%load train_test

% logarithmic scale
train_x = log2(max(train_x, 1));
train_y = log2(max(train_y, 1));
test_x = log2(max(test_x, 1));
test_y = log2(max(test_y, 1));

% scale
%train_x = train_x / 100;
%train_y = train_y / 100;
%test_x = test_x / 100;
%test_y = test_y / 100;

% normalize
%max_x = max(train_x);
%train_x = bsxfun(@rdivide, train_x, max_x);
%train_y = bsxfun(@rdivide, train_y, max_x);
%test_x = bsxfun(@rdivide, test_x, max_x);
%test_y = bsxfun(@rdivide, test_y, max_x);

% subtract mean
%mean_x = mean(train_x);
%train_x = bsxfun(@minus, train_x, mean_x); 
%test_x = bsxfun(@minus, test_x, mean_x); 

nn = nnsetup([16 1000 2]);
nn.learningRate = 0.001;
nn.momentum = 0.95;
nn.output = 'linear';
nn.activation_function = 'relu';
nn.dropoutFraction = 0;
nn.weightPenaltyL2 = 0;

opts.numepochs = 100;   %  Number of full sweeps through data
opts.batchsize = 100; %  Take a mean gradient step over this many samples
opts.plot      = 1;   %  enable plotting
nn = nntrain(nn, train_x, train_y, opts, test_x, test_y);

train_mask = (train_y(:,1) ~= train_y(:,2));
test_mask = (test_y(:,1) ~= test_y(:,2));
sum(train_mask)
sum(test_mask)
nntest(nn, train_x(train_mask, :), train_y(train_mask, :))
nntest(nn, test_x(test_mask, :), test_y(test_mask, :))

nn.testing = 1;
nn = nnff(nn, train_x, zeros(size(train_x,1), nn.size(end)));
nn.testing = 0;
pred_train_y = nn.a{end};

[dummy, train_actions] = max(train_y, [], 2);
[dummy, pred_train_actions] = max(pred_train_y, [], 2);

[train_y(1:10, :) pred_train_y(1:10, :) ...
    train_actions(1:10) pred_train_actions(1:10) ...
    train_actions(1:10) == pred_train_actions(1:10)]
