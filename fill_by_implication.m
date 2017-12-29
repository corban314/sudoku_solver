function [ new_matrix ] = fill_by_implication( current_matrix,possible_numbers )
% Fills in numbers by direct implication; i.e., if a row, column, or
% sub-box only has one possible location for a number, place it there.
reference_list = 1:9;
new_matrix = current_matrix;
% (1) Test rows:
for rownum = 1:9
    numlist = current_matrix(rownum,:);
    currentvals = numlist;
    currentvals(isnan(currentvals)) = [];
    neededvals = reference_list;
    for i = 1:length(currentvals)
        neededvals(neededvals == currentvals(i)) = [];
    end %Now we have all of the needed values.
    
    %Now test to see if there is only one rowval with any of the needed
    %values:
    for needed = neededvals
        count = 0;
        idxstore = [];
        for j = 1:9
            
            
            if sum(possible_numbers{rownum,j} == needed)
                count = count + 1;
                idxstore = [idxstore,j];
            end
        end %Now if we come out of this loop and there is only one index
        %that will work, it must be the one, and we can replace it.
        if count == 1
            new_matrix(rownum,idxstore) = needed; %This must be the needed value.
            %Note that idxstore will have only one value at this point.
        elseif count == 0
            error('Needed val had no possibilities!');
        end
    end
end

% (2) Test cols:
for colnum = 1:9
    numlist = current_matrix(:,colnum);
    currentvals = numlist;
    currentvals(isnan(currentvals)) = [];
    neededvals = reference_list;
    for i = 1:length(currentvals)
        neededvals(neededvals == currentvals(i)) = []; %I.e., delete all the values
        %we currently have to get the ones that we need.
    end %Now we have all of the needed values.
    
    %Now test to see if there is only one rowval with any of the needed
    %values:
    for needed = neededvals
        count = 0;
        idxstore = [];
        for j = 1:9
            
            
            if sum(possible_numbers{j,colnum} == needed)
                count = count + 1;
                idxstore = [idxstore,j];
            end
        end %Now if we come out of this loop and there is only one index
        %that will work, it must be the one, and we can replace it.
        if count == 1
            new_matrix(idxstore,colnum) = needed; %This must be the needed value.
            %Note that idxstore will have only one value at this point.
        elseif count == 0
            error('Needed val had no possibilities!');
        end
    end
end

% (3) Test sub-matrices: (and use upper left corner to compute the row and col idxs)
for i = [1 4 7]
    for j = [1 4 7]
        [ rowboxidx,colboxidx,rowidxs,colidxs ] = get_submatrix( i,j );
        submatrix = new_matrix(rowidxs,colidxs);
        numlist = reshape(submatrix,9,1); %lay out as vector.
        %After reshape, the logic should be similar, just the traversal
        %different.
        currentvals = numlist;
        currentvals(isnan(currentvals)) = [];
        neededvals = reference_list;
        for k = 1:length(currentvals)
            neededvals(neededvals == currentvals(k)) = []; %I.e., delete all the values
            %we currently have to get the ones that we need.
        end %Now we have all of the needed values in the submatrix.
        
        %Now test to see if we have only one possibility left in the box:
        for needed = neededvals
            count = 0;
            rowidxstore = [];
            colidxstore = [];
            for subrow = rowidxs
                for subcol = colidxs
                    if sum(possible_numbers{subrow,subcol} == needed)
                        count = count + 1;
                        rowidxstore = [rowidxstore,subrow];
                        colidxstore = [colidxstore,subcol];
                    end
                end
            end %Now if we come out of this loop and there is only one index
            %that will work, it must be the one, and we can replace it.
            if count == 1
                new_matrix(rowidxstore,colidxstore) = needed; %This must be the needed value.
                %Note that idxstore will have only one value at this point.
            elseif count == 0
                error('Needed val had no possibilities!');
            end
        end
    end
end

end

