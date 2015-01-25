function results = agent_nn(nr_games, exploration_rate, discount_rate, learning_rate, momentum, layers, minibatch_size)
% AGENT_NN Play 2048 game with deep Q-learning agent.
% Parameters:
%  nr_games - number of games to play. If 1, then also displays debug info.
%  exporation_rate - choose random move with this probability, i.e. 0.05.
%  discount_rate - discount future rewards by this coefficient, i.e. 0.9.
%  learning_rate - learning rate of neural network, i.e. 0.01.
%  momentum - momentum of learning, set to 0 for no momentum.
%  layers - sizes of hidden layers as vector, i.e. [256 256].
%  minibatch_size - minibatch size when training the network.
% Returns scores in those games as a vector.
% Neural network and memory are retained for next invocations as global
% variables. So you can call this function several times and it continues 
% improving the same network, but learning_rate, momentum and layers take 
% effect only on first time. If you want to clear neural network and 
% memory, issue clear all command.

    action_labels = {'UP', 'RIGHT', 'DOWN', 'LEFT'};
    global m;
    global nn;
    if isempty(m)
        memory_init(1000000, [4 4]);
    end
    % initialize neural network, if it hasn't been initialized yet
    if isempty(nn)
        nn = nnsetup([4*4 layers 4]);
        nn.output = 'linear';
        nn.momentum = momentum;
        nn.activation_function = 'sigm';
        nn.learningRate = learning_rate;
    end
  
    % play nr_games
    for i = (1:nr_games)
        % initialize game field
        a = game_init(4, 4);
        results(i) = 0;
        if (nr_games == 1)
            disp(a);
        end
        % play till end
        while (~game_end(a))
            % choose random action with probability exploration_rate
            if (unifrnd(0, 1) < exploration_rate)
                % choose random action
                action = randi(4);
                if (nr_games == 1)
                    disp([action_labels{action} '(random)'])
                end
            else
                % choose action with the best Q-value
                qvalues = agent_nn_predict(nn, a);
                [dummy, action] = max(qvalues, [], 2);
                if (nr_games == 1)
                    disp(['Q-values: ' num2str(qvalues)]);
                    disp([action_labels{action} '(predicted)'])
                end
            end

            % make a move and observe reward
            [b, points] = game_move(a, action);
            results(i) = results(i) + points;
            if (nr_games == 1)
                disp(['Reward: ', num2str(points)]);
                disp(b);
            end
            
            % add state transition to memory
            memory_add(a, action, points, b);
            a = b;

            % if memory contain enough states
            if m.size > minibatch_size
                % get minibatch from memory and train network
                b = memory_minibatch(minibatch_size);
                nn = agent_nn_train(nn, b, discount_rate);
            end
        end
        disp([i results(i)]);
    end
end
