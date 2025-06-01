clc
clear

lineW = 0.5;
MiddleLineW = 2;
MarkSiz=10;
mode1Lim_pow=[-0.02 1.18];
mode1Lim_stab=[1.56 5.45];
mode1Lim_FR=[0.272 1.44];
%% scanStab 0.1~1 with affMag =0.5%
load('./EXC0.005_scanUnstable.mat')
colorList=[69,117,180;215,48,39;255 200 0;235 124 19.5]./255;
min_value=colorList(1,:);max_value=colorList(3,:);
idxChosen = [1,2,4:9];
base = rhythmNeed(idxChosen)*100;
num_vectors=length(base)-1;
Color_1 = zeros(num_vectors, 3);
for j = 1:3
    Color_1(:, j) = linspace(min_value(j), max_value(j), num_vectors);
end
idxNeedrhythm_EXC0005=idxChosen;
figure 
subplot(2,1,1)
xx=base; 
yy=Table6_thetaNorm_EXC0005(idxNeedrhythm_EXC0005,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...        
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_1(j, :));
end        
plot(xx,mean(yy,2),'o','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);
xlabel('AffStab (%)')
ylabel('pow - θ')
axis([-inf inf mode1Lim_pow])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none

subplot(2,1,2)
xx=base; 
yy=Table6_stabilityTheta_EXC0005(idxNeedrhythm_EXC0005,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...            
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_1(j, :));
end        
plot(xx,mean(yy,2),'diamond','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);
ylim([1.5 4.05])
xlabel('AffStab (%)')
ylabel('stab - θ')
axis([-inf inf mode1Lim_stab])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none

set(gcf, 'Units', 'inches');
set(gcf, 'PaperPositionMode', 'auto'); 
set(gcf, 'Position', [1 1 4 10]); 


figure
xx=base; 
yy=Table6_FR_EXC0005(idxNeedrhythm_EXC0005,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...            
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_1(j, :));
end        
plot(xx,mean(yy,2),'^','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);
xlabel('AffStab (%)')
ylabel('Firing Rates')
axis([-inf inf mode1Lim_FR])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none

set(gcf, 'Units', 'inches');
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [1 1 4 4.2]);



%% load('./Stable1_scanMagnitude.mat')
load('./Stable1_scanMagnitude.mat')
base=EXCpercentNeed*100;
colorList=[69,117,180;215,48,39;255 200 0;235 124 19.5]./255;
min_value=colorList(3,:);max_value=[colorList(2,:)+colorList(3,:)]/2;
num_vectors=length(base)-1;
Color_2 = zeros(num_vectors, 3);
for j = 1:3
    Color_2(:, j) = linspace(min_value(j), max_value(j), num_vectors);
end
figure 
subplot(2,1,1)
xx=base;
yy=Table3_thetaNorm(:,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...            
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_2(j, :));
end        
plot(xx,mean(yy,2),'o','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);
ax=gca;
xlabel(ax,'AffMag (%)')
ylabel(ax,'pow - θ')
axis([-inf inf mode1Lim_pow])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none


subplot(2,1,2)
xx=base;
yy=Table3_stabilityTheta(:,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...            
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_2(j, :));
end        
plot(xx,mean(yy,2),'diamond','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);
ax=gca;
xlabel(ax,'AffMag (%)')
ylabel(ax,'stab - θ')
axis([-inf inf mode1Lim_stab])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none

set(gcf, 'Units', 'inches');
set(gcf, 'PaperPositionMode', 'auto'); 
set(gcf, 'Position', [1 1 4 10]); 


figure
xx=base;
yy=Table3_FR(:,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...        
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_2(j, :));
end        
plot(xx,mean(yy,2),'^','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);
    
ax=gca;
xlabel(ax,'AffMag (%)')
ylabel(ax,'Firing Rates')
axis([-inf inf mode1Lim_FR])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none

set(gcf, 'Units', 'inches');
set(gcf, 'PaperPositionMode', 'auto'); 
set(gcf, 'Position', [1 1 4 4.2]); 

%%
mode2Lim_pow=[-0.02 1.68];
mode2Lim_stab=[1.37 4.75];
mode2Lim_FR=[0.27 2.23];
%% load('./Stable0.10_scanMagnitude.mat') 
load('./Stable0.10_scanMagnitude.mat') 
base=EXCpercentNeed*100;
colorList=[69,117,180;215,48,39;255 200 0;235 124 19.5]./255;
min_value=colorList(1,:);max_value=colorList(2,:);
num_vectors=length(base)-1;
Color_3 = zeros(num_vectors, 3);
for j = 1:3
    Color_3(:, j) = linspace(min_value(j), max_value(j), num_vectors);
end

figure 
subplot(2,1,1)
xx=base;
yy=Table3_thetaNorm_rhythm010(:,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...            
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_3(j, :));
end        
plot(xx,mean(yy,2),'o','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);
ax=gca;
xlabel(ax,'AffMag (%)')
ylabel(ax,'pow - θ')
axis([-inf inf mode2Lim_pow])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none

subplot(2,1,2)
xx=base;
yy=Table3_stabilityTheta_rhythm010(:,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...            
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_3(j, :));
end        
plot(xx,mean(yy,2),'diamond','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
       'MarkerSize',MarkSiz);
    
ax=gca;
xlabel(ax,'AffMag (%)')
ylabel(ax,'stab - θ')
axis([-inf inf mode2Lim_stab])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none
  
set(gcf, 'Units', 'inches');
set(gcf, 'PaperPositionMode', 'auto'); 
set(gcf, 'Position', [1 1 4 10]); 


figure
xx=base;
yy=Table3_FR_rhythm010(:,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...        
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_3(j, :));
end        
plot(xx,mean(yy,2),'^','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);

ax=gca;
xlabel(ax,'AffMag (%)')
ylabel(ax,'Firing Rates')
axis([-inf inf mode2Lim_FR])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none
set(gcf, 'Units', 'inches');
set(gcf, 'PaperPositionMode', 'auto'); 
set(gcf, 'Position', [1 1 4 4.2]); 

%% load('./EXC0.04_scanUnstable.mat')

load('./EXC0.04_scanUnstable.mat')
base = rhythmNeed*100;
colorList=[69,117,180;215,48,39;255 200 0;235 124 19.5]./255;
min_value=colorList(2,:);max_value=[colorList(2,:)+colorList(3,:)]/2;
num_vectors=length(base)-1;
Color_4 = zeros(num_vectors, 3);
for j = 1:3
    Color_4(:, j) = linspace(min_value(j), max_value(j), num_vectors);
end
figure 
subplot(2,1,1)
xx=base; 
yy=Table6_thetaNorm_EXC004(:,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...        
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_4(j, :));
end        
plot(xx,mean(yy,2),'o','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);
ylim([0.5 1.5])    
xlabel('AffStab (%)')
ylabel('pow - θ')
axis([-inf inf mode2Lim_pow])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none

subplot(2,1,2)
xx=base; 
yy=Table6_stabilityTheta_EXC004(:,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...            
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_4(j, :));
end        
plot(xx,mean(yy,2),'diamond','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);
ylim([1.5 4.05])
xlabel('AffStab (%)')
ylabel('stab - θ')
axis([-inf inf mode2Lim_stab])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none

set(gcf, 'Units', 'inches');
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [1 1 4 10]); 


figure
xx=base; 
yy=Table6_FR_EXC004(:,:);
errorbar(xx,mean(yy,2),std(yy,1,2),...            
    'Color',[0,0,0],'LineWidth',lineW,'LineStyle','none','CapSize',MarkSiz);hold on
meanyy = mean(yy,2);        
for j = 1:length(meanyy)-1
    plot(xx(j:j+1), meanyy(j:j+1),'-','LineWidth',MiddleLineW,'Color', Color_4(j, :));
end        
plot(xx,mean(yy,2),'^','LineWidth',lineW,'MarkerEdgeColor',[0,0,0],...
    'MarkerSize',MarkSiz);
xlabel('AffStab (%)')
ylabel('Firing Rates')
axis([-inf inf mode2Lim_FR])
ax = gca;
ax.Box = 'off';% Set the box property to 'off'
set(ax, 'Color', 'none'); % Set the figure background to none
set(gcf, 'Units', 'inches');
set(gcf, 'PaperPositionMode', 'auto'); 
set(gcf, 'Position', [1 1 4 4.2]); 
