function fnames = getFiles(topLevelFolder)   
% pick folder(s)
    notThisFile = 'All cycles data.mat';
    fnames = {};
%     topLevelFolder = uigetdir();
    filePattern = sprintf('%s/**/Cycle_*.mat', topLevelFolder); % get only cycle files, ignore all others
    allFileInfo = dir(filePattern);
    listOfFolderNames = unique({allFileInfo.folder}); 
        % now we want to loop through these folders and get stuff
    counter = 1; 
    for i =1:length(listOfFolderNames)
        subfolderName = char(listOfFolderNames(i)); 
        filePattern = sprintf('%s/Cycle_*.mat', subfolderName);
        allFileInfo = dir(filePattern);
        listOfFileNames = {allFileInfo.name};

        % put them together into a full file
        for j = 1:length(listOfFileNames)
            if ~strcmp(char(listOfFileNames(j)),notThisFile)
                fnames(counter) = {fullfile(subfolderName, char(listOfFileNames(j)))}; 
                counter = counter +1; 
            elseif strcmp(char(listOfFileNames),notThisFile)
            end

        end

    end
end