function out = quickCalcsStopgo(topLevelFolder)
    out = struct; 
    fnames = getFiles(topLevelFolder); % ui, spits out cell array, use char
    counter = 1; 
    for i = 1:length(fnames)
        data = load(char(fnames(i)));
        if isfield(data, 'field')
            out.field(i) = mean(data.field); 
        else
            out.field(i) = 0.0; 
        end
        % now we cook with gas bitches
        wanted = data.logicalArray;
        dT = data.hotTemp(wanted) -data.coldTemp(wanted);

        % now we do dt/Isq
        curr = data.current(wanted); 
        v = data.heaterVoltage(wanted);
        currFit = polyfit(curr.*v, dT, 1); 
        currSlope = currFit(1);
        out.dTIV(i) = currSlope;
        out.conductance(i) = 1/currSlope; 
        out.temp(i) = mean(data.bathTemp);
        out.time(i) = mean(data.Time); 
        out.raw(i) = data; 
        valid = wanted & (data.current ~= 0);   % keep only points where current ≠ 0
        out.heaterRes(i) = mean(data.heaterVoltage(valid) ./ data.current(valid));
    end
end