function [ solution_cell, paths_accumulator ] = guess_and_check_norecurse( current_matrix )
%Same functionality as guess_and_check, but just does without recurse.
possible_numbers_cell = compute_possible_numbers(current_matrix);
solution_cell = cell(0);
paths_accumulator = 0;
for rownum = 1:9
    for colnum = 1:9
        this_possib = possible_numbers_cell{rownum,colnum};
        if (~isnan(this_possib(1))) && (length(this_possib) == 2)
            %Take the first path:
            new_guess_possib_cells = possible_numbers_cell;
            new_guess_possib_cells{rownum,colnum}(2) = [];
            try
                [ ~, exit_flag ] = get_first_order_solution( current_matrix,new_guess_possib_cells );
                if exit_flag == 0
                    solution_cell = [solution_cell,{'solved'}];
                elseif exit_flag == 1
                    solution_cell = [solution_cell,{'unsolved'}];
                end
            catch
                solution_cell = [solution_cell,{'inconsistent'}];
            end
            %Take the second path:
            new_guess_possib_cells = possible_numbers_cell;
            new_guess_possib_cells{rownum,colnum}(1) = [];
            try
                [ ~, exit_flag ] = get_first_order_solution( current_matrix,new_guess_possib_cells );
                if exit_flag == 0
                    solution_cell = [solution_cell,{'solved'}];
                elseif exit_flag == 1
                    solution_cell = [solution_cell,{'unsolved'}];
                end
            catch
                solution_cell = [solution_cell,{'inconsistent'}];
            end
            % Accumulate number of paths taken from this cell and from
            % others.
            paths_accumulator = paths_accumulator + 2;
        end
    end
end

end

