clc
clear
addpath('./scriptFunction/')

%% Task1: Fig. 4(d and g) and Extended Data Fig. 7
task1_draw_ExampleForTonicAndLTB
% Draw examples for the spiking activity of the network:
% Case1: deafferented_LTB regimes 
% case2: normal_tonic regimes 

%% Task2: Fig. 4(e)
% task2_scan deaffRatio
% Scan the proportion of deafferented neurons (deaffRatio), as the total number of neurons is 100,
% which corresponds to the number of deafferented neurons, Ndeaff.
% That is, scan Ndeaff from 0 to 100.
% The implementation is primarily based on the function func_simulating.m with Task=2.
% This process repeats for 100 trials with randomly initialized inputs to ensure better estimation accuracy.
% Due to the lengthy run time when repeated, it is recommended to run this on a server.
% Results are saved in the folder ./Task2/

task2_draw_ScandeaffRatio
% scan deaffRatio from 0~100 (%)

%% Task3: Fig. 4(f)
% task3_scanaffMag
% Scan the magnitude of residual afferent input (affMag), also referred to as EXCpercent in the code.
% That is, scan EXCpercent from 0 to 0.1 and then to 1, with Ndeaffre = 30.
% The implementation is primarily based on the function func_simulating.m with Task=3.
% This process is repeated for 100 trials with randomly initialized inputs to ensure better estimation accuracy.
% Due to the extended runtime when repeated, it is recommended to perform this task on a server.
% Results are saved in the folder ./Task3/

task3_draw_ScanaffMag
% scan affMag from 0~100 (%)  with  deaffRatio =30(%)

%% Task4 is just for my testing purposes (not related to manuscript findings), skip here.


%% Task5: Fig. 4(i)
% task5_prepare4stagesPSD
% Scan stages (I, II, III, IV); see the Method Section for the definition of each stage.
% The implementation is primarily based on the function func_simulating.m with Task=5.
% This process is repeated for 100 trials with randomly initialized inputs to ensure better estimation accuracy.
% Due to the lengthy run time when repeated, it is recommended to run this on a server.
% Results are saved in the folder ./Task5/

task5_draw_4stagesPSD

%% Task6: Fig. 5(b-f) and Extended Data Fig. 8
% task6_scanaffMagANDaffStab
% Scan the magnitude (affMag) and the stability of afferent inputs (affStab) to CeTh neurons.
% Specific scans include:
% Scan magnitude from 0.5% to 4% with affStab = 1.
% Scan magnitude from 0.5% to 4% with affStab = 0.1.
% Scan stability from 0.1 to 1 with affMag = 4%.
% Scan stability from 0.1 to 1 with affMag = 0.5%.
% The implementation is primarily based on the function func_simulating.m with Task=6.
% This process is repeated for 100 trials with randomly initialized inputs to ensure better estimation accuracy.
% Due to the highly lengthy runtime when repeated, it is recommended to perform this task on a server.
% Results are saved in the folder ./Task6/

task6_saveResults
task6_draw_scanaffMagANDaffStab% Fig. 5(b-e) and Extended Data Fig. 8

task6_draw_2DimModchanges% Fig. 5(f)
% This distribution is characterized by two dimensions: 
% the power (pow-θ) and stability (stab-θ) of the theta rhythm.

% The distribution of the simulated CeTh activity (Fig. 5(f)) is similar to 
% the empirical distribution in Extended Data Fig. 9
