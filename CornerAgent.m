classdef CornerAgent < handle
    %CornerAgent Plays 2048 by alternating between two main moves.

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
        function this = CornerAgent()
            this.game = Game(this.rows, this.cols);
        end
        
        function results = play(this, nr_games)
        % PLAY Play 2048 game by alternating between two main moves.
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
                % initially there is no previous action
                action = 0;
                % play till end
                while (~this.game.end())
                    % alternate between two sequences
                    if action == 1
                        moves = [2 1 4 3];
                    else
                        moves = [1 2 3 4];
                    end

                    for action = moves
                        % make a move and observe reward
                        [points, changed] = this.game.move(action);
                        if changed
                            break
                        end
                    end

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

