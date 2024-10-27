% quick code to plot dT vs dV for thermo power
function fit = quickTEPPlot(fname, name)
% data = load('C:\Users\LeeLabLaptop\Documents\MagLab_Sept2024\SCM2\Er166\StopnGoTswp\CyclesEr166_TEP_25K_0T_2024_09_10_12_13_01\All cycles data.mat');
% 
% wanted = data.logicalArray;
% 
% wantedHot = data.hotTemp(wanted);
% wantedcold = data.coldTemp(wanted);
% wantedNernst = data.nernst(wanted);
% dT = wantedHot-wantedcold; 
% 
% plot(dT, wantedNernst); 

% data25K = load('C:\Users\LeeLabLaptop\Documents\MagLab_Sept2024\SCM2\Er166\StopnGoTswp\CyclesEr166_TEP_25K_0T_2024_09_10_12_13_01\Cycle_3_Er166_TEP_25K_0T_2024_09_10_12_13_01.mat');
% data20K = load('C:\Users\LeeLabLaptop\Documents\MagLab_Sept2024\SCM2\Er166\StopnGoTswp\Cycle_1_oneCycletest_20K_01.mat');
data25 = load(fname); 
%% so some fitting
% first fit is ~ 30s
idx = [1:40 length(data25.Time)-50:length(data25.Time)];
% idx = [1:40 429:477];
time25 = data25.Time(idx); 
tep25 = data25.TEP(idx); 
% do fit
fit25 = polyfit(time25, tep25, 2); 
wanted = data25.logicalArray;
figure()
hold on; grid on; 
plot(data25.Time, data25.TEP); 
plot(data25.Time, polyval(fit25, data25.Time)); 
% plot(data25.Time, data25.current)
title(name)
hold off; 

% now sub off fit
newTEP =[]; 
for i=1:length(data25.TEP)
    newTEP(i) = data25.TEP(i) - polyval(fit25, data25.Time(i)); 
end
figure(); 
plot(data25.Time, newTEP)
% hold on; 
% plot(data25.Time, data25.current)
title(name)

figure()
plot(data25.Time, data25.hotTemp -data25.coldTemp); 
title(name)

figure()
dT = data25.hotTemp(wanted) -data25.coldTemp(wanted); 
dV = newTEP(wanted);
fit = polyfit(dT, dV, 1); 
plot(dT, dV); 
title('TEP dV vs dT')
xlabel('dT (k)')
ylabel('dV (V)')

currentArr = data25.current(wanted); 

dtIsq = dT./currentArr./currentArr;
figure()
plot(currentArr.*currentArr, dT)
% figure()
% plot(data25.Time(wanted), dtIsq)
figure()
plot(data25.Time, data25.nernst);
title('nernst', fname)
end