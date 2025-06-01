%{
  Author: Simba Zhang
  Date: November 24, 2024
  Description: Step2/5_filteredFeatureSelection
  Inputs: step2_sampleData.mat
  Outputs: step3_@@@@@@@@featureSets.mat; step4_sampleData.mat
%}
clc
clear
load('step2_sampleData.mat');%'clusterCenter','clusterCenterLabel2','clusterCenterLabel3','labels'
% 'labels': 23(subjects)X1  for prognosis. CR:1 unCR:2

clusterCenter = clusterCenter';
numClust = size(clusterCenter,2);
idxUnCR = find(labels==2);
idxCR = find(labels==1);
%%
statistic_C = cell(numClust,4);
statistic_C(:,1) = clusterCenterLabel3; 
featureDataTemp = zeros(23,numClust);

for f =1:numClust
    d1 = clusterCenter(idxUnCR, f);
    d2 = clusterCenter(idxCR, f);
    data = [d1;d2];
    [P,H,STATS] = ranksum(d1,d2);
    statistic_C{f,2} = roundn(P,-3);
    statistic_C{f,3} = STATS.zval/(23^0.5)*(-1);
    featureDataTemp(:,f) = data;
end

% sort based on P value
[~,idx] = sort(cell2mat(statistic_C(:,2)),'ascend'); 
featureData_C = featureDataTemp(:,idx);
clusterCenter_sort = clusterCenter(:,idx);
statistic_C = statistic_C(idx,:);

features = clusterCenter_sort(:,:);
featureEffects = statistic_C(:,[1 4]);%4 here is empty
save('step3_UnFilteredfeatureSets.mat','features','featureEffects','labels')

idxSign = cell2mat(statistic_C(:,2))<0.05;
features = clusterCenter_sort(:,idxSign);
featureEffects = statistic_C(idxSign,[1 2]);
save('step3_SignfeatureSets.mat','features','featureEffects','labels')

idxES = abs(cell2mat(statistic_C(:,3)))>0.3;
features = clusterCenter_sort(:,idxES);
featureEffects = statistic_C(idxES,[1 3]);
save('step3_ESfeatureSets.mat','features','featureEffects','labels')

%% fisherRank  
featuresRank = func_FisherScore(clusterCenter,labels,clusterCenterLabel3);
%% output: Extended Data Fig. 2b
figure();
tt = cell2mat(featuresRank(:,2));
plot(1:numClust,tt);
hold on;
inflectionN =   5;%inflection point
plot(inflectionN,tt(inflectionN),'*');hold on; text(inflectionN,tt(inflectionN)+0.02,['top ',num2str(inflectionN)],'FontSize',12);
xlabel('sorted cluster No.')
ylabel('fisherScore')
title('fisherScore for All [sorted] clustered CeTh features')
ggplotAxes2D([],'AxesTheme','own1','LegendStyle','ggplot','ColorOrder','own1','EdgeStyle','gray');


ttunsorted = zeros(numClust,1);
for i = 1:numClust
   ttunsorted(i) = featuresRank{find(strcmp(clusterCenterLabel3{i},featuresRank(:,1))) ,2};
end
%% output: Extended Data Fig. 2c
figure();
sorttt = sort(ttunsorted,'descend');
idx = find(ttunsorted>=sorttt(inflectionN));scatter(idx,ttunsorted(idx));
hold on;idx = find(ttunsorted<sorttt(inflectionN));scatter(idx,ttunsorted(idx));
hold on;plot(0:numClust+1,mean(tt(inflectionN:inflectionN+1))*ones(1,numClust+2),'k--');
xlabel('unSorted cluster No.')
xlim([0 22])
ylabel('fisherScore')
title('fisherScore for All [unSorted] clustered CeTh features')
ggplotAxes2D([],'AxesTheme','own1','LegendStyle','ggplot','ColorOrder','own1','EdgeStyle','gray');

idxFs=logical(zeros(numClust,1));
for i=1:numClust
    idx = find(strcmp(statistic_C{i},featuresRank(:,1)) ==1); 
    statistic_C(i,4) = featuresRank(idx,2);
    if idx<=inflectionN
        idxFs(i) = 1;
    end
end
features = clusterCenter_sort(:,idxFs);
featureEffects = statistic_C(idxFs,[1 4]);
save('step3_FSfeatureSets.mat','features','featureEffects','labels')


save('step4_sampleData.mat','clusterCenterLabel2','clusterCenterLabel3','labels','statistic_C');








%% 
Data = featureData_C';% 21X23
rowName = statistic_C(:,1)';
type = [ones(1,15),2*ones(1,8)];
typeName = {'unCR','CR'};
selfCLim1 = {[-1.9,1.9],{'';''}};

% size
bubbleSize = cell2mat(statistic_C(:,4)');
bubbleSizeName = 'FisherScore';
bubbleRange=[5 30];
selfCLim2 = {[0.1 0.6],{'<=0.1';'>=0.6'}};

% color
bubbleColor = cell2mat(statistic_C(:,3)');
bubbleColorName = 'EffectSize';
selfCLim3 = {[0 0.6],{'0';'>=0.6'}};
%% output: Extended Data Fig. 2e
% the visualization code was adapted from the code in a blog:
% https://blog.csdn.net/slandarer/article/details/128927655?ops_request_misc=%257B%2522request%255Fid%2522%253A%25222bde1068a85ae9dec72e9273d52f9df9%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fblog.%2522%257D&request_id=2bde1068a85ae9dec72e9273d52f9df9&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-1-128927655-null-null.nonecase&utm_term=%E7%83%AD%E5%9B%BE%20%E6%B0%94%E6%B3%A1%E5%9B%BE&spm=1018.2226.3001.4450
%
% % selfCLim1: limits for Data
% % selfCLim2: limits for bubbleSize
% % selfCLim3: limits for bubbleColor
% heatMapBubble(Data,rowName,type,typeName,selfCLim1...
%     ,bubbleSize,bubbleSizeName,bubbleRange,selfCLim2...
%     ,bubbleColor,bubbleColorName,selfCLim3)
% orient(gcf,'landscape')