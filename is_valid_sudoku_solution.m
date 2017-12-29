function [ logical_solution ] = is_valid_sudoku_solution( solution_matrix )
%Checks to make sure that the purported sudoku solution follows all of the
%rules of sudoku:
logical_solution = 0;

% Check for rows:
for rownum = 1:9
    for thisnumber = 1:9
        numberofvals = sum(solution_matrix(rownum,:) == thisnumber);
        assert(numberofvals == 1); %Otherwise, a rule has been violated
        % i.e., two of a number or zero of a number.
    end
end

% Check for columns:
for colnum = 1:9
    for thisnumber = 1:9
        numberofvals = sum(solution_matrix(:,colnum) == thisnumber);
        assert(numberofvals == 1); %Otherwise, a rule has been violated
        % i.e., two of a number or zero of a number.
    end
end

% Check for squares:
%for squarerownum = 1:3
 %   for squarecolnum = 1:3
for squarerownum = [1 4 7]
    for squarecolnum = [1 4 7]
        %thissquare = solution_matrix(((squarerownum-1)*3+1):((squarerownum)*3+1),((squarecolnum-1)*3):((squarecolnum)*3));
        thissquare = solution_matrix(squarerownum:(squarerownum+2),squarecolnum:(squarecolnum+2));
        %thissquare
        for thisnumber = 1:9
            numberofvals = sum(sum(thissquare == thisnumber));
            assert(numberofvals == 1); %Otherwise, a rule has been violated
            % i.e., two of a number or zero of a number.
        end
    end
end

disp('This is a valid sudoku solution!')
logical_solution = 1;

end

