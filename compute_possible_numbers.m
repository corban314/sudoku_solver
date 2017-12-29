function [ possible_numbers_cell ] = compute_possible_numbers( current_matrix )
% For sudoku, finds all of the numbers that each particular square could be
% based on all the numbers that are currently known.
%
% Takes a matrix, returns a 9x9 cell array of vectors (NaNs for known
% numbers, vectors for unknown numbers).

%Initialize the possible numbers:
possible_numbers_cell = cell(9);
for i = 1:9
    for j = 1:9
        if isnan(current_matrix(i,j))
            possible_numbers_cell{i,j} = 1:9;
        else
            possible_numbers_cell{i,j} = nan(1);
        end
    end
end

% Iterate through all of the known numbers:
for i = 1:9
    for j = 1:9
        if ~isnan(current_matrix(i,j))
            % If this is a known number, then remove this number from ...
            this_number = current_matrix(i,j);
            % (1) The entire row
            for iterator = 1:9
                if ~isnan(possible_numbers_cell{iterator,j}) %Column is fixed for this.
                    possible_numbers_cell{iterator,j}(possible_numbers_cell{iterator,j} == this_number) = [];
                end
            end
            
            % (2) The entire column
            for iterator = 1:9
                if ~isnan(possible_numbers_cell{i,iterator}) %Row is fixed for this.
                    possible_numbers_cell{i,iterator}(possible_numbers_cell{i,iterator} == this_number) = [];
                end
            end
            
            % (3) The entire box          
            [ rowboxidx,colboxidx,rowidxs,colidxs ] = get_submatrix( i,j );
            for row_iter = rowidxs
                for col_iter = colidxs
                    if ~isnan(possible_numbers_cell{row_iter,col_iter})
                        possible_numbers_cell{row_iter,col_iter}(possible_numbers_cell{row_iter,col_iter} == this_number) = [];
                    end
                end
            end %Box deletion should be complete.
            
        end %If not a known number, don't remove anything
    end
end

end

