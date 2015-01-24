function result = game_end(a)
% GAME_END If this is final state of the game, you cannot make any moves.
% Parameters:
%  a - game state
% Returns 1 if final state, 0 otherwise.
% Definition of final state - all cells are filled out and there are no two
% adjacent equal cells.

    % if all cells are filled out (no zeros)
    if (all(a))
        for i = (1:size(a, 1))
            for j = (1:size(a, 2))
                % if vertically adjacent cells are equal - possible move
                if (i > 1 && a(i,j) == a(i - 1, j))
                    result = 0;
                    return;
                end
                % if horizontally adjacent cells are equal - possible move
                if (j > 1 && a(i,j) == a(i, j - 1))
                    result = 0;
                    return;
                end
            end
        end
        % no possible moves
        result = 1;
    else
        % empty cells - there are possible moves
        result = 0;
    end
end

