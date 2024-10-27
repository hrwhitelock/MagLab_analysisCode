function out = quickCalcs(topLevelFolder)
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
        if length(data.Time)>150 
            out.temp(i) = mean(data.bathTemp); 
            idx = [1:70 length(data.Time)-70:length(data.Time)];
            time = data.Time(idx); 
            tep = data.TEP(idx); 
            % do fit
            fit = polyfit(time, tep, 2); 
            newTEP = data.TEP - polyval(fit, data.Time); 

            dV = newTEP(wanted); 
            dVFit = polyfit(dT, dV, 1); 
            slope = dVFit(1); 
            out.dVTEP(i) = slope; 

            index = (data.current(wanted)./data.current(wanted)); 
            % now we want to do nernst, so same thing
            % no fit because :(
            dVnernst = data.nernst(wanted); 
            dVnernstFit = polyfit(dT, dVnernst, 1); 
            slope = dVnernstFit(1);
            out.dVnernst(i) = slope; 

            % now we do dt/Isq
            curr = data.current(wanted); 
            currFit = polyfit(curr.*curr, dT, 1); 
            currSlope = currFit(1);
            out.dTIsquared(i) = currSlope;

            % just get dt
            dTFit = polyfit(data.Time(wanted), dT, 1);
            dTslope = dTFit(1); 
            out.dTfitted(i) = dTslope; 

            out.temp(i) = mean(data.bathTemp);
            out.time(i) = mean(data.Time); 
            out.raw = data; 
        end
    end
end