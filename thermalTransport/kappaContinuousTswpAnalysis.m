%% kappa continuous Tswp analysis
function dataOut = kappaContinuousTswpAnalysis(geometricFactor, hotFit, coldFit,bathFit)
%     data = load(fname); 
    [baseName, folder] = uigetfile();
    fname = fullfile(folder, baseName); 
    data = load(fname); 
    dataOut = struct; 
    % first get on vs off
    data.current = data.current*1e-3; %% saved in mA for some fkn reason
    curr = data.current;   %% saved in mA for some fkn reason
    one = zeros(1,length(curr));
    two = zeros(1, length(curr));
    off = zeros(1,length(curr)); 
    allGood = zeros(1,length(curr));
    % adjust the temperature conversion
    % figure out a way to change this :(
    data.hotTemp = hotFit(data.hotRes).'; % refitting temps if non zero fits entered
    data.coldTemp = coldFit(data.coldRes).';
    data.bathTemp = bathFit(data.bathRes).';


    df = gradient(curr);
    oneidx =[]; 
    twoidx =[]; 
    offidx =[]; 
    offidx(1) = 1; 
    for i = 2:length(df)-1
        if df(i)<0 && df(i-1) ==0
            offidx(end+1) = i; 
        elseif df(i) > 0 && curr(i-1) == 0 && df(i-1) ==0
            oneidx(end+1) = i; 
        elseif df(i)>0 && curr(i-1) ~=0 && df(i-1) ==0
            twoidx(end+1) = i; 
        end
    end
    data.rawdT = data.hotTemp-data.coldTemp;
    data.power = data.current .* data.heaterVoltage; 
    data.sampleTemp = (data.hotTemp+data.coldTemp)*1/2;
%     dataOut.rawdT = data.dT; 

    % let's bg subtract and then take the average of each of these point
    for j= 1:length(offidx)-2 
        skipPtsOff = round((oneidx(j) - offidx(j))/2); 
        skipPtsOne = round((twoidx(j) - oneidx(j))/2);
        skipPtsTwo = round((offidx(j+1) - twoidx(j))/2);
%         disp(skipPts)
        if skipPtsOff < 0
            disp('oh nooooo')
        end
%         disp(skipPts)
%         disp([num2str(onidx(j)), 'off: ', num2str(offidx(j))])

        off(offidx(j)+skipPtsOff:oneidx(j)) = 1; 
        allGood(offidx(j)+skipPtsOff:oneidx(j)) = 1;
        % bgdT = horzcat(data.rawdT(offidx(j)+skipPtsOff:oneidx(j)),data.rawdT(offidx(j+1)+skipPtsOff:oneidx(j+1))); 
        bgHot = horzcat(data.hotTemp(offidx(j)+skipPtsOff:oneidx(j)),data.hotTemp(offidx(j+1)+skipPtsOff:oneidx(j+1)));
        bgCold = horzcat(data.coldTemp(offidx(j)+skipPtsOff:oneidx(j)),data.coldTemp(offidx(j+1)+skipPtsOff:oneidx(j+1)));

        temp = horzcat(data.bathTemp(offidx(j)+skipPtsOff:oneidx(j)),data.bathTemp(offidx(j+1)+skipPtsOff:oneidx(j+1))) ; 
        % now we want to fit that bg so we can subtract
        % do it based on temp bc our index spacing is not equal
        bgHotFit = polyfit(temp, bgHot, 1);
        bgColdFit = polyfit(temp, bgCold, 1);
        
        tempHot = bgHotFit(2); 
        tempCold = bgColdFit(2); 
        dataOut.dToffset(j) = tempHot-tempCold; 
        %bg subtract for this interval
        hotbg = polyval(bgHotFit, data.bathTemp(offidx(j):offidx(j+1)-1));
        coldbg = polyval(bgColdFit, data.bathTemp(offidx(j):offidx(j+1)-1));
        dataOut.hotTemp = data.hotTemp(offidx(j):offidx(j+1)-1) - hotbg; 
        dataOut.coldTemp = data.coldTemp(offidx(j):offidx(j+1)-1) - coldbg; 
        data.dT(offidx(j):offidx(j+1)-1) = dataOut.hotTemp-dataOut.coldTemp; 

        % get data for off points
        dataOut.bathTemp(j) = mean(data.bathTemp(offidx(j)+skipPtsOff:oneidx(j))); 
        dataOut.sampleTemp(j) = (mean(data.hotTemp(offidx(j)+skipPtsOff:oneidx(j)))+ mean(data.coldTemp(offidx(j)+skipPtsOff:oneidx(j))))/2; 

        dataOut.dToff(j) = mean(data.dT(offidx(j)+skipPtsOff:oneidx(j)));
        dataOut.powerOff(j) = mean(data.power(offidx(j)+skipPtsOff:oneidx(j)));

        one(oneidx(j)+skipPtsOne:twoidx(j)) = 1; 
        allGood(oneidx(j)+skipPtsOne:twoidx(j)) = 1;


        dataOut.dTone(j) = mean(data.dT(oneidx(j)+skipPtsOne:twoidx(j)));
        dataOut.powerOne(j) = mean(data.power(oneidx(j)+skipPtsOne:twoidx(j)));

        two(twoidx(j)+skipPtsTwo:offidx(j+1))=1;
        allGood(twoidx(j)+skipPtsTwo:offidx(j+1))=1;

%         dataOut.bathTemp(j) = mean(data.bathTemp(twoidx(j)+skipPtsTwo:offidx(j+1))); 
        dataOut.dTtwo(j) = mean(data.dT(twoidx(j)+skipPtsTwo:offidx(j+1)-1));
        dataOut.powerTwo(j) = mean(data.power(twoidx(j)+skipPtsTwo:offidx(j+1)-1));
        dataOut.voltage(j) = mean(data.heaterVoltage(twoidx(j)+skipPtsTwo:offidx(j+1)-1));
        dataOut.current(j) = mean(data.current(twoidx(j)+skipPtsTwo:offidx(j+1)-1));

    end
    for i = 1:length(dataOut.bathTemp)
        pow = [dataOut.powerOff(i), dataOut.powerOne(i), dataOut.powerTwo(i)]; 
        if pow == [0 0 0]
            disp('abort'); 
            break
        end
        dT = [dataOut.dToff(i), dataOut.dTone(i), dataOut.dTtwo(i)];
        currFit = polyfit(pow, dT, 1); 
        currSlope = currFit(1);
        dataOut.dTIV(i) = currSlope; % com
        dataOut.conductance(i) = 1/currSlope; 
        dataOut.conductivity(i) = (1/currSlope)*geometricFactor;
    end

    dataOut.good = logical(allGood); 
    dataOut.one = logical(one); 
    dataOut.off = logical(off); 
    dataOut.two = logical(two); 


    dataOut.raw = data;

    % find 0T 
%     idx0T=findNearest(dataOut.avgField, 0); 
%     dataOut.sampleTemp0T = dataOut.sampleTemp(idx0T); 
%     dataOut.normConductance = dataOut.conductance/dataOut.conductance(idx0T);
 



end