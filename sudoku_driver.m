%sudoku_driver.m
global second_order_use_count;
global second_order_use_location;
global iteration_counter;
second_order_use_location = zeros(0,4); %[iteration, row,col,eliminated value]
second_order_use_count = 0;
iteration_counter = 0;

%% Initialize the Sudoku puzzle:
flag = input('Do you want to use the preset Grandma sudoku puzzle (1), the simple Sudoku (2), the level 1 from Grandma (3), or enter your own? (0): ');
if flag == 0
    init_matrix = nan(9);
    user_terminate = 0;
    disp('The current starting matrix is as follows:');
    disp(init_matrix);
    while ~user_terminate
        row_coord = input('Please enter the row coordinate of a known number: ');
        col_coord = input('Please enter the column coordinate of the known number: ');
        value = input('Please enter the value of the known number: ');
        init_matrix(row_coord,col_coord) = value;
        disp('The current starting matrix is as follows:');
        disp(init_matrix);
        user_terminate = input('To continue enter values, enter 0; to finish entering the initial matrix, enter 1: ');
    end
elseif flag == 1
    disp('Loading Grandmas Sudoku puzzle (not solvable by first-order logic alone!)');
    load('Grandmas_initial_matrix.mat');
elseif flag == 2
    disp('Loading a simple Sudoku puzzle (solvable by first-order logic)');
    load('Simple_sudoku.mat');
elseif flag == 3
    disp('Loading a level1 Sudoku puzzle (solvable by first-order logic)');
    load('level1.mat');
elseif flag == 4
    disp('Loading level 5!');
    load('level5.mat');
else
    error('Please enter a valid starting choice!');
end
init_matrix
invariant_starting_matrix = init_matrix;

%% Manual Imitation Logic for solving the Sudoku:
disp('Beginning to compute Sudoku solution via manual rules: ');
tic
solved = 0;
current_matrix = init_matrix;
last_iter_matrix = nan(9);
possible_numbers_cell = cell(9);
changed = 1;
while ~solved
    
    iteration_counter = iteration_counter + 1
    % Compute possibilities:
    possible_numbers_cell = compute_possible_numbers( current_matrix );
    % Apply "second-order" logic:
%     if ~changed
%         possible_numbers_cell = second_order_reduction( possible_numbers_cell );
%     end
    possible_numbers_cell = second_order_reduction( possible_numbers_cell );
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
        disp('Solution cannot be computed with manual logic.')
        solved = 1; % Kind of a misnomer; we're just terminating.
    end
    
    % Has the whole matrix been filled in? If so, we should be done:
    % (Second termination condition)
    if (sum(sum(isnan(current_matrix))) == 0)
        disp('Solution purportedly found.');
        solution_matrix = current_matrix;
        solved = 1;

    end

    last_iter_matrix = current_matrix;
end
solution_matrix = current_matrix;

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
totaltime = toc;
fprintf('The total computation time was %f seconds.\n',totaltime);
fprintf('Second-order rules were used %d times.\n\n',second_order_use_count);
% fprintf('The second-order rule log is displayed below, with format [iteration,row,col,valremoved]:\n');
% disp(second_order_use_location);

