function [ solution_matrix, exit_flag ] = get_first_order_solution( current_matrix,possible_numbers_cell )
%Pass the cell so that we can do a single round of second-order reduction
%in the driver when desired, and then get the first order solution after
%that point.
%
%   An exit flag of 0 is returned on successful solution.
%   An exit flag of 1 is returned when the first-order logic solver cannot
%       compute the solution.

global iteration_counter;
solved = 0;
terminate = 0;
last_iter_matrix = nan(9);
changed = 1;
% Do one matrix fill before recomputing possibilities, to make it easier to
% solve using only a single iteration of second-order logic.
if nargin == 2
    current_matrix = fill_by_implication( current_matrix,possible_numbers_cell ); %Note current matrix is updated here:
    current_matrix = fill_by_elimination( current_matrix,possible_numbers_cell );
end
% If only one argument is passed, then we just don't execute this initial
% step and compute the possibilities matrix as normal.
while ~solved && ~terminate
    iteration_counter = iteration_counter + 1;
    % Compute possibilities:
    possible_numbers_cell = compute_possible_numbers( current_matrix );
    % Check the two ways of filling in new values to find new values.
    current_matrix = fill_by_implication( current_matrix,possible_numbers_cell ); %Note current matrix is updated here:
    current_matrix = fill_by_elimination( current_matrix,possible_numbers_cell );
    
    % Does the matrix remain unchanged from the last iteration? If so, then
    % manual imitation logic has reached a deadlock. (First termination
    % condition)
    changed = 0;
    for i = 1:9
        for j = 1:9
            testval = (last_iter_matrix(i,j) == current_matrix(i,j));
            if ~testval && ~(isnan(last_iter_matrix(i,j)) && isnan(current_matrix(i,j)))
                changed = 1;
                break
            end
        end
    end
    if ~changed
        disp('First-order logic solver did not find a solution!')
        terminate = 1; % Kind of a misnomer; we're just terminating.
        solution_matrix = current_matrix;
    end
    
    % Has the whole matrix been filled in? If so, we should be done:
    % (Second termination condition)
    if (sum(sum(isnan(current_matrix))) == 0)
        disp('Solution purportedly found.');
        solution_matrix = current_matrix;
        solved = 1;
        %Check the solution
        disp('Checking purported solution:');
        try
            is_valid_sudoku_solution(solution_matrix);
            disp('Driver confirmation: A valid solution has been found.');
            disp('The solution is as follows:')
            disp(solution_matrix);
        catch
            disp('THe purported solution is not, in fact, a solution!');
            disp('The purported solution was as follows: ');
            disp(solution_matrix);
        end
    end
    last_iter_matrix = current_matrix;
end

% Set exit flag for use in driver or whatever else.
if terminate == 1
    exit_flag = 1;
elseif solved == 1
    exit_flag = 0;
else
    exit_flag = NaN(1);
end

end
