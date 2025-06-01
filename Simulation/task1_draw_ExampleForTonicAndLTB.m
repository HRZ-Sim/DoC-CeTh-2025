clc
clear
N = 100;%3 types 3X100 neurons in total. 
% type1: RTN N=100% type2: CeTh N=100% type3: SR N=100
dt=1;% time step/ms
% 0~5s: Initialization with normal input to stabilize the network.
% 5~15s: Deafferented neuronal input to simulate brain injury. Note that
% all simulation results shown in the manuscript are based on this part.
t_last =10000; %(ms)  the duration for simulating (5~15s)
t_end=15000; %(ms)  endTimepoint of the simulation

% connectivity matrix W
load(['./Task1/W_N',num2str(N)]);
%targeting RTN: W{1,1}: Cortex-RTN(one to one)   W{1,2}: CeTh-RTN(CT_i~allRTN: divergence = 0.15) W{1,3}: SR-RTN(one to one)
%targeting CeTh: W{2,1}: Cortex-CeTh(one to one)   W{2,2}: RTN-CeTh(RTN_i~allCT: divergence = 0.15) 
%targeting SR： W{3,1}: Cortex-SR(one to one)      W{3,2}: RTN-SR(one to one)
% test:
% sum(W{3,2}(:,:),2)/100 %=0.01, means RTN-SR(one to one) 1/100=0.01
% sum(W{2,2}(:,:),2)/100 %=0.15, means RTN-CeTh(RTN_i~allCT: divergence = 0.15) 


%% param = (restVect,Ndeaffre,EXCpercent)
% Case1: deafferented_LTB parameters
restVect= -67;
Ndeaffre=30;% deaffRatio
EXCpercent=0.045;% affMag
param=[restVect,Ndeaffre,EXCpercent];

% case2: normal_tonic parameters
restVect= -65;% normal RMP
Ndeaffre=0;% all healthy neurons
EXCpercent=0;
param=[param; restVect,Ndeaffre,EXCpercent];


for i=1:size(param,1)
restVect = param(i,1);
Ndeaffre = param(i,2);
EXCpercent = param(i,3);
fprintf('restVect=%.2f:\t',restVect);
fprintf('Ndeaffre=%.2f:\t',Ndeaffre);
fprintf('EXCpercent=%.3f:\n',EXCpercent);

%% run simulating and plot following figures
% Fig. 4: Network simulation of neural dynamics underlying theta rhythms in CeTh.
%   subfig(d and g)
% Extended Data Fig. 7: Raster plots for tonic and bursting regimes in thalamic neurons.
Task =1;

load(['./Task1/CRX_fr_N',num2str(N),'_Ndeaffre',num2str(Ndeaffre),'_EXC',num2str(EXCpercent),'_dt',num2str(dt),'_last',num2str(t_last),'ms.mat']);
% get neuronal input(Poisson spike train): CRX_fr{1/2/3}(100X15000)
% type1:RTN  type2:CeTh  type3:SR

func_simulating(Task,restVect,Ndeaffre,EXCpercent,N,dt,t_end,CRX_fr,W,1);
fprintf('\n');
end
