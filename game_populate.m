function a = game_populate(a)
% GAME_POPULATE Populate empty cell with 2 or 4.
% Parameters:
%  a - game state
% Returns game state with one empty cell populated with 2 or 4.

    empty = find(a == 0);
    if (length(empty) > 0)
        % choose 2 with probability 0.9, otherwise 4
        if (unifrnd(0, 1) < 0.9)
            value = 2;
        else
            value = 4;
        end
        % choose one of the empty cells and assign value
        index = randi(length(empty));
        a(empty(index)) = value;
    end 
end
