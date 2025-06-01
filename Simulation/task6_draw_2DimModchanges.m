clc
clear 
colorList=[69,117,180;255 200 0;215,48,39;235 124 19.5]./255;

load('./EXC0.005_scanUnstable.mat')
base1=rhythmNeed;
xx1=Table6_thetaNorm_EXC0005(:,:);
yy1=Table6_stabilityTheta_EXC0005(:,:);
load('./Stable1_scanMagnitude.mat')
base2=EXCpercentNeed;
xx2=Table3_thetaNorm(:,:);
yy2=Table3_stabilityTheta(:,:);
load('./Stable0.10_scanMagnitude.mat') 
base3=EXCpercentNeed;
xx3=Table3_thetaNorm_rhythm010(:,:);
yy3=Table3_stabilityTheta_rhythm010(:,:);
load('./EXC0.04_scanUnstable.mat')
base4=rhythmNeed;
xx4=Table6_thetaNorm_EXC004(:,:);
yy4=Table6_stabilityTheta_EXC004(:,:);


%%
figure
hold on
for i=1:10
    s1_x=[mean(xx1(:,i*10-9:i*10),2);mean(xx2(:,i*10-9:i*10),2)];
    s1_y=[mean(yy1(:,i*10-9:i*10),2);mean(yy2(:,i*10-9:i*10),2)];
    s1_x=func_smoothDots(s1_x); pchip_x=s1_x;
    s1_y=func_smoothDots(s1_y); pchip_y=s1_y;
    [~, index] = min(abs(pchip_x-s1_x(9)));
    min_value=colorList(1,:);max_value=colorList(2,:);
    num_vectors=index-1;
    Color_1 = zeros(num_vectors, 3);
    for j = 1:3
        Color_1(:, j) = linspace(min_value(j), max_value(j), num_vectors);
    end
    min_value=colorList(2,:);max_value=[colorList(2,:)+colorList(3,:)]/2;
    num_vectors=length(pchip_x)-index;
    Color_2 = zeros(num_vectors, 3);
    for j = 1:3
        Color_2(:, j) = linspace(min_value(j), max_value(j), num_vectors);
    end
    for j = 1:index-1
        plot(pchip_x(j:j+1), pchip_y(j:j+1),'-','LineWidth',1,'Color', Color_1(j, :));
    end
    for j = index:length(pchip_x)-1
        plot(pchip_x(j:j+1), pchip_y(j:j+1),'-','LineWidth',1,'Color', Color_2(j-index+1, :));
    end    
    plot(s1_x(1),s1_y(1),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',colorList(1,:),'MarkerSize',10); 
    plot(s1_x(9),s1_y(9),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',colorList(2,:),'MarkerSize',10); 
    plot(s1_x(17),s1_y(17),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',(colorList(2,:)+colorList(3,:))/2,'MarkerSize',10); 

    s2_x=[mean(xx3(:,i*10-9:i*10),2);mean(xx4(:,i*10-9:i*10),2)];
    s2_y=[mean(yy3(:,i*10-9:i*10),2);mean(yy4(:,i*10-9:i*10),2)];
    s2_x=func_smoothDots(s2_x); pchip_x=s2_x;
    s2_y=func_smoothDots(s2_y); pchip_y=s2_y;
    [~, index] = min(abs(pchip_x-s2_x(8)));
    min_value=colorList(1,:);max_value=colorList(3,:);
    num_vectors=index-1;
    Color_3 = zeros(num_vectors, 3);
    for j = 1:3
        Color_3(:, j) = linspace(min_value(j), max_value(j), num_vectors);
    end
    min_value=colorList(3,:);max_value=[colorList(2,:)+colorList(3,:)]/2;
    num_vectors=length(pchip_x)-index;
    Color_4 = zeros(num_vectors, 3);
    for j = 1:3
        Color_4(:, j) = linspace(min_value(j), max_value(j), num_vectors);
    end    
    for j = 1:index-1
        plot(pchip_x(j:j+1), pchip_y(j:j+1),'-','LineWidth',1,'Color', Color_3(j, :));
    end
    for j = index:length(pchip_x)-1
        plot(pchip_x(j:j+1), pchip_y(j:j+1),'-','LineWidth',1,'Color', Color_4(j-index+1, :));
    end     
    plot(s2_x(1),s2_y(1),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',colorList(1,:),'MarkerSize',10); 
    plot(s2_x(8),s2_y(8),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',colorList(3,:),'MarkerSize',10); 
    plot(s2_x(17),s2_y(17),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',(colorList(2,:)+colorList(3,:))/2,'MarkerSize',10);      
end


[~,xE1, yE1] = func_checkPlotINEllipse(0, 0, 0.09, 0.28, 0.27, 2.072, pi*0.18);    
[~,xE2, yE2] = func_checkPlotINEllipse(0, 0,  0.04, 0.55, 0.163, 3.6, pi*0.008);
[~,xE3, yE3] = func_checkPlotINEllipse(0, 0, 0.09, 0.4, 0.97, 3.67, pi*0.025);
[~,xE4, yE4] = func_checkPlotINEllipse(0, 0,  0.1, 0.26, 1.23, 2.594, pi*0.06);
plot(xE1, yE1, '-', 'LineWidth', 2,'Color',colorList(1,:)); 
plot(xE2, yE2, '-', 'LineWidth', 2,'Color',colorList(2,:)); 
plot(xE3, yE3, '-', 'LineWidth', 2,'Color',(colorList(2,:)+colorList(3,:))/2); 
plot(xE4, yE4, '-', 'LineWidth', 2,'Color',colorList(3,:)); 
    
ax1 = subplot(1, 1, 1);
avex1=mean(xx1,2);avey1=mean(yy1,2);
avex2=mean(xx2,2);avey2=mean(yy2,2);
avexx=[avex1;avex2];
aveyy=[avey1;avey2];
avexx=func_smoothDots(avexx);
aveyy=func_smoothDots(aveyy);
pchip_x=func_interpolation([base1,1+base2*(1/0.04)],avexx(1:17));
pchip_y=func_interpolation([base1,1+base2*(1/0.04)],aveyy(1:17));
[~, index] = min(abs(pchip_x-avexx(9)));
    
min_value=colorList(1,:);max_value=colorList(2,:);
num_vectors=index-1;
Color_1 = zeros(num_vectors, 3);
for j = 1:3
    Color_1(:, j) = linspace(min_value(j), max_value(j), num_vectors);
end
min_value=colorList(2,:);max_value=[colorList(2,:)+colorList(3,:)]/2;
num_vectors=length(pchip_x)-index;
Color_2 = zeros(num_vectors, 3);
for j = 1:3
    Color_2(:, j) = linspace(min_value(j), max_value(j), num_vectors);
end
for j = 1:index-1
    plot(pchip_x(j:j+1), pchip_y(j:j+1),'-','LineWidth',4,'Color', Color_1(j, :));
end
for j = index:length(pchip_x)-1
    plot(pchip_x(j:j+1), pchip_y(j:j+1),'-','LineWidth',4,'Color', Color_2(j-index+1, :));
end

plot(avexx(1),aveyy(1),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',colorList(1,:),'MarkerSize',10);
plot(avexx(9),aveyy(9),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',+colorList(2,:),'MarkerSize',10);
plot(avexx(17),aveyy(17),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',(colorList(2,:)+colorList(3,:))/2,'MarkerSize',10);
colormap(ax1, [Color_1;Color_2]);
cbar1 = colorbar(ax1, 'Position', [0.03 0.1 0.03 0.8]); 
cbar1.Label.String = 'Dynamic_1';

ax2 = axes('Position', ax1.Position, 'Color', 'none', 'YAxisLocation', 'right', 'XTick', [], 'YColor', 'b');
linkaxes([ax1, ax2], 'xy');

hold on;
avex3=mean(xx3,2);avey3=mean(yy3,2);
avex4=mean(xx4,2);avey4=mean(yy4,2);
avexx=[avex3;avex4];
aveyy=[avey3;avey4];
avexx=func_smoothDots(avexx);
aveyy=func_smoothDots(aveyy);
pchip_x=func_interpolation([base3*(1/0.04),1+base4],avexx(1:17));
pchip_y=func_interpolation([base3*(1/0.04),1+base4],aveyy(1:17));
[~, index] = min(abs(pchip_x-avexx(8)));

min_value=colorList(1,:);max_value=colorList(3,:);
num_vectors=index-1;
Color_3 = zeros(num_vectors, 3);
for j = 1:3
    Color_3(:, j) = linspace(min_value(j), max_value(j), num_vectors);
end
min_value=colorList(3,:);max_value=[colorList(2,:)+colorList(3,:)]/2;
num_vectors=length(pchip_x)-index;
Color_4 = zeros(num_vectors, 3);
for j = 1:3
    Color_4(:, j) = linspace(min_value(j), max_value(j), num_vectors);
end
for j = 1:index-1
    plot(pchip_x(j:j+1), pchip_y(j:j+1),'-','LineWidth',4,'Color', Color_3(j, :));
end
for j = index:length(pchip_x)-1
    plot(pchip_x(j:j+1), pchip_y(j:j+1),'-','LineWidth',4,'Color', Color_4(j-index+1, :));
end   
plot(avexx(1),aveyy(1),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',colorList(1,:),'MarkerSize',10);
plot(avexx(8),aveyy(8),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',colorList(3,:),'MarkerSize',10);
plot(avexx(17),aveyy(17),'o','LineWidth',1,'LineStyle','none','MarkerEdgeColor','none',...
        'MarkerFaceColor',(colorList(2,:)+colorList(3,:))/2,'MarkerSize',10);
colormap(ax2, [Color_3;Color_4]);
cbar2 = colorbar(ax2, 'Position', [0.95 0.1 0.03 0.8]); 
cbar2.Label.String = 'Dynamic_2';
xlabel('pow-theta');
ylabel(ax1, 'stab-theta');
ylabel(ax2, 'stab-theta');
axis([0 1.4 1.2 5])


scatter(xx1(1,25), yy1(1,25), 200, 'o', 'MarkerEdgeColor', [0,0,0], ...
        'MarkerFaceColor', colorList(1,:), 'MarkerFaceAlpha', 0.7);

scatter(xx1(9,54), yy1(9,54), 200, 'o', 'MarkerEdgeColor', [0,0,0], ...
    'MarkerFaceColor', colorList(2,:), 'MarkerFaceAlpha', 0.7);

scatter(xx2(8,94), yy2(8,94), 200, 'o', 'MarkerEdgeColor', [0,0,0], ...
    'MarkerFaceColor', [colorList(2,:)+colorList(3,:)]/2, 'MarkerFaceAlpha', 0.8);    

scatter(xx3(8,19), yy3(8,19), 200, 'o', 'MarkerEdgeColor', [0,0,0], ...
    'MarkerFaceColor', colorList(3,:), 'MarkerFaceAlpha', 0.7);    
