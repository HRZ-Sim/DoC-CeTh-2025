clc
clear

roundTotal=100;
%% rhythm1(affStab=1): scanMag =0.5%~4%  with affStab=1
idxNeed = 2:9;% get correponding files
Nfiles = length(idxNeed);
Table3_FR=zeros(Nfiles,roundTotal);
Table3_thetaNorm = zeros(Nfiles,roundTotal);
Table3_stabilityTheta = zeros(Nfiles,roundTotal);
for roundI = 1:roundTotal
    load(['./Task3/Task3_roundI',num2str(roundI),'.mat']);
    Table3_FR(:,roundI) = Table3(1,idxNeed);
    Table3_thetaNorm(:,roundI) = Table3(2,idxNeed);   
    Table3_stabilityTheta(:,roundI) = Table3(3,idxNeed); 
end
EXCpercentNeed= [0.005 0.01 0.015 0.02 0.025 0.03 0.035 0.04];
save('./Stable1_scanMagnitude.mat','EXCpercentNeed','Table3_thetaNorm','Table3_stabilityTheta','Table3_FR');

%% rhythm010(affStab=0.1):  scanMag =0.5%~4%  with affStab=0.1
idxNeed = 2:9;% get correponding files
Nfiles = length(idxNeed);
Table3_FR_rhythm010=zeros(Nfiles,roundTotal);
Table3_thetaNorm_rhythm010 = zeros(Nfiles,roundTotal);
Table3_stabilityTheta_rhythm010 = zeros(Nfiles,roundTotal);
for roundI = 1:roundTotal
    load(['./Task6/rhythm010/Task6_roundI',num2str(roundI),'_rhythm010.mat']);
    Table3_FR_rhythm010(:,roundI) = Table6(1,idxNeed);
    Table3_thetaNorm_rhythm010(:,roundI) = Table6(2,idxNeed);   
    Table3_stabilityTheta_rhythm010(:,roundI) = Table6(3,idxNeed);      
end
EXCpercentNeed= [0.005 0.01 0.015 0.02 0.025 0.03 0.035 0.04];
save('./Stable0.10_scanMagnitude.mat','EXCpercentNeed','Table3_thetaNorm_rhythm010','Table3_stabilityTheta_rhythm010','Table3_FR_rhythm010');

%% EXC004(affMag=4%):  scanStab 0.1~1 with affMag =4%
idxNeed = [12 17 18 19 20 21 23 28 50];% get correponding files
Nfiles = length(idxNeed);
Table6_FR_EXC004=zeros(Nfiles,roundTotal);
Table6_thetaNorm_EXC004 = zeros(Nfiles,roundTotal);
Table6_stabilityTheta_EXC004 = zeros(Nfiles,roundTotal);
for roundI = 1:roundTotal
    load(['./Task6/EXC004/Task6_roundI',num2str(roundI),'_EXC004.mat']);
    Table6_FR_EXC004(:,roundI) = Table6(1,idxNeed);
    Table6_thetaNorm_EXC004(:,roundI) = Table6(2,idxNeed);   
    Table6_stabilityTheta_EXC004(:,roundI) = Table6(3,idxNeed);       
end
rhythmNeed= [0.1 0.2 0.25 0.33 0.5 0.67 0.8 0.9 1];
save('./EXC0.04_scanUnstable.mat','rhythmNeed','Table6_thetaNorm_EXC004','Table6_stabilityTheta_EXC004','Table6_FR_EXC004');

%% EXC0005(affMag=0.5%): scanStab 0.1~1 with affMag =0.5%
idxNeed = [12 17 18 19 20 21 23 28 50];% get correponding files
Nfiles = length(idxNeed);
Table6_FR_EXC0005=zeros(Nfiles,roundTotal);
Table6_thetaNorm_EXC0005 = zeros(Nfiles,roundTotal);
Table6_stabilityTheta_EXC0005 = zeros(Nfiles,roundTotal);
for roundI = 1:roundTotal
    % Table3'3X21(EXCpercentCollect),'EXCpercentCollect' 1X21   
    load(['./Task6/EXC0.005/Task6_roundI',num2str(roundI),'_EXC0.005.mat']);
    Table6_FR_EXC0005(:,roundI) = Table6(1,idxNeed);
    Table6_thetaNorm_EXC0005(:,roundI) = Table6(2,idxNeed);   
    Table6_stabilityTheta_EXC0005(:,roundI) = Table6(3,idxNeed);       
end
rhythmNeed= [0.1 0.2 0.25 0.33 0.5 0.67 0.8 0.9 1];
save('./EXC0.005_scanUnstable.mat','rhythmNeed','Table6_thetaNorm_EXC0005','Table6_stabilityTheta_EXC0005','Table6_FR_EXC0005');
