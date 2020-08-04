% This function returns the indices of the cell array where the contents match the
% target value.

function indicesArray = returnIndices(cellArray, targetValue)

    % Declare the array
    indicesArray = [];

    % If we are looking for a character array
    if(ischar(targetValue))

        % Go through all the cells in the cell array
        for i = 1:length(cellArray)

            % If it is the value that we are looking for, then push the index into
            % the array
            if(strcmp(cellArray{i}, targetValue))
                indicesArray(length(indicesArray)+1,1) = i;
            end

        end % End of for loop

    % Else if it is numeric
    elseif(isnumeric(targetValue))
        
        indicesArray = find(cellArray == targetValue);

    end% End of outer if

end % End of function





