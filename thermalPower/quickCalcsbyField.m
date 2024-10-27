function calcOut = quickCalcsbyField(topLevelFolder)
    fnames = getFiles(topLevelFolder); % ui, spits out cell array, use char
    calcOut.init = 1;
    counter = 1; 
    for i = 1:length(fnames)
        data = load(char(fnames(i)));
        if isfield(data, 'field')
            out.field(i) = mean(data.field); 
        else
            out.field(i) = 0.0; 
        end

        out.temp(i) = mean(data.bathTemp); 

        data = load(char(fnames(i))); 
        % now we cook with gas bitches
        wanted = data.logicalArray;
        dT = data.hotTemp(wanted) -data.coldTemp(wanted);
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
        
        out.temp(i) = mean(data.bathTemp);
        if out.field(i)>=0
            my_field = strcat('field',num2str(abs(round(out.field(i)))));
        else
            my_field = strcat('fieldneg',num2str(abs(round(out.field(i)))));
        end
        if isfield(calcOut, (my_field))
            counter = counter +1; 
        end
        calcOut.(my_field)(counter) = out;
        calcOut.(my_field)(counter.raw = data; 
        
    end

end