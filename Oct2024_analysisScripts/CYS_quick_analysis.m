%% CYS quick analysis

%% start with Tswp stop and go
topLevelFolderZF = 'C:\Users\LeeLab Laptop 2\Documents\MagLab_Oct2024\temporary_TsweepStopGo_data_copy\StopnGoTswp\ZF_2024_10_24'; % ZF
topLevelFolder18T = 'C:\Users\LeeLab Laptop 2\Documents\MagLab_Oct2024\temporary_TsweepStopGo_data_copy\CYS_18p0072T';
lengthTherm = 0.6e-3; %.6mm  length based on thermometer distance
width = 0.8e-3; % 0.8mm
thickness = 0.0375; % mm

geometricFactor = lengthTherm/(width*thickness); 
outZF = quickCalcsThermalTrans(topLevelFolderZF, geometricFactor); 
out18T = quickCalcsThermalTrans(topLevelFolder18T, geometricFactor);

figure; grid on; hold on; 
plot(outZF.sampleTemp, outZF.conductivity, 'o', 'DisplayName','ZF');
plot(out18T.sampleTemp, out18T.conductivity, 'o', 'DisplayName','18T');
title('CYS thermal conductivity'); 
xlabel('sample temp (average of T_{hot} and T_{cold}) [K]')
ylabel('Kappa [W/(K.m)]')
legend('FontSize',12)


%% Bswp analysis



lth = 0.6e-3; % m
width = 0.8e-3; % m
thickness = 0.0375; % m

geometricFactor = lth/(width*thickness); 

[baseName, folder] = uigetfile();
fname6K = fullfile(folder, baseName); 

fname12K = 'C:\Users\LeeLab Laptop 2\Documents\MagLab_Oct2024\SCM2\CYS\Bswp\CYS_8K\CYSBsweep_18_2024_10_25_20_36_57.mat'; 
fname8K = 'C:\Users\LeeLab Laptop 2\Documents\MagLab_Oct2024\SCM2\CYS\Bswp\CYS_8K\CYSBsweep_18_2024_10_25_20_36_57.mat'; 
fname6K = 'C:\Users\LeeLab Laptop 2\Documents\MagLab_Oct2024\SCM2\CYS\Bswp\CYS_6K\CYSBsweep_0_2024_10_25_22_26_40.mat';

dataOut50K = quickBswpCalcsKappa(fname50K, geometricFactor); 
dataOut30K = quickBswpCalcsKappa(fname30K, geometricFactor); 
dataOut20K = quickBswpCalcsKappa(fname20K, geometricFactor);
dataOut12K = quickBswpCalcsKappa(fname12K, geometricFactor);
dataOut8K = quickBswpCalcsKappa(fname8K, geometricFactor);
dataOut6K = quickBswpCalcsKappa(fname6K, geometricFactor);

figure; hold on; grid on; 
plot(dataOut50K.avgField, dataOut50K.conductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut50K.sampleTemp0T), 'K') );
plot(dataOut30K.avgField, dataOut30K.conductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut30K.sampleTemp0T), 'K') );
plot(dataOut20K.avgField, dataOut20K.conductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut20K.sampleTemp0T), 'K') );
plot(dataOut12K.avgField, dataOut12K.conductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut12K.sampleTemp0T), 'K') );
plot(dataOut8K.avgField, dataOut8K.conductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut8K.sampleTemp0T), 'K') );
xlabel('Field [T]','FontSize',14); ylabel('Conductvity [W/K.m]','FontSize',14)
title('CYS Conductivity');
legend('FontSize',12);

%% check that original bswp calculation works

dataList = [dataOut50K, dataOut30K, dataOut20K, dataOut12K, dataOut8K];


for i = 1:length(dataList)
    dataOut= dataList(i); 
    figure; hold on; grid on; 

    subplot(1,3,1);  hold on;grid on; box on; 
    plot(dataOut.avgField, dataOut.avgdTon, 'o','DisplayName', '\Delta T on'); 
    plot(dataOut.avgField, dataOut.avgdToff,'o', 'DisplayName', '\Delta T off');

    plot(dataOut.raw.field, dataOut.raw.dT, '-','DisplayName', '\Delta T raw'); 
    xlabel('Field [T]'); ylabel('\Delta T [K]'); 
    legend();
    title(strcat('T_{sample} = ', num2str(mean(dataOut.sampleTemp)), 'K'));

    subplot(1,3,2); hold on;grid on; box on; 
    plot(dataOut.avgField, dataOut.power, 'o','DisplayName', 'Heater Power'); 
    xlabel('Field [T]'); ylabel('Heater Power [W]');

    subplot(1,3,3); hold on;grid on; box on; 
    plot(dataOut.avgField, dataOut.conductance,'o', 'DisplayName', 'Conductance')
    xlabel('Field [T]'); ylabel('Conductance [W/K]');


end


    dataOut = dataOut12K; 
    subplot(1,3,1);  hold on;grid on; box on; 
    plot(dataOut.avgField, dataOut.avgdTon, 'o','DisplayName', '\Delta T on'); 
    plot(dataOut.avgField, dataOut.avgdToff,'o', 'DisplayName', '\Delta T off');

    plot(dataOut.raw.field, dataOut.raw.dT, '-','DisplayName', '\Delta T raw'); 
    xlabel('Field [T]'); ylabel('\Delta T [K]'); 
    legend();
    title(strcat('T_{sample} = ', num2str(mean(dataOut.sampleTemp)), 'K'));



    figure; hold on; 
    plot(dataOut.raw.field, dataOut.raw.coldTemp, 'DisplayName', 'cold')
    plot(dataOut.raw.field, dataOut.raw.hotTemp, 'DisplayName', 'hot')
    xlabel('field [T]'); ylabel('raw Temp [K]'); legend(); 


    %% let's show how on, off and good work
    figure; 
    subplot(2,1,1); hold on; 
    plot(dataOut.raw.field, dataOut.raw.dT, '-','DisplayName','raw dT'); 
    plot(dataOut.raw.field(dataOut.on), dataOut.raw.dT(dataOut.on), 'o', 'DisplayName', 'On points used for calculations'); 
    plot(dataOut.raw.field(dataOut.off), dataOut.raw.dT(dataOut.off), 'o', 'DisplayName', 'Off points used for calculations');
    xlabel('field [T]'); ylabel('raw \Delta T [K] Time 0 at 18T, NOT 0T'); title('On/off logical array demonstration'); 
    xlim([0 0.5])

    subplot(2,1,2); hold on; 
    plot(dataOut.raw.field, dataOut.raw.dT, '-','DisplayName','raw dT'); 
    plot(dataOut.raw.field(dataOut.good), dataOut.raw.dT(dataOut.good), 'o', 'DisplayName', 'all "good" points used for calculations'); 
    xlabel('field [T]'); ylabel('raw \Delta T [K] Time 0 at 18T, NOT 0T'); title('good logical array demonstration'); 
    xlim([0 0.5])


    %% normalize by zero field 
    for i = 1:length(dataList)
        dataOut = dataOut6K; %dataList(i);
        idx0T = findNearest(dataOut.avgField, 0);
        dataOut6K.normalizedConductivity = dataOut.conductivity/dataOut.conductivity(idx0T);  
%         dataList(i) = dataOut; 
    end

figure; hold on; grid on; 
plot(dataOut50K.avgField, dataOut50K.normalizedConductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut50K.sampleTemp0T), 'K') );
plot(dataOut30K.avgField, dataOut30K.normalizedConductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut30K.sampleTemp0T), 'K') );
plot(dataOut20K.avgField, dataOut20K.normalizedConductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut20K.sampleTemp0T), 'K') );
plot(dataOut12K.avgField, dataOut12K.normalizedConductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut12K.sampleTemp0T), 'K') );
plot(dataOut8K.avgField, dataOut8K.normalizedConductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut8K.sampleTemp0T), 'K') );
plot(dataOut6K.avgField, dataOut6K.normalizedConductivity, '-o','DisplayName', strcat('T_{sample} = ', num2str(dataOut6K.sampleTemp0T), 'K') );

xlabel('Field [T]','FontSize',14); ylabel('ZF normalized Conductvity [W/K.m]','FontSize',14)
title('CYS Conductivity');
legend('FontSize',12);
