function [ possible_numbers_cell ] = second_order_reduction( possible_numbers_cell )
% Implementation of so-called "second-order" rules for reducing the number
% of possibilities for some cells.
%
% Looks for cells with only two possibilities, then sees if there are other
% cells with only two possibilities on either the same row, column, or
% submatrix. If so, the two possibilities can be eliminated from all other
% cells along the dimension on which they align. This allows potentially
% unique progress in the elimination and implication stages of finding new
% numbers.

% The simplest implementation is to iterate over all rows and columns
% looking for these things; there may be more efficient ways of doing it:
global second_order_use_count;
global second_order_use_location;
global iteration_counter;
val1 = 0;
val2 = 0;
for i = 1:9
    for j = 1:9
        this_possib = possible_numbers_cell{i,j};
        if (~isnan(this_possib(1))) && (length(this_possib) == 2)
            %Then we have found a candidate. Look for "same dimension"
            %pairs:
            
            % (1) Look in other rows, fixed column:
            rowvals = 1:9;
            rowvals(rowvals == i) = [];
            for rowidx = rowvals
                second_possib = possible_numbers_cell{rowidx,j};
                if (~isnan(second_possib(1))) && (length(second_possib) == 2) &&  (sum(second_possib == this_possib) == 2)
                    %The last condition assures complete equality since we
                    %are working with the size 2 combinations.
                    val1 = this_possib(1);
                    val2 = this_possib(2);
                    clean_rowvals = rowvals;
                    clean_rowvals(clean_rowvals == rowidx) = [];
                    for clean_rowval = clean_rowvals
                        %clean out the possibility entries for all other
                        %entries on that column:
                        if sum(possible_numbers_cell{clean_rowval,j} == val1)
                            second_order_use_count = second_order_use_count + 1;
                            second_order_use_location = vertcat(second_order_use_location,[iteration_counter,clean_rowval,j,val1]);
                        end
                        if sum(possible_numbers_cell{clean_rowval,j} == val2)
                            second_order_use_count = second_order_use_count + 1;
                            second_order_use_location = vertcat(second_order_use_location,[iteration_counter,clean_rowval,j,val2]);
                        end
                        possible_numbers_cell{clean_rowval,j}(possible_numbers_cell{clean_rowval,j} == val1) = [];
                        possible_numbers_cell{clean_rowval,j}(possible_numbers_cell{clean_rowval,j} == val2) = [];
                        
                    end
                end
            end
            
            % (2) Look in other columns, fixed row:
            colvals = 1:9;
            colvals(colvals == j) = [];
            for colidx = colvals
                second_possib = possible_numbers_cell{i,colidx};
                if (~isnan(second_possib(1))) && (length(second_possib) == 2) &&  (sum(second_possib == this_possib) == 2)
                    %The last condition assures complete equality since we
                    %are working with the size 2 combinations.
                    val1 = this_possib(1);
                    val2 = this_possib(2);
                    clean_colvals = colvals;
                    clean_colvals(clean_colvals == colidx) = [];
                    for clean_colval = clean_colvals
                        %clean out the possibility entries for all other
                        %entries on that row:
                        if sum(possible_numbers_cell{i,clean_colval} == val1)
                            second_order_use_count = second_order_use_count + 1;
                            second_order_use_location = vertcat(second_order_use_location,[iteration_counter,i,clean_colval,val1]);
                        end
                        if sum(possible_numbers_cell{i,clean_colval} == val2)
                            second_order_use_count = second_order_use_count + 1;
                            second_order_use_location = vertcat(second_order_use_location,[iteration_counter,i,clean_colval,val2]);
                        end
                        possible_numbers_cell{i,clean_colval}(possible_numbers_cell{i,clean_colval} == val1) = [];
                        possible_numbers_cell{i,clean_colval}(possible_numbers_cell{i,clean_colval} == val2) = [];
                        
                    end
                end
            end
            
            % (3) Look in submatrix:
            [ rowboxidx,colboxidx,rowidxs,colidxs ] = get_submatrix( i,j );
            for subi = rowidxs
                for subj = colidxs
                    second_possib = possible_numbers_cell{subi,subj};
                    if (~isnan(second_possib(1))) && (length(second_possib) == 2) && (sum(second_possib == this_possib) == 2) && ~((subi == i) && (subj == j))
                        %The second-to-last condition assures complete equality since we
                        %are working with the size 2 combinations.
                        %The last condition assures that we aren't marking
                        %ourself as a contiguous match; there's not an easy
                        %way to delete ourself from the iteration indices
                        %here.
                        val1 = this_possib(1);
                        val2 = this_possib(2);
                        for clean_colval = colidxs
                            for clean_rowval = rowidxs
                                %clean out the possibility entries for all other
                                %entries on that submatric, after checking
                                %to make sure we aren't deleting ourselves.
                                if sum(possible_numbers_cell{clean_rowval,clean_colval} == val1)
                                    second_order_use_count = second_order_use_count + 1;
                                    second_order_use_location = vertcat(second_order_use_location,[iteration_counter,clean_rowval,clean_colval,val1]);
                                end
                                if sum(possible_numbers_cell{clean_rowval,clean_colval} == val2)
                                    second_order_use_count = second_order_use_count + 1;
                                    second_order_use_location = vertcat(second_order_use_location,[iteration_counter,clean_rowval,clean_colval,val2]);
                                end
                                if ~((clean_colval == j) && (clean_rowval == i)) && ~((clean_colval == subj) && (clean_rowval == subi))
                                    possible_numbers_cell{clean_rowval,clean_colval}(possible_numbers_cell{clean_rowval,clean_colval} == val1) = [];
                                    possible_numbers_cell{clean_rowval,clean_colval}(possible_numbers_cell{clean_rowval,clean_colval} == val2) = [];
                                    
                                end
                            end
                        end
                    end
                end
            end
        end %the logical if, that we have found a 2 possibility site.
    end
end

end
