% compute_guess_probability.m
%
%   Script for finding the probability of solving Grandma's Sudoku puzzle
%   via random selection of a number in one of the 2-possibility steps at
%   iteration 7.

%% Initialize Grandma's puzzle:
init_matrix = NaN(9);
load('Grandmas_initial_matrix.mat'); %populates init_matrix with the start position.

%% Find the position where first-order solver gets stuck
[ current_matrix, exit_flag ] = get_first_order_solution( init_matrix ); %No second argument passed.

%% Iterate through the current possibilities, and take a guess for each branch of a 2-square
%   Record if the result is 1st-order solvable. Recurse if not.
[ possible_numbers_cell ] = compute_possible_numbers( current_matrix );
[ solution_cell,num_paths_at_or_beneath ] = guess_and_check( current_matrix,possible_numbers_cell );

[ norecurse_solution_cell, paths_accumulator ] = guess_and_check_norecurse( current_matrix );

%% Tally the results.
% num_paths_at_or_beneath
solution_cell;
assert( num_paths_at_or_beneath == length(solution_cell) );
inconsistent_count = 0;
solved_count = 0;
unsolved_count = 0;
for i = 1:num_paths_at_or_beneath
    if strcmp(solution_cell{i},'solved')
        solved_count = solved_count + 1;
    elseif strcmp(solution_cell{i},'unsolved')
        unsolved_count = unsolved_count + 1;
    elseif strcmp(solution_cell{i},'inconsistent')
        inconsistent_count = inconsistent_count + 1;
    else
        error('Ending program; cell result is not recognized!');
    end
end
solved_prob = solved_count/num_paths_at_or_beneath * 100;
unsolved_prob = unsolved_count/num_paths_at_or_beneath * 100;
inconsistent_prob = inconsistent_count/num_paths_at_or_beneath * 100;

fprintf('A total of %d guess results have been found.\n',num_paths_at_or_beneath);
fprintf('%d of %d guess results found a solution (solved), for a %f%% percentage.\n',solved_count,num_paths_at_or_beneath,solved_prob);
fprintf('%d of %d guess results did not find a solution (unsolved), for a %f%% percentage.\n',unsolved_count,num_paths_at_or_beneath,unsolved_prob);
fprintf('%d of %d guess results did not find a solution (inconsistent), for a %f%% percentage.\n',inconsistent_count,num_paths_at_or_beneath,inconsistent_prob);

norecurse_solution_cell
paths_accumulator