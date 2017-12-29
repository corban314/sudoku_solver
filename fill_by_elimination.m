function [ new_matrix ] = fill_by_elimination( current_matrix,possible_numbers )
% Fills in numbers by elimination; that is, if a square can only be one
% number, then place that number there.
new_matrix = current_matrix;
for i = 1:9
    for j = 1:9
        if (isnan(new_matrix(i,j)) && (length(possible_numbers{i,j}) == 1))
            % Two conditions: unknown number and only one possibility 
            new_matrix(i,j) = possible_numbers{i,j}; % B/c only one possibility.
        end
    end
end %Finished iterating through all of the possible values.

end
