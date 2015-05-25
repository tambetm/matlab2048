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
        exploration_steps;
        exploration_rate;
        discount_rate;
        minibatch_size;
        preprocess;

        mem;
        nnet;
        game;
    end

    methods
        function this = NNAgent(opts)
        % NNAGENT Creates deep Q-learning agent.
        % Parameters:
        %  exporation_rate - choose random move with this probability, i.e. 0.05.
        %  discount_rate - discount future rewards by this coefficient, i.e. 0.9.
        %  learning_rate - learning rate of neural network, i.e. 0.01.
        %  momentum - momentum of learning, set to 0 for no momentum.
        %  layers - sizes of hidden layers as vector, i.e. [256 256].
        %  minibatch_size - minibatch size when training the network.

            % remember parameters
            this.exploration_steps = opts.exploration_steps;
            this.exploration_rate = opts.exploration_rate;
            this.discount_rate = opts.discount_rate;
            this.minibatch_size = opts.minibatch_size;
            this.preprocess = opts.preprocess;

            % initialize memory
            this.mem = Memory(this.memory_size, [this.rows this.cols]);

            % initialize neural network
            this.nnet = nnsetup([this.rows*this.cols opts.layers this.actions]);
            this.nnet.output = 'linear';
            this.nnet.momentum = opts.momentum;
            this.nnet.activation_function = opts.activation_function;
            this.nnet.dropoutFraction = opts.dropout_fraction;
            this.nnet.weightPenaltyL2 = opts.weight_penalty;
            this.nnet.learningRate = opts.learning_rate;
            
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
            iteration = 0;
            scores = [];
            avg_scores = [];
            game_count = 0;
            game_counts = [];
            losses = [];
            q_states = {};
            q_values = [];

            % play nr_games
            for i = (1:nr_games)
                % initialize game field
                this.game.new();
                results(i) = 0;
                if (nr_games == 1)
                    disp(this.game.state);
                end
                % play till end
                terminal = false;
                while (~terminal)
                    epsilon = this.compute_epsilon(iteration);
                    % choose random action with probability exploration_rate
                    if (unifrnd(0, 1) < epsilon)
                        % choose random action
                        action = randi(this.actions);
                        if (nr_games == 1)
                            disp([this.action_labels{action} '(random)'])
                        end
                    else
                        % choose action with the best Q-value
                        qvalues = this.predict(this.game.state);
                        [~, action] = max(qvalues, [], 2);
                        if (nr_games == 1)
                            disp(['Q-values: ' num2str(qvalues)]);
                            disp([this.action_labels{action} '(predicted)'])
                        end
                    end

                    % make a move and observe reward
                    a = this.game.state;
                    [points, changed] = this.game.move(action);
                    b = this.game.state;
                    terminal = this.game.end();
                    results(i) = results(i) + points;
                    if (nr_games == 1)
                        disp(['Reward: ', num2str(points)]);
                        disp(b);
                    end

                    % add state transition to memory only if changed
                    if changed
                        this.mem.add(a, action, points, b, terminal);
                    end

                    % if memory contain enough states
                    if this.mem.size > this.minibatch_size
                        % get minibatch from memory and train network
                        this.train(this.mem.minibatch(this.minibatch_size));
                        iteration = iteration + 1;
                        if mod(iteration, 10000) == 0
                            if isempty(q_states)
                                q_states = this.mem.minibatch(this.minibatch_size);
                                fig = figure;
                            end
                            figure(fig);
                            % average scores
                            subplot(2,2,1);
                            avg_scores = [avg_scores mean(scores)];
                            scores = [];
                            plot(avg_scores);
                            title('Average game score');
                            % nr of games
                            subplot(2,2,2);
                            game_counts = [game_counts game_count];
                            game_count = 0;
                            plot(game_counts);
                            title('Number of games');
                            % network loss
                            subplot(2,2,3);
                            losses = [losses this.nnet.L];
                            plot(losses);
                            title('Network loss');
                            % avg max Q-value
                            subplot(2,2,4);
                            x = this.preprocess(q_states.prestates(:,:));
                            this.nnet.testing = 1;
                            this.nnet = nnff(this.nnet, x, zeros(size(x,1), this.nnet.size(end)));
                            this.nnet.testing = 0;
                            y = this.nnet.a{end};
                            q_values = [q_values mean(max(y, [], 2))];
                            plot(q_values);
                            title('Average Q-value');
                            drawnow;
                        end
                    end
                end
                disp([num2str(i) ' ' num2str(results(i)) ' ' num2str(this.compute_epsilon(this.mem.size)) ' ' num2str(this.mem.size) ' ' num2str(iteration)]);
                scores = [scores results(i)];
                game_count = game_count + 1;
            end
        end

        function e = compute_epsilon(this, iteration)
        % COMPUTE_EPSILON Compute exploration rate based on number of trainings.
        % Parameters:
        %  iteration - number of training passes done
        % Returns exploration rate, that decays until exploration_steps are achieved.
            e = max(1 - iteration / this.exploration_steps, this.exploration_rate);
        end
        
        function y = predict(this, a)
        % PREDICT Predict Q-values for state a.
        % Parameters:
        %  a - game state
        % Returns predicted Q-values.
            % flatten the matrix and turn into one-element minibatch
            x = this.preprocess(a(:)');
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
            x = this.preprocess(b.prestates(:,:));
            xx = this.preprocess(b.poststates(:,:));

            % predict Q-values of prestates
            this.nnet.testing = 1;
            this.nnet = nnff(this.nnet, x, zeros(size(x,1), this.nnet.size(end)));
            this.nnet.testing = 0;
            y = this.nnet.a{end};

            if this.discount_rate > 0
                % predict Q-values of poststates
                this.nnet.testing = 1;
                this.nnet = nnff(this.nnet, xx, zeros(size(xx,1), this.nnet.size(end)));
                this.nnet.testing = 0;
                yy = this.nnet.a{end};
                % maximum Q-value for each poststate
                yymax = max(yy, [], 2);
            end

            % calculate discounted future reward for each state transition in batch
            for i = 1:size(x,1)
                % preprocess reward the same way as input
                reward = this.preprocess(b.rewards(i));
                % only change one action, other Q-values stay the same
                if b.terminals(i) || this.discount_rate == 0
                    y(i, b.actions(i)) = reward;
                else
                    y(i, b.actions(i)) = reward + this.discount_rate * yymax(i);
                end
            end

            % train the network (copied from nntrain())
            this.nnet = nnff(this.nnet, x, y);
            this.nnet = nnbp(this.nnet);
            this.nnet = nnapplygrads(this.nnet);
        end
    end
    
end
