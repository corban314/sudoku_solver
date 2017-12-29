function is_valid_tester()
%Testing function for is_valid_sudoku_solution.m

valid_matrix = [5 3 4 6 7 8 9 1 2;
                6 7 2 1 9 5 3 4 8;
                1 9 8 3 4 2 5 6 7;
                8 5 9 7 6 1 4 2 3;
                4 2 6 8 5 3 7 9 1;
                7 1 3 9 2 4 8 5 6;
                9 6 1 5 3 7 2 8 4;
                2 8 7 4 1 9 6 3 5;
                3 4 5 2 8 6 1 7 9];
            
non_valid_matrix = [5 3 4 6 7 8 9 1 2;
                6 7 2 1 9 5 3 4 8;
                1 9 8 3 4 2 5 6 7;
                8 5 9 7 6 1 4 2 3;
                4 2 6 8 5 3 7 9 1;
                7 1 3 9 2 4 8 5 6;
                9 6 1 5 3 7 2 8 4;
                2 8 7 4 1 9 4 3 5;
                3 4 5 2 8 6 1 7 9];
            
jenna_matrix = [1 8 5 7 6 2 4 3 9;
                6 4 9 3 8 1 5 7 2;
                2 7 3 4 9 5 6 8 1;
                8 5 4 1 2 9 7 6 3;
                7 9 1 6 5 3 8 2 4;
                3 2 6 8 7 4 1 9 5;
                4 6 2 9 1 8 3 5 7;
                5 3 7 2 4 6 9 1 8;
                9 1 8 5 3 7 2 4 6];

udsoln = [4 8 5 7 6 2 3 1 9;
6 9 3 1 8 4 5 7 2;
2 7 1 3 9 5 6 8 4;
1 5 4 NaN 2 NaN 7 6 3;
7 3 9 6 5 1 8 2 4;
8 2 6 4 7 3 1 9 5;
3 6 2 NaN 1 NaN 4 5 7;
5 1 7 2 4 6 9 3 8;
9 4 8 5 3 7 2 1 6];

disp('Beginning sudoku solution tests!');
logical_solution1 = is_valid_sudoku_solution( valid_matrix );
assert(logical_solution1 == 1);
disp('Passed valid test!');
logical_solution1 = is_valid_sudoku_solution( jenna_matrix );
assert(logical_solution1 == 1);
disp('Jenna Passed test!');
try 
    is_valid_sudoku_solution( non_valid_matrix );
    disp('Failed non-valid test!');
catch
    disp('Passed non-valid test!');
end

try 
    is_valid_sudoku_solution( udsoln );
    disp('Failed non-valid Uncle Dale test!');
catch
    disp('Passed non-valid Uncle Dale test!');
end

end

