% quick code to plot dT vs dV for thermo power

data = load('C:\Users\LeeLabLaptop\Documents\MagLab_Sept2024\SCM2\Er166\StopnGoTswp\CyclesEr166_TEP_25K_0T_2024_09_10_12_13_01\All cycles data.mat');

wanted = data.logicalArray;

wantedHot = data.hotTemp(wanted);
wantedcold = data.coldTemp(wanted);
wantedNernst = data.nernst(wanted);
dT = wantedHot-wantedcold; 

plot(dT, wantedNernst); 

data = load('C:\Users\LeeLabLaptop\Documents\MagLab_Sept2024\SCM2\Er166\StopnGoTswp\CyclesEr166_TEP_25K_0T_2024_09_10_12_13_01\Cycle_3_Er166_TEP_25K_0T_2024_09_10_12_13_01.mat');

%% so some fitting
% first fit is ~ 30s
time1 = data.Time(1:90); 
tep1 = data.TEP(1:90); 
% do fit
