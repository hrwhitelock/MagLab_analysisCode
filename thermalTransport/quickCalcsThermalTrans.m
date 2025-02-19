function out = quickCalcsThermalTrans(topLevelFolder, geometricFactor, hotFit, coldFit,bathFit)
    % enter fits as 0 to skip and use whatever fit is already loaded
    out = struct; 
    fnames = getCycleFiles(topLevelFolder); % ui, spits out cell array, use char

    for i = 1:length(fnames)
        data = load(char(fnames(i)));
        if isfield(data, 'field')
            out.field(i) = mean(data.field); 
        else
            out.field(i) = 0.0; 
        end
        % if hotFit ~= 0 && coldFit ~=0 && bathFit ~= 0
            data.hotTemp = hotFit(data.hotRes); % refitting temps if non zero fits entered
            data.coldTemp = coldFit(data.coldRes);
            data.bathTemp = bathFit(data.bathRes);
        % end

        % now we cook with gas
        wanted = data.logicalArray;
        hotTemp = mean(data.hotTemp(wanted)); 
        coldTemp = mean(data.coldTemp(wanted)); 
        % out.hotRes(i) = mean(data.hotRes(wanted)); 
        % out.coldRes(i) = mean(data.coldRes(wanted));
        % out.bathRes(i) = mean(data.bathRes(wanted)); 
        out.sampleTemp(i) = (hotTemp + coldTemp)/2; 
        dT = data.hotTemp(wanted) -data.coldTemp(wanted);
        out.probeTemp(i) = mean(data.ChanD(wanted)); 
        meanHotTemp = []; 
        meanColdTemp = []; 
        meanSampleTemp =[]; 
        meanHotRes = []; 
        meanColdRes = [];
        meanBathRes = []; 

        for j = 1:length(data.current)
            if data.current(j) == 0
                meanHotRes(end+1) = mean(data.hotRes(j)); 
                meanColdRes(end+1) = mean(data.coldRes(j));
                meanBathRes(end+1) = mean(data.bathRes(j)); 
                meanHotTemp(end+1) = data.hotTemp(j);
                meanColdTemp(end+1) = data.coldTemp(j); 
                meanSampleTemp(end+1) = (data.hotTemp(j)+data.coldTemp(j))/2;
            end
        end
        out.hotRes(i) = mean(meanHotRes);
        out.coldRes(i) = mean(meanColdRes);
        out.bathRes(i) = mean(meanBathRes);
        out.hotTemp(i) = mean(meanHotTemp);
        out.coldTemp(i) = mean(meanColdTemp);
        out.sampleTemp(i) = mean(meanSampleTemp);

        if length(data.Time)>150 % skips files that we aborted super early
            
            out.bathTemp(i) = mean(data.bathTemp); 
            
            % now we do dt/Isq
            curr = data.current(wanted); 
            voltage = data.heaterVoltage(wanted); 
            out.current(i) = max(curr); 
            out.voltage(i) = max(voltage); 
            currFit = polyfit(curr.*voltage, dT, 1); 
            currSlope = currFit(1);
            out.dToffset(i) = currFit(2); 
            out.dTIV(i) = currSlope; % com
            out.conductance(i) = 1/currSlope; 
            out.conductivity(i) = (1/currSlope)*geometricFactor; 

            % just get dt
            dTFit = polyfit(data.Time(wanted), dT, 1);
            dTslope = dTFit(1); 
            out.dTfitted(i) = dTslope; 

            out.time(i) = mean(data.Time); 
            out.raw(i) = data; 
        end
    end
end