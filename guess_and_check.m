function [ solution_cell,num_paths_at_or_beneath ] = guess_and_check( current_matrix,possible_numbers_cell )
% For all 2-possibility cells, recursively take each possible guess.
% If solved, then solution cell has the following format: {'solved'}
% If cannot solve and no more 2-cell guesses to take, or inconsistent
%   result, then solution cell is {'not_solved'} or {'inconsistent')
% If not, then we have taken guesses over all possibilities. We then have
% format: {[guess_taken,row,col,solution_cell]}, where the solution_cell is
% the solution for the recursed guess.

%% Check for a first-order solution as the base case of the recursion
solution_cell = cell(0);
try 
    [ solution_matrix, exit_flag ] = get_first_order_solution( current_matrix,possible_numbers_cell );
catch
    solution_cell = {'inconsistent'};
    num_paths_at_or_beneath = 1;
    return;
end

% If we think we have found a solution, check to see if it is consistent.
if exit_flag == 0
    try 
        is_valid_sudoku_solution( solution_matrix );
        solution_cell = {'solved'};
        num_paths_at_or_beneath = 1;
    catch
        solution_cell = {'inconsistent'};
        num_paths_at_or_beneath = 1;
    end
else
    %% Otherwise, take the guesses and recurse.
    % Count local number of guesses; if zero, then we have no more guesses on
    % 2-possibility cells and should return {'not_solved'}
    local_num_guesses_taken = 0;
    paths_accumulator = 0;
    for rownum = 1:9
        for colnum = 1:9
            this_possib = possible_numbers_cell{rownum,colnum};
            if (~isnan(this_possib(1))) && (length(this_possib) == 2)
                local_num_guesses_taken = local_num_guesses_taken + 2;
                %Take the first path:
                new_guess_possib_cells = possible_numbers_cell;
                new_guess_possib_cells{rownum,colnum}(2) = [];
                [ path1_solution_cell,path1_num_paths_at_or_beneath ] = guess_and_check( current_matrix,new_guess_possib_cells );
                solution_cell = [solution_cell,path1_solution_cell];
                %Take the second path:
                new_guess_possib_cells = possible_numbers_cell;
                new_guess_possib_cells{rownum,colnum}(1) = [];
                [ path2_solution_cell,path2_num_paths_at_or_beneath ] = guess_and_check( current_matrix,new_guess_possib_cells );
                solution_cell = [solution_cell,path2_solution_cell];

                % Accumulate number of paths taken from this cell and from
                % others.
                paths_accumulator = paths_accumulator + path1_num_paths_at_or_beneath + path2_num_paths_at_or_beneath;
            end
        end
    end
    
    if local_num_guesses_taken == 0
        solution_cell = {'not_solved'};
        num_paths_at_or_beneath = 1; %Because we took one guess to get here.
    else
        %solution_cell has already been populated.
        num_paths_at_or_beneath = paths_accumulator;
    end
end

end
