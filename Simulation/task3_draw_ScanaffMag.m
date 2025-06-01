clc
clear

lineW = 0.5;
stdCap = 8;
MiddleLineW = 2;
MarkSiz=10;

roundTotal=100;% Already run 100 trials with randomly initialized inputs.
%% RMP=-67mV, Ndeaffre =30, EXCpercent=0~0.1~1
EXCpercentNeed= [[0 0.005 0.01 0.015 0.02 0.025 0.03 0.035 0.04 0.045 0.05 0.055 0.06 0.07 0.08 0.09 0.1]*100 100];
idxNeed = [1:13 15 17 19 21];% get correponding files
Nfiles = length(idxNeed);

Table3_FR=zeros(Nfiles+1,roundTotal);
Table3_thetaNorm = zeros(Nfiles+1,roundTotal);
Table3_stabilityTheta = zeros(Nfiles+1,roundTotal);
for roundI = 1:roundTotal
    load(['./Task3/Task3_roundI',num2str(roundI),'.mat']);
    Table3_FR(1:Nfiles,roundI) = Table3(1,idxNeed);
    Table3_thetaNorm(1:Nfiles,roundI) = Table3(2,idxNeed);   
    Table3_stabilityTheta(1:Nfiles,roundI) = Table3(3,idxNeed);      
    %  Ndeaffre =30, EXCpercent=1, is equivalent to Ndeaffre=0
    load(['./Task2/Task2_roundI',num2str(roundI),'.mat']);
    Table3_FR(Nfiles+1,roundI) = Table2_67(1,1);
    Table3_thetaNorm(Nfiles+1,roundI) = Table2_67(2,1);   
    Table3_stabilityTheta(Nfiles+1,roundI) = Table2_67(3,1);    
end

colorList=[69,117,180;215,48,39;255 200 0;235 124 19.5]./255;
mode1Lim_FR=[0 1.58];
mode1Lim_pow=[-0.08 1.19];
mode1Lim_stab=[1.42 5.45];
%%
figure 
subplot(2,1,1)
xx=EXCpercentNeed;
yy=Table3_FR;
errorbar(xx,mean(yy,2),std(yy,1,2),...        
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',stdCap);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1 
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color',colorList(1,:));
end
plot(xx(1:end),meanyy(1:end),'^','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
       'MarkerSize',MarkSiz);
axis([0 100 mode1Lim_FR])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none
truncAxis('X',[10.5 99.5])
xlabel(ax,'AffMag (%)')
ylabel(ax,'Firing Rates')
 
subplot(2,1,2)
xx=EXCpercentNeed;
yy=Table3_thetaNorm;

errorbar(xx,mean(yy,2),std(yy,1,2),...            
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',stdCap);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1 
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', colorList(1,:));
end
plot(xx(1:end),meanyy(1:end),'o','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
       'MarkerSize',MarkSiz);
axis([0 100 mode1Lim_pow])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none
truncAxis('X',[10.5 99.5])
xlabel(ax,'AffMag (%)')
ylabel(ax,'pow - θ')

set(gcf, 'Units', 'inches');
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [1 1 4 10]);
