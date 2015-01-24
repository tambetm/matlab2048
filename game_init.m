function a = game_init(rows, cols)
% GAME_INIT Initialize game field.
% Parameters:
%  rows - number of rows
%  cols - number of columns
% Returns game state as rows x cols matrix.

    % initialize game field to zeros and populate two cells
    a = game_populate(game_populate(zeros(rows, cols)));
end

