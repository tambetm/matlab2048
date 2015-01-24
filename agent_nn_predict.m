function y = agent_nn_predict(nn, a)
% AGENT_NN_PREDICT Predict Q-values for state a with network nn.
% Parameters:
%  nn - neural network
%  a - game state
% Returns predicted Q-values.

    % flatten the matrix and turn into one-element minibatch
    x = a(:)';
    % copied from nnpredict()
    nn.testing = 1;
    nn = nnff(nn, x, zeros(size(x,1), nn.size(end)));
    nn.testing = 0;
    y = nn.a{end};
end
