function [b, points, changed] = game_move(a, direction)
% GAME_MOVE Make move in the game and return reward.
% Parameters:
%  a - game state
%  direction - direction of the move: 1 - up, 2 - right, 3 - down, 4 - left
% Returns:
%  b - game state after making the move
%  points - observed reward
%  changed - if game state changed as a result of this move

    % all shifts and merges are done towards left,
    % so we need to rotate matrix first for other directions:
    % 1 - shift up,
    % 2 - shift right,
    % 3 - shift down,
    % 4 - shift left.
    % we could have used 0 as left, but starting from 1 works better as index.
    a = rot90(a, direction);

    % perform shifts and merges. a is the original matrix, b is the new matrix.
    b = zeros(size(a));
    points = 0;
    changed = 0;
    for row = (1:size(a, 1))
        % i is the leftmost cell in b, that we are going to populate
        i = 1;
        % j is the current cell in a, that we are going to shift or merge
        for j = (1:size(a, 2))
            if (a(row, j) ~= 0)
                if (b(row, i) == a(row, j))
                    b(row, i) = b(row, i) + a(row, j);
                    points = points + b(row, i);
                    i = i + 1;
                    changed = 1;
                else
                    if (b(row, i) ~= 0)
                        i = i + 1;
                    end
                    b(row, i) = a(row, j);
                    if (i ~= j)
                        changed = 1;
                    end
                end
            end
        end
    end

    % restore original direction
    b = rot90(b, -direction);

    % generate 2 or 4 to empty place only if changed
    if (changed == 1)
        b = game_populate(b);
    end
end