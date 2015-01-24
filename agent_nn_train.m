function nn = agent_nn_train(nn, b, discount_rate)
% AGENT_NN_TRAIN Train the network nn with minibatch b and discount_rate.
% Parameters:
%  nn - neural network
%  b - minibatch
%  discount_rate - future reward discount rate
% Returns trained neural network.

    % flatten states for input to neural network
    x = b.prestates(:,:);
    xx = b.poststates(:,:);
    
    % predict Q-values of prestates
    nn.testing = 1;
    nn = nnff(nn, x, zeros(size(x,1), nn.size(end)));
    nn.testing = 0;
    y = nn.a{end};

    % predict Q-values of poststates
    nn.testing = 1;
    nn = nnff(nn, xx, zeros(size(xx,1), nn.size(end)));
    nn.testing = 0;
    yy = nn.a{end};
    % maximum Q-value for each poststate
    yymax = max(yy, [], 2);
    
    % calculate discounted future reward for each state transition in batch
    for i = 1:size(x,1)
        % only change one action, other Q-values stay the same
        y(i, b.actions(i)) = b.rewards(i) + discount_rate * yymax(i);
    end

    % train the network (copied from nntrain())
    nn = nnff(nn, x, y);
    nn = nnbp(nn);
    nn = nnapplygrads(nn);
end
