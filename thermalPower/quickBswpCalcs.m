function dataOut = quickBswpCalcs(fname)
% hope sept 2024
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
        data.dT(i) = data.hotTemp(i)-data.coldTemp(i); 
    end
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

        dataOut.offAvg(j) = mean(data.TEP(offidx(j)+skipPts:onidx(j)));
        dataOut.offAvgnernst(j) = mean(data.nernst(offidx(j)+skipPts:onidx(j)));
        dataOut.avgField(j) = mean(data.field(offidx(j):offidx(j+1)));
        dataOut.avgdToff(j) = mean(data.dT(offidx(j)+skipPts:onidx(j)));

        on(onidx(j)+skipPts:offidx(j+1)) = 1; 
        allGood(onidx(j)+skipPts:offidx(j+1)) = 1;

        dataOut.onAvg(j) = mean(data.TEP(onidx(j)+skipPts:offidx(j+1)));
        dataOut.onAvgnernst(j) = mean(data.nernst(onidx(j)+skipPts:offidx(j+1)));
        dataOut.avgdTon(j) = mean(data.dT(onidx(j)+skipPts:offidx(j+1)));

        dataOut.avgField(j) = mean(data.field(offidx(j):offidx(j+1)));

    end
    dataOut.dVs = dataOut.onAvg - dataOut.offAvg; 
    dataOut.dVn = dataOut.onAvgnernst - dataOut.offAvgnernst;
    dataOut.dT = dataOut.avgdTon - dataOut.avgdToff;
    dataOut.good = logical(allGood); 
    dataOut.on = logical(on); 
    dataOut.off = logical(off); 


    dataOut.raw = data;
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