classdef GreedyAgent < handle
    %GreedyAgent Plays 2048 by picking move that results in most points.

    properties (Constant)
        rows = 4;
        cols = 4;
        actions = 4;
        action_labels = {'UP', 'RIGHT', 'DOWN', 'LEFT'};
    end

    properties
        game;
    end
    
    methods
        function this = GreedyAgent()
            this.game = Game(this.rows, this.cols);
        end
        
        function results = play(this, nr_games)
        % PLAY Play 2048 game by picking move that results in most points.
        % Parameters:
        %  nr_games - number of games to play. If 1, then also displays debug info.
        % Returns scores in those games as a vector.
            
            % play nr_games
            for i = 1:nr_games
                % initialize game field
                this.game.new();
                results(i) = 0;
                if (nr_games == 1)
                    disp(this.game.state);
                end
                % play till end
                while (~this.game.end())
                    best_points = -Inf;
                    best_action = -1;
                    best_game = this.game;
                    for action = 1:this.actions
                        % make copy of the game
                        gamecopy = this.game.copy();
                        % make a move and observe reward
                        [points, changed] = gamecopy.move(action);
                        if points > best_points & changed
                            best_points = points;
                            best_action = action;
                            best_game = gamecopy;
                        end
                    end
                    % continue from the game with the best reward
                    points = best_points;
                    action = best_action;
                    this.game = best_game;

                    results(i) = results(i) + points;
                    if (nr_games == 1)
                        disp(this.action_labels{action});
                        disp(this.game.state);
                    end
                end
                disp([i results(i)]);
            end
        end

    end
    
end

