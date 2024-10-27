%% do kappa Bswp analysis
function dataOut = quickBswpCalcsKappa(fname, geometricFactor)
    data = load(fname); 
    dataOut = struct; 
    % first get on vs off
    curr = data.current; 
    on = zeros(1,length(curr));
    off = zeros(1,length(curr)); 
    allGood = zeros(1,length(curr));

    df = gradient(curr);
    onidx =[]; 
    offidx =[]; 
    offidx(1) = 1; 
    for i = 2:length(df)-1
        if df(i)>0  && df(i-1)==0
           onidx(end+1) = i; 
        elseif df(i)<0 && df(i-1) ==0
           offidx(end+1) = i-1; 
        end
        
    end
    data.dT = data.hotTemp-data.coldTemp;

    data.sampleTemp = (data.hotTemp+data.coldTemp)/2;
%     dataOut.rawdT = data.dT; 
    % let's take the average of each of these point
    for j= 1:length(offidx)-1 
        skipPts = round((onidx(j) -offidx(j))/2); 
        if skipPts < 0
            disp('oh nooooo')
        end
%         disp(skipPts)
%         disp([num2str(onidx(j)), 'off: ', num2str(offidx(j))])

        off(offidx(j)+skipPts:onidx(j)) = 1; 
        allGood(offidx(j)+skipPts:onidx(j)) = 1;


        dataOut.avgField(j) = mean(data.field(offidx(j):offidx(j+1)));
        dataOut.avgdToff(j) = mean(data.dT(offidx(j)+skipPts:onidx(j)));

        on(onidx(j)+skipPts:offidx(j+1)) = 1; 
        allGood(onidx(j)+skipPts:offidx(j+1)) = 1;

        dataOut.avgdTon(j) = mean(data.dT(onidx(j)+skipPts:offidx(j+1)));

        dataOut.current(j) = mean(data.current(onidx(j)+skipPts:offidx(j+1))); 
        dataOut.voltage(j) = mean(data.heaterVoltage(onidx(j)+skipPts:offidx(j+1))); 

        dataOut.dT(j) = dataOut.avgdTon(j)-dataOut.avgdToff(j); 
        dataOut.power(j) = dataOut.current(j)*dataOut.voltage(j);

        dataOut.conductance(j) = dataOut.power(j)/dataOut.dT(j); 
        dataOut.conductivity(j) = dataOut.conductance(j)*geometricFactor; 

        dataOut.sampleTemp(j) = mean(data.sampleTemp(offidx(j):onidx(j)));
        dataOut.bathTemp(j) = mean(data.bathTemp(offidx(j):onidx(j))); 
        dataOut.hotTemp(j) = mean(data.hotTemp(offidx(j):onidx(j))); 
        dataOut.coldTemp(j) = mean(data.coldTemp(offidx(j):onidx(j)));
        dataOut.avgField(j) = mean(data.field(offidx(j):offidx(j+1)));

    end


    dataOut.good = logical(allGood); 
    dataOut.on = logical(on); 
    dataOut.off = logical(off); 


    dataOut.raw = data;

    % find 0T 
    idx0T=findNearest(dataOut.avgField, 0); 
    dataOut.sampleTemp0T = dataOut.sampleTemp(idx0T); 
    dataOut.normConductance = dataOut.conductance/dataOut.conductance(idx0T);


    %% %% now here we want to add some processing for the beginning and end points
% 
%     figure(); hold on; 
% %     plot(data.Time(logical(off)), data.TEP(logical(off)), 'ro'); 
% %     plot(data.Time(logical(on)), data.TEP(logical(on)), 'mo');
% 
%     plot(data.Time, data.current, '-b')
%     yyaxis right; 
%     plot(data.Time, off, 'ro')
%     plot(data.Time(logical(on)), data.TEP(logical(on)), 'mo');
%     plot(data.Time, df)

end