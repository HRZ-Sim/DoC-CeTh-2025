clc
clear
colorList=[69,117,180;215,48,39;255 200 0;235 124 19.5]./255;
colorGreen=[169 209 142]/255;

lineW = 0.5;
stdCap = 8;
MiddleLineW = 2;
MarkSiz=10;

roundTotal=100;% Already run 100 trials with randomly initialized inputs.
%%  RMP=-67mV, Ndeaff = 0~100; RMP=-65mV, Ndeaff = 0
Table2_65_FR=zeros(1,roundTotal);
Table2_65_thetaNorm = zeros(1,roundTotal);
Table2_67_FR=zeros(11,roundTotal);
Table2_67_thetaNorm = zeros(11,roundTotal);
for roundI = 1:roundTotal
    load(['./Task2/Task2_roundI',num2str(roundI),'.mat']);
    Table2_65_FR(1,roundI) = Table2_65(1,1);
    Table2_65_thetaNorm(1,roundI) = Table2_65(2,1);
    Table2_67_FR(:,roundI) = Table2_67(1,:);
    Table2_67_thetaNorm(:,roundI) = Table2_67(2,:);   
end

mode1Lim_FR=[0 1.58];
mode1Lim_pow=[-0.08 1.19];

%%
figure 
subplot(2,1,1)
hold on
xx=NdeaffreCollect;
yy=Table2_67_FR;
plot(xx,mean(yy,2),'Color',colorList(1,:),'LineWidth',MiddleLineW)
errorbar(xx,mean(yy,2),std(yy,1,2),... 
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',stdCap);
plot(xx,mean(yy,2),'^','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz); 
patchHdl(1)=fill([0,0,0,0],[0,0,0,0],colorList(1,:),'LineWidth',1.2);

xx=0;
yy=Table2_65_FR;     
plot(xx,mean(yy,2),'Color',colorGreen,'LineWidth',MiddleLineW)
   errorbar(xx,mean(yy,2),std(yy,1,2),...        
    'Color',[0,0,0],'LineWidth',lineW,'CapSize',stdCap);
plot(xx,mean(yy,2),'^','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz,'MarkerFaceColor', colorGreen);
patchHdl(2)=fill([0,0,0,0],[0,0,0,0],colorGreen,'LineWidth',1.2);
set(gca, 'XTick', 0:20:100);  
ylim(mode1Lim_FR);
legend(patchHdl,{'DoC','Healthy'},'Location','northwest','Box','off')
xlabel('DdeaffRatio, %)')
ylabel('Firing Rates')
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none

subplot(2,1,2)
hold on
xx=NdeaffreCollect;%100-NdeaffreCollect;
yy=Table2_67_thetaNorm;
plot(xx,mean(yy,2),'Color',colorList(1,:),'LineWidth',MiddleLineW)
errorbar(xx,mean(yy,2),std(yy,1,2),...        
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',stdCap);
plot(xx,mean(yy,2),'o','LineWidth',lineW,'LineStyle','none','MarkerEdgeColor',[0,0,0],...
        'MarkerSize',MarkSiz);
patchHdl(1)=fill([0,0,0,0],[0,0,0,0],colorList(1,:),'LineWidth',1.2);

xx=0;
yy=Table2_65_thetaNorm;     
plot(xx,mean(yy,2),'Color',colorGreen,'LineWidth',MiddleLineW)
   errorbar(xx,mean(yy,2),std(yy,1,2),...        
    'Color',[0,0,0],'LineWidth',lineW,'CapSize',stdCap);
plot(xx,mean(yy,2),'o','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz,'MarkerFaceColor', colorGreen);
patchHdl(2)=fill([0,0,0,0],[0,0,0,0],colorGreen,'LineWidth',1.2);
set(gca, 'XTick', 0:20:100);  
ylim(mode1Lim_pow);    
legend(patchHdl,{'DoC','Healthy'},'Location','northwest','Box','off')
xlabel('DeaffRatio (%)')
ylabel('pow - θ')
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none

set(gcf, 'Units', 'inches');
set(gcf, 'PaperPositionMode', 'auto'); 
set(gcf, 'Position', [1 1 4 10]); 
