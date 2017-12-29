function [ rowboxidx,colboxidx,rowidxs,colidxs ] = get_submatrix( i,j )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%Find first which logical box we are in:
rowboxidx = 0;
colboxidx = 0;
critvals = [1 4 7 10];
rowtestm = (i >= critvals);
for k = 1:4
    if rowtestm(k) == 0
        rowboxidx = k - 1;
        break; % the for loop, because we have found the row box idx.
    end
end
coltestm = (j >= critvals);
for k = 1:4
    if coltestm(k) == 0
        colboxidx = k - 1;
        break;
    end
end
% Now rowboxidx and colboxidx should contain the coordinates of
%   the block square that we are in.
% Next step is to define the range of the square:
startrow = (rowboxidx-1)*3+1;
endrow = startrow + 2;
startcol = (colboxidx-1)*3+1;
endcol = startcol + 2;

rowidxs = startrow:endrow;
colidxs = startcol:endcol;

end

