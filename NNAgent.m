classdef NNAgent < handle
    %NNAGENT Agent that plays 2048 game.
    %   Uses neural network to calculate Q-values.
    
    properties (Constant)
        rows = 4;
        cols = 4;
        actions = 4;
        memory_size = 1000000;
        action_labels = {'UP', 'RIGHT', 'DOWN', 'LEFT'};
    end

    properties
        exploration_rate;
        discount_rate;
        minibatch_size;

        mem;
        nnet;
        game;
    end

    methods
        function this = NNAgent(exploration_rate, discount_rate, learning_rate, momentum, layers, minibatch_size)
        % NNAGENT Creates deep Q-learning agent.
        % Parameters:
        %  exporation_rate - choose random move with this probability, i.e. 0.05.
        %  discount_rate - discount future rewards by this coefficient, i.e. 0.9.
        %  learning_rate - learning rate of neural network, i.e. 0.01.
        %  momentum - momentum of learning, set to 0 for no momentum.
        %  layers - sizes of hidden layers as vector, i.e. [256 256].
        %  minibatch_size - minibatch size when training the network.

            % remember parameters
            this.exploration_rate = exploration_rate;
            this.discount_rate = discount_rate;
            this.minibatch_size = minibatch_size;

            % initialize memory
            this.mem = Memory(this.memory_size, [this.rows this.cols]);

            % initialize neural network
            this.nnet = nnsetup([this.rows*this.cols layers this.actions]);
            this.nnet.output = 'linear';
            this.nnet.momentum = momentum;
            this.nnet.activation_function = 'tanh_opt';
            this.nnet.learningRate = learning_rate;
            
            % initialize game
            this.game = Game(this.rows, this.cols);
        end
        
        function results = play(this, nr_games)
        % PLAY Play 2048 game with deep Q-learning agent.
        % Parameters:
        %  nr_games - number of games to play. If 1, then also displays debug info.
        % Returns scores in those games as a vector.
        % You can call this function several times and it continues 
        % improving the same network, but learning_rate, momentum and 
        % layers take effect only on first time. 

            % play nr_games
            for i = (1:nr_games)
                % initialize game field
                this.game.new();
                results(i) = 0;
                if (nr_games == 1)
                    disp(this.game.state);
                end
                % play till end
                while (~this.game.end())
                    % choose random action with probability exploration_rate
                    if (unifrnd(0, 1) < this.exploration_rate)
                        % choose random action
                        action = randi(this.actions);
                        if (nr_games == 1)
                            disp([this.action_labels{action} '(random)'])
                        end
                    else
                        % choose action with the best Q-value
                        qvalues = this.predict(this.game.state);
                        [dummy, action] = max(qvalues, [], 2);
                        if (nr_games == 1)
                            disp(['Q-values: ' num2str(qvalues)]);
                            disp([this.action_labels{action} '(predicted)'])
                        end
                    end

                    % make a move and observe reward
                    a = this.game.state;
                    [points, changed] = this.game.move(action);
                    b = this.game.state;
                    results(i) = results(i) + points;
                    if (nr_games == 1)
                        disp(['Reward: ', num2str(points)]);
                        disp(b);
                    end

                    % add state transition to memory only if changed
                    if changed
                        this.mem.add(a, action, points, b);
                    end

                    % if memory contain enough states
                    if this.mem.size > this.minibatch_size
                        % get minibatch from memory and train network
                        this.train(this.mem.minibatch(this.minibatch_size));
                    end
                end
                disp([i results(i)]);
            end
        end

        function y = predict(this, a)
        % PREDICT Predict Q-values for state a.
        % Parameters:
        %  a - game state
        % Returns predicted Q-values.
            % flatten the matrix and turn into one-element minibatch
            x = max(log2(a(:)'), 0);
            % copied from nnpredict()
            this.nnet.testing = 1;
            this.nnet = nnff(this.nnet, x, zeros(size(x,1), this.nnet.size(end)));
            this.nnet.testing = 0;
            y = this.nnet.a{end};
        end

        function train(this, b)
        % TRAIN Train the network nn with minibatch b and discount_rate.
        % Parameters:
        %  b - minibatch
        % Returns trained neural network.

            % flatten states for input to neural network
            x = max(log2(b.prestates(:,:)), 0);
            xx = max(log2(b.poststates(:,:)), 0);

            % predict Q-values of prestates
            this.nnet.testing = 1;
            this.nnet = nnff(this.nnet, x, zeros(size(x,1), this.nnet.size(end)));
            this.nnet.testing = 0;
            y = this.nnet.a{end};

            % predict Q-values of poststates
            this.nnet.testing = 1;
            this.nnet = nnff(this.nnet, xx, zeros(size(xx,1), this.nnet.size(end)));
            this.nnet.testing = 0;
            yy = this.nnet.a{end};
            % maximum Q-value for each poststate
            yymax = max(yy, [], 2);

            % calculate discounted future reward for each state transition in batch
            for i = 1:size(x,1)
                % only change one action, other Q-values stay the same
                y(i, b.actions(i)) = b.rewards(i) + this.discount_rate * yymax(i);
            end

            % train the network (copied from nntrain())
            this.nnet = nnff(this.nnet, x, y);
            this.nnet = nnbp(this.nnet);
            this.nnet = nnapplygrads(this.nnet);
        end
    end
    
end
