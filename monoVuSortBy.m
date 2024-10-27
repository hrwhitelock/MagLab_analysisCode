function dataOut = monoVuSortBy(sortBy, tol, datatol)
%hope sept 2024
% this was written by hope 
% sorry
% also not sorry im the best at coding and never write spaghetti ive never
% done anything wrong in my life
    varname=sortBy; 
     % init the struct so matlab doesn't get confused
    [baseName, folder] = uigetfile();
    fname = fullfile(folder, baseName); % too lazy to type filenames
    
    data = table2struct(readtable(fname), "ToScalar", true); 
    fields = fieldnames(data); % this gets all the fields in our data for later
    dataOut = struct;
    % so now we sort bitches
    % want a rate of change less than tolerance 
    rate = gradient(data.(sortBy)); 
    
    
    for i = 1:length(data.(sortBy))
        if abs(rate(i))<tol (data.(sortBy)(i) - movemean(data.(sortBy), 50)(i))<datatol
            myField = strcat(varname,'_', num2str(abs(round(data.(sortBy)(i))))); 
            myField = regexprep(myField, '-', 'neg'); 
            if isfield(dataOut, myField)
                for j = 1:numel(fields)
                    aField = fields{j}; 
                    dataOut.(myField).(aField)(end+1) = data.(aField)(i); 
                end
            else
                dataOut.(myField) = struct; 
                for j = 1:numel(fields)
                    aField = fields{j}; 
%                     dataOut.(myField).aField = [];
                    dataOut.(myField).(aField)(1) = data.(aField)(i); 
                end
            end
        elseif (data.(sortBy)(i) - movemean(data.(sortBy), 50)(i))<datatol % rolling average
            if abs(data.(sortBy)(i)-mean(data.(sortBy)(i-50:i+50)))<datatol
                myField = strcat(varname,'_', num2str(abs(round(data.(sortBy)(i))))); 
                myField = regexprep(myField, '-', 'neg'); 
                if isfield(dataOut, myField)
                    for j = 1:numel(fields)
                        aField = fields{j}; 
                        dataOut.(myField).(aField)(end+1) = data.(aField)(i); 
                    end
                else
                    dataOut.(myField) = struct; 
                    for j = 1:numel(fields)
                        aField = fields{j}; 
    %                     dataOut.(myField).aField = [];
                        dataOut.(myField).(aField)(1) = data.(aField)(i); 
                    end
                end
            end
        end
    end
end
