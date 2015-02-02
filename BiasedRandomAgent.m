classdef BiasedRandomAgent < handle
    %RandomAgent Plays 2048 with random moves.

    properties (Constant)
        rows = 4;
        cols = 4;
        actions = 4;
        action_labels = {'UP', 'RIGHT', 'DOWN', 'LEFT'};
    end

    properties
        game;
        biases;
    end
    
    methods
        function this = BiasedRandomAgent(biases)
            this.game = Game(this.rows, this.cols);
            this.biases = biases;
        end
        
        function results = play(this, nr_games)
        % PLAY Play 2048 game by making random moves.
        % Parameters:
        %  nr_games - number of games to play. If 1, then also displays debug info.
        % Returns scores in those games as a vector.
            
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
                    % choose random action
                    action = randsample(1:this.actions, 1, true, this.biases);
                    % make a move and observe reward
                    points = this.game.move(action);
                    results(i) = results(i) + points;
                    if (nr_games == 1)
                        disp(this.action_labels{action});
                        disp(this.game.state);
                    end
                end
            end
        end

    end
    
end

