classdef Game < matlab.mixin.Copyable
    %GAME Implements 2048 game functions.
    
    properties
        rows;
        cols;
        state;
    end
    
    methods
        function this = Game(rows, cols)
            this.rows = rows;
            this.cols = cols;
        end
        
        function new(this)
        % NEW Initialize game field.
        % Returns game state as rows x cols matrix.

            % initialize game field to zeros and populate two cells
            this.state = zeros(this.rows, this.cols);
            this.populate();
            this.populate();
        end
        
        function populate(this)
        % POPULATE Populate empty cell with 2 or 4.
        % Returns game state with one empty cell populated with 2 or 4.

            empty = find(this.state == 0);
            if (length(empty) > 0)
                % choose 2 with probability 0.9, otherwise 4
                if (unifrnd(0, 1) < 0.9)
                    value = 2;
                else
                    value = 4;
                end
                % choose one of the empty cells and assign value
                index = randi(length(empty));
                this.state(empty(index)) = value;
            end 
        end

        function [points, changed] = move(this, direction)
        % MOVE Make move in the game and return reward.
        % Parameters:
        %  direction - direction of the move: 1 - up, 2 - right, 3 - down, 4 - left
        % Returns:
        %  points - observed reward
        %  changed - if game state changed as a result of this move

            % all shifts and merges are done towards left,
            % so we need to rotate matrix first for other directions:
            % 1 - shift up,
            % 2 - shift right,
            % 3 - shift down,
            % 4 - shift left.
            % we could have used 0 as left, but starting from 1 works better as index.
            a = rot90(this.state, direction);

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
            this.state = rot90(b, -direction);

            % generate 2 or 4 to empty place only if changed
            if (changed == 1)
                this.populate();
            end
        end

        function result = end(this)
        % END If this is final state of the game, you cannot make any moves.
        % Returns 1 if final state, 0 otherwise.
        % Definition of final state - all cells are filled out and there are no two
        % adjacent equal cells.

            a = this.state;
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

    end
    
end

