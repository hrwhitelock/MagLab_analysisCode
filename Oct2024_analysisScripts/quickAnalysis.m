%% quick analysis log for oct 2024 magnet time
% TaSb2 first cooldown
% hope whitelock

%7K bswp 0 -6T
[baseName, folder] = uigetfile();
fname = fullfile(folder, baseName);
dataOut6T = quickBswpCalcs(fname); 
[baseName, folder] = uigetfile();
fname = fullfile(folder, baseName);
dataOut18T = quickBswpCalcs(fname);
% cut above i = 72 :(

figure(); hold on; grid on; 
yyaxis left;
plot(dataOut6T.avgField(1:72), dataOut6T.onAvgnernst(1:72), 'b','DisplayName', 'nernst'); 
plot(dataOut18T.avgField, dataOut18T.onAvgnernst,'b', 'DisplayName', 'nernst'); 
title('uncalibrated nernst')
ylabel('nernst voltage (V)')
xlabel('field (T)')

% figure(); hold on; grid on; 
plot(dataOut6T.avgField(1:72), dataOut6T.onAvg(1:72), 'm','DisplayName', 'TEP');
plot(dataOut18T.avgField, dataOut18T.onAvg,'m', 'DisplayName', 'TEP');
title('uncalibrated TEP')
ylabel('voltage (V)')
xlabel('field (T)')

% figure(); hold on; grid on; 
yyaxis right;
plot(dataOut6T.avgField(1:72), dataOut6T.avgdTon(1:72), 'g','DisplayName', 'dT');
plot(dataOut18T.avgField, dataOut18T.avgdTon, 'g','DisplayName', 'dT');
title('7K Bswp')
ylabel('dT (K)')
xlabel('field (T)')
str = 'Probe temp, 7k \n Bswp from 0-18T, stopped in the middle from error';
annotation('textbox',dim,'String',str,'FitBoxToText','on');

%% 10K
[baseName, folder] = uigetfile();
fname = fullfile(folder, baseName);
dataOut = quickBswpCalcs(fname); 

figure(); hold on; grid on; 
yyaxis left;
plot(dataOut.avgField, dataOut.onAvgnernst,'b', 'DisplayName', 'nernst'); 
title('uncalibrated nernst')
ylabel('nernst voltage (V)')
xlabel('field (T)')

% figure(); hold on; grid on; 
plot(dataOut.avgField, dataOut.onAvg,'m', 'DisplayName', 'TEP');
title('uncalibrated TEP')
ylabel('voltage (V)')
xlabel('field (T)')

% figure(); hold on; grid on; 
yyaxis right;
plot(dataOut.avgField, dataOut.avgdTon, 'g','DisplayName', 'dT');
title('10K Bswp')
ylabel('dT (K)')
xlabel('field (T)')
% str = 'Probe temp, 7k \n Bswp from 0-18T, stopped in the middle from error';
% annotation('textbox',dim,'String',str,'FitBoxToText','on');

%% 10K - to + sweep
[baseName, folder] = uigetfile();
fname = fullfile(folder, baseName);
dataOut = quickBswpCalcs(fname); 

figure(); hold on; grid on; 
% yyaxis left;
plot(dataOut.avgField, dataOut.onAvgnernst,'bo', 'DisplayName', 'nernst On');
plot(dataOut.avgField(~isnan(dataOut.offAvgnernst)), dataOut.offAvgnernst(~isnan(dataOut.offAvgnernst)),'go', 'DisplayName', 'nernst off');
title('uncalibrated nernst')
ylabel('nernst voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .5 .3 .3];
str = 'Probe temp 10K, bath temp 5.5K';
annotation('textbox',dim,'String',str,'FitBoxToText','on');

% make nernst subtraction

dataOut.dVn = dataOut.onAvgnernst(~isnan(dataOut.offAvgnernst)) -dataOut.offAvgnernst(~isnan(dataOut.offAvgnernst)); 

figure(); hold on; grid on; 
% yyaxis left;
plot(dataOut.avgField(~isnan(dataOut.offAvgnernst)), dataOut.dVn,'g', 'DisplayName', 'nernst subtracted');
title('uncalibrated nernst')
ylabel('nernst voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .6 .2 .2];
str = {'nernst subtraction - only leading off value subtracted',' probe temp 10K, bath temp 5.5K'};
annotation('textbox',dim,'String',str,'FitBoxToText','on');

% now we do the TEP

figure(); hold on; grid on; 
plot(dataOut.avgField, dataOut.onAvg,'m', 'DisplayName', 'V_s on');
plot(dataOut.avgField(~isnan(dataOut.offAvg)), dataOut.offAvg(~isnan(dataOut.offAvg)),'go', 'DisplayName', 'V_s off');
title('uncalibrated V_s')
ylabel('voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .1 .2 .2];
str = {'subtraction - only leading off value subtracted',' probe temp 10K, bath temp 5.5K'};
annotation('textbox',dim,'String',str,'FitBoxToText','on');

% now do subtraction
dataOut.dV = dataOut.onAvg(~isnan(dataOut.offAvg)) -dataOut.offAvg(~isnan(dataOut.offAvg));

figure(); hold on; grid on; 
plot(dataOut.avgField(~isnan(dataOut.offAvg)), dataOut.dV,'b', 'DisplayName', 'V_s off subtracted');
title('uncalibrated V_s')
ylabel('voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .1 .2 .2];
str = {'V_s subtraction - only leading off value subtracted',' probe temp 10K, bath temp 5.5K'};
annotation('textbox',dim,'String',str,'FitBoxToText','on');

% nnow dT
figure(); hold on; grid on; 
% yyaxis right;
plot(dataOut.avgField, dataOut.avgdTon, 'g','DisplayName', '\Delta T on');
plot(dataOut.avgField(~isnan(dataOut.avgdToff)), dataOut.avgdToff(~isnan(dataOut.avgdToff)),'b', 'DisplayName', '\Delta T off');
title('\Delta T uncalibrated')
ylabel('\Delta T (K)')
xlabel('field (T)')
legend()
dim = [.2 .3 .2 .2];
str = {'TaSb2', '\Delta T, no off subtraction,averaging only',' probe temp 10K, bath temp 5.5K'};
annotation('textbox',dim,'String',str,'FitBoxToText','on');

% now do the same subtraction
dataOut.dTsub = dataOut.avgdTon(~isnan(dataOut.avgdToff)) -dataOut.offAvg(~isnan(dataOut.avgdToff));


figure(); hold on; grid on; 
plot(dataOut.avgField(~isnan(dataOut.avgdToff)), dataOut.dTsub, 'DisplayName', '\Delta T off subtracted');
title('uncalibrated, subtracted \Delta T')
ylabel('\Delta T (K)')
xlabel('field (T)')
legend()
dim = [.2 .7 .2 .2];
str = {'TaSb2','\Delta T subtraction - only leading off value subtracted',' probe temp 10K, bath temp 5.5K'};
annotation('textbox',dim,'String',str,'FitBoxToText','on');

%% 60K +18 to -18 sweep
% [baseName, folder] = uigetfile();
% fname = fullfile(folder, baseName);
% dataOut = quickBswpCalcs(fname); 

sampleStr = 'TaSb2';
tempStr = 'probe temp 60K, bath temp ~55K';

figure(); hold on; grid on; 
% yyaxis left;
plot(dataOut.avgField, dataOut.onAvgnernst,'bo', 'DisplayName', 'nernst On');
plot(dataOut.avgField(~isnan(dataOut.offAvgnernst)), dataOut.offAvgnernst(~isnan(dataOut.offAvgnernst)),'go', 'DisplayName', 'nernst off');
title('nernst averaged Raw')
ylabel('nernst voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .5 .3 .3];
str = {sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-20 15])
% make nernst subtraction

dataOut.dVn = dataOut.onAvgnernst(~isnan(dataOut.offAvgnernst)) -dataOut.offAvgnernst(~isnan(dataOut.offAvgnernst)); 

figure(); hold on; grid on; 
% yyaxis left;
plot(dataOut.avgField(~isnan(dataOut.offAvgnernst)), dataOut.dVn,'g', 'DisplayName', 'nernst subtracted');
title('nernst - leading off value subtracted')
ylabel('nernst voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .6 .2 .2];
str = {sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-20 15])
% now we do the TEP

figure(); hold on; grid on; 
plot(dataOut.avgField, dataOut.onAvg,'m', 'DisplayName', 'V_s on');
plot(dataOut.avgField(~isnan(dataOut.offAvg)), dataOut.offAvg(~isnan(dataOut.offAvg)),'go', 'DisplayName', 'V_s off');
title('V_s averaged Raw')
ylabel('voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .6 .2 .2];
 str = {sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-20 15])
% now do subtraction
dataOut.dV = dataOut.onAvg(~isnan(dataOut.offAvg)) -dataOut.offAvg(~isnan(dataOut.offAvg));

figure(); hold on; grid on; 
plot(dataOut.avgField(~isnan(dataOut.offAvg)), dataOut.dV,'b', 'DisplayName', 'V_s off subtracted');
title('V_s - leading off value subtracted')
ylabel('voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .1 .2 .2];
str ={sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-20 15])
% nnow dT
figure(); hold on; grid on; 
% yyaxis right;
plot(dataOut.avgField, dataOut.avgdTon, 'g','DisplayName', '\Delta T on');
plot(dataOut.avgField(~isnan(dataOut.avgdToff)), dataOut.avgdToff(~isnan(dataOut.avgdToff)),'b', 'DisplayName', '\Delta T off');
title('\Delta T averaged Raw')
ylabel('\Delta T (K)')
xlabel('field (T)')
legend()
dim = [.2 .3 .2 .2];
str = {sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-20 15])
% now do the same subtraction
dataOut.dTsub = dataOut.avgdTon(~isnan(dataOut.avgdToff)) -dataOut.offAvg(~isnan(dataOut.avgdToff));


figure(); hold on; grid on; 
plot(dataOut.avgField(~isnan(dataOut.avgdToff)), dataOut.dTsub, 'DisplayName', '\Delta T off subtracted');
title('\Delta T- leading off value subtracted')
ylabel('\Delta T (K)')
xlabel('field (T)')
xlim([-20 15])
legend()
dim = [.2 .2 .2 .2];
str = {sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');

%% 80K -18 to +18 sweep
[baseName, folder] = uigetfile();
fname = fullfile(folder, baseName);
dataOut = quickBswpCalcs(fname); 

sampleStr = 'TaSb2';
tempStr = 'probe temp 80K, bath temp ~69K';

figure(); hold on; grid on; 
% yyaxis left;
plot(dataOut.avgField, dataOut.onAvgnernst,'bo', 'DisplayName', 'nernst On');
plot(dataOut.avgField(~isnan(dataOut.offAvgnernst)), dataOut.offAvgnernst(~isnan(dataOut.offAvgnernst)),'go', 'DisplayName', 'nernst off');
title('nernst averaged Raw')
ylabel('nernst voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .5 .3 .3];
str = {sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-15 15])

% make nernst subtraction

dataOut.dVn = dataOut.onAvgnernst(~isnan(dataOut.offAvgnernst)) -dataOut.offAvgnernst(~isnan(dataOut.offAvgnernst)); 

figure(); hold on; grid on; 
% yyaxis left;
plot(dataOut.avgField(~isnan(dataOut.offAvgnernst)), dataOut.dVn,'g', 'DisplayName', 'nernst subtracted');
title('nernst - leading off value subtracted')
ylabel('nernst voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .6 .2 .2];
str = {sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-15 15])

% now we do the TEP

figure(); hold on; grid on; 
plot(dataOut.avgField, dataOut.onAvg,'m', 'DisplayName', 'V_s on');
plot(dataOut.avgField(~isnan(dataOut.offAvg)), dataOut.offAvg(~isnan(dataOut.offAvg)),'go', 'DisplayName', 'V_s off');
title('V_s averaged Raw')
ylabel('voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .6 .2 .2];
 str = {sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-15 15])

% now do subtraction
dataOut.dV = dataOut.onAvg(~isnan(dataOut.offAvg)) -dataOut.offAvg(~isnan(dataOut.offAvg));

figure(); hold on; grid on; 
plot(dataOut.avgField(~isnan(dataOut.offAvg)), dataOut.dV,'b', 'DisplayName', 'V_s off subtracted');
title('V_s - leading off value subtracted')
ylabel('voltage (V)')
xlabel('field (T)')
legend()
dim = [.2 .1 .2 .2];
str ={sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-15 15])

% nnow dT
figure(); hold on; grid on; 
% yyaxis right;
plot(dataOut.avgField, dataOut.avgdTon, 'g','DisplayName', '\Delta T on');
plot(dataOut.avgField(~isnan(dataOut.avgdToff)), dataOut.avgdToff(~isnan(dataOut.avgdToff)),'b', 'DisplayName', '\Delta T off');
title('\Delta T averaged Raw')
ylabel('\Delta T (K)')
xlabel('field (T)')
legend()
dim = [.2 .3 .2 .2];
str = {sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-15 15])

% now do the same subtraction
dataOut.dTsub = dataOut.avgdTon(~isnan(dataOut.avgdToff)) -dataOut.offAvg(~isnan(dataOut.avgdToff));


figure(); hold on; grid on; 
plot(dataOut.avgField(~isnan(dataOut.avgdToff)), dataOut.dTsub, 'DisplayName', '\Delta T off subtracted');
title('\Delta T- leading off value subtracted')
ylabel('\Delta T (K)')
xlabel('field (T)')
legend()
dim = [.2 .2 .2 .2];
str = {sampleStr, tempStr};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlim([-15 15])

%% probe temp 100K data
% [baseName, folder] = uigetfile();
% fname = fullfile(folder, baseName);
 
fname = 'C:\Users\LeeLabLaptop\Documents\MagLab_Oct2024\SCM2\TaSb2\Bswp\TaSb2_100K\TaSb2Bsweep_-18_2024_10_23_08_51_18.mat'; 
dataOut = quickBswpCalcs(fname);
sampleStr = 'TaSb2, probe temp 100K';
~ = makeBsweepFigures(fname, sampleStr)

%% 100K again after temp settle
% [baseName, folder] = uigetfile();
% fname = fullfile(folder, baseName)
 
fname ='C:\Users\LeeLabLaptop\Documents\MagLab_Oct2024\SCM2\TaSb2\Bswp\TaSb2_100K\TaSb2Bsweep_18_2024_10_23_11_25_09.mat'; 
% dataOut = quickBswpCalcs(fname);
sampleStr = {'TaSb2, probe temp 100K', 'second scan after temperature fully settled'};
dataOut = makeBsweepFigures(fname, sampleStr); 


%% put 100K and 10 on same figure
fname100 ='C:\Users\LeeLabLaptop\Documents\MagLab_Oct2024\SCM2\TaSb2\Bswp\TaSb2_100K\TaSb2Bsweep_18_2024_10_23_11_25_09.mat'; 
fname10 = 'C:\Users\LeeLabLaptop\Documents\MagLab_Oct2024\SCM2\TaSb2\Bswp\TaSb2_10K\TaSb2Bsweep_18_2024_10_22_22_46_08.mat';
fname60 = 'C:\Users\LeeLabLaptop\Documents\MagLab_Oct2024\SCM2\TaSb2\Bswp\TaSb2_60K\TaSb2Bsweep_-18_2024_10_23_16_27_11.mat';


dataOut100 = makeBsweepFigures(fname100, '100K probe temp'); 
dataOut10 = makeBsweepFigures(fname10, '10K probe temp');
dataOut60 = makeBsweepFigures(fname60, '60K probe temp');

figure; hold on; grid on; 
% make nernst first
plot(dataOut100.avgField(~isnan(dataOut100.offAvgnernst)), dataOut100.dVn(~isnan(dataOut100.offAvgnernst)), 'c', 'DisplayName', '100K probe temp'); 
plot(dataOut10.avgField(~isnan(dataOut10.offAvgnernst)), dataOut10.dVn(~isnan(dataOut10.offAvgnernst)), 'c', 'DisplayName', '10K probe temp'); 
legend()
ylabel('nernst voltage (V)')
xlabel('field (T)')
title('TaSb2 at probe temp 100K and 10K')

figure; hold on; grid on; 
% make nernst first
plot(dataOut100.avgField, dataOut100.dVn, 'c', 'DisplayName', '100K probe temp'); 
plot(dataOut10.avgField, dataOut10.dVn, 'c', 'DisplayName', '10K probe temp'); 
legend()
ylabel('nernst voltage (V)')
xlabel('field (T)')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% switching to CYS Analysis
%% 
%% thermal tranport only, no electrical reading
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start with Tswp stop and go
topLevelFolderZF = 'C:\Users\LeeLab Laptop 2\Documents\MagLab_Oct2024\SCM2\CYS\StopnGoTswp\ZF_2024_10_24'; % ZF
topLevelFolder18T = 'C:\Users\LeeLab Laptop 2\Documents\MagLab_Oct2024\SCM2\CYS\StopnGoTswp\CYS_18p0072T';
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

% Bswp at 50K



