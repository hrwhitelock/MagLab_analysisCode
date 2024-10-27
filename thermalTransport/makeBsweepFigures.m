function dataOut = makeBsweepFigures(fname, sampleStr)
    dataOut = quickBswpCalcs(fname); 
    tempStr = strcat('bath temp: ', num2str(mean(dataOut.bathTemp)),'K \pm', num2str(std(dataOut.bathTemp)));

    figure(); hold on; grid on; 
    % yyaxis left;
    plot(dataOut.avgField, dataOut.onAvgnernst,'bo', 'DisplayName', strcat('nernst On', sampleStr));
    plot(dataOut.avgField(~isnan(dataOut.offAvgnernst)), dataOut.offAvgnernst(~isnan(dataOut.offAvgnernst)),'go', 'DisplayName', strcat('nernst Off', sampleStr));
    title(strcat('nernst averaged'))
    subtitle(tempStr); 
    ylabel('nernst voltage (V)')
    xlabel('field (T)')
    legend()
    dim = [.2 .5 .3 .3];
    str = sampleStr; 
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    xlim([-15 15])

    % make nernst subtraction

    dataOut.dVn = dataOut.onAvgnernst(~isnan(dataOut.offAvgnernst)) -dataOut.offAvgnernst(~isnan(dataOut.offAvgnernst)); 

    figure(); hold on; grid on; 
    % yyaxis left;
    plot(dataOut.avgField(~isnan(dataOut.offAvgnernst)), dataOut.dVn,'g', 'DisplayName', strcat('nernst subtracted', sampleStr));
    title('nernst - leading off value subtracted')
    subtitle(strcat(tempStr));
    ylabel('nernst voltage (V)')
    xlabel('field (T)')
    legend()
    dim = [.2 .6 .2 .2];
    str = sampleStr; 
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    xlim([-15 15])

    % now we do the TEP

    figure(); hold on; grid on; 
    plot(dataOut.avgField, dataOut.onAvg,'m', 'DisplayName', 'V_s on');
    plot(dataOut.avgField(~isnan(dataOut.offAvg)), dataOut.offAvg(~isnan(dataOut.offAvg)),'go', 'DisplayName', 'V_s off');
    title('V_s averaged Raw')
    subtitle(strcat(tempStr));
    ylabel('voltage (V)')
    xlabel('field (T)')
    legend()
    dim = [.2 .6 .2 .2];
    str = sampleStr; 
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    xlim([-15 15])

    % now do subtraction
    dataOut.dV = dataOut.onAvg(~isnan(dataOut.offAvg)) -dataOut.offAvg(~isnan(dataOut.offAvg));

    figure(); hold on; grid on; 
    plot(dataOut.avgField(~isnan(dataOut.offAvg)), dataOut.dV,'b', 'DisplayName', strcat('V_s off subtracted', sampleStr));
    title('V_s - leading off value subtracted')
    subtitle(strcat(tempStr));
    ylabel('voltage (V)')
    xlabel('field (T)')
    legend()
    dim = [.2 .1 .2 .2];
    str = sampleStr; 
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    xlim([-15 15])

    % nnow dT
    figure(); hold on; grid on; 
    % yyaxis right;
    plot(dataOut.avgField, dataOut.avgdTon, 'g','DisplayName', '\Delta T on');
    plot(dataOut.avgField(~isnan(dataOut.avgdToff)), dataOut.avgdToff(~isnan(dataOut.avgdToff)),'b', 'DisplayName', '\Delta T off');
    title('\Delta T averaged Raw')
    subtitle(strcat(tempStr));
    ylabel('\Delta T (K)')
    xlabel('field (T)')
    legend()
    dim = [.2 .3 .2 .2];
    str = sampleStr; 
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    xlim([-15 15])

    % now do the same subtraction
    dataOut.dTsub = dataOut.avgdTon(~isnan(dataOut.avgdToff)) -dataOut.avgdToff(~isnan(dataOut.avgdToff));


    figure(); hold on; grid on; 
    plot(dataOut.avgField(~isnan(dataOut.avgdToff)), dataOut.dTsub, 'DisplayName', strcat('\Delta T off subtracted', sampleStr));
    title('\Delta T- leading off value subtracted')
    subtitle(strcat(tempStr));
    ylabel('\Delta T (K)')
    xlabel('field (T)')
    legend()
    dim = [.2 .2 .2 .2];
    str = sampleStr; 
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    xlim([-15 15])
end