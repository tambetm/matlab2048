function results = agent_random(nr_games)
% AGENT_RANDOM Play 2048 game by making random moves.
% Parameters:
%  nr_games - number of games to play. If 1, then also displays debug info.
% Returns scores in those games as a vector.

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
            % choose random action
            action = randi(4);
            % make a move and observe reward
            [a, points] = game_move(a, action);
            results(i) = results(i) + points;
            if (nr_games == 1)
                action_labels = {'UP', 'RIGHT', 'DOWN', 'LEFT'};
                disp(action_labels{action});
                disp(a);
            end
        end
    end
end
