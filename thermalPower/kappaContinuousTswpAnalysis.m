%% kappa continuous Tswp analysis
function kappaContinuousTswpAnalysis(fname)
    data = load(fname); 
    dataOut = struct; 
    % first get on vs off
    curr = data.current; 
    one = zeros(1,length(curr));
    two = zeros(1, length(curr));
    off = zeros(1,length(curr)); 
    allGood = zeros(1,length(curr));

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
    data.dT = data.hotTemp-data.coldTemp;
    data.power = data.current .* data.heaterVoltage; 
    data.sampleTemp = (data.hotTemp+data.coldTemp)/2;
%     dataOut.rawdT = data.dT; 
    % let's take the average of each of these point
    for j= 1:length(offidx)-1 
        skipPtsOff = round((oneidx(j) - offidx(j))/2); 
        skipPtsOne = round((twoidx(j) - oneidx(j))/2);
        skipPtsTwo = round((offidx(j+1) - twoidx(j))/2);
        disp(skipPts)
        if skipPts < 0
            disp('oh nooooo')
        end
%         disp(skipPts)
%         disp([num2str(onidx(j)), 'off: ', num2str(offidx(j))])

        off(offidx(j)+skipPtsOff:oneidx(j)) = 1; 
        allGood(offidx(j)+skipPtsOff:oneidx(j)) = 1;

        % get data for off points
        dataOut.bathTemp(i) = mean(data.bathTemp(offidx(j)+skipPtsOff:oneidx(j))); 
        dataOut.dToff(i) = mean(data.dt(offidx(j)+skipPtsOff:oneidx(j)));
        dataOut.powerOff(i) = mean(data.power(offidx(j)+skipPtsOff:oneidx(j)));

        one(oneidx(j)+skipPtsOne:twoidx(j)) = 1; 
        allGood(oneidx(j)+skipPtsOne:twoidx(j)) = 1;

        dataOut.dTone(i) = mean(data.dt(oneidx(j)+skipPtsOne:twoidx(j)));
        dataOut.powerOne(i) = mean(data.power(oneidx(j)+skipPtsOne:twoidx(j)));

        two(twoidx(j)+skipPtsTwo:offidx(j+1))=1;
        allGood(twoidx(j)+skipPtsTwo:offidx(j+1))=1;

        dataOut.bathTemp(i) = mean(data.bathTemp(twoidx(j)+skipPtsTwo:offidx(j+1))); 
        dataOut.dTtwo(i) = mean(data.dt(twoidx(j)+skipPtsTwo:offidx(j+1)));
        dataOut.powerTwo(i) = mean(data.power(twoidx(j)+skipPtsTwo:offidx(j+1)));

    end
    

    dataOut.good = logical(allGood); 
    dataOut.one = logical(on); 
    dataOut.off = logical(off); 
    dataOut.two = logical(two); 


    dataOut.raw = data;

    % find 0T 
%     idx0T=findNearest(dataOut.avgField, 0); 
%     dataOut.sampleTemp0T = dataOut.sampleTemp(idx0T); 
%     dataOut.normConductance = dataOut.conductance/dataOut.conductance(idx0T);
 



end