%{
  Author: Simba Zhang
  Date: November 24, 2024
  Description: organize and show all raw features
  Inputs: step1_sampleData.mat
  Outputs: allCTfeatures.mat
%}
clc
clear
load('step1_sampleData.mat');%'rawData','rawfeatureName','labels'
% rawData(23X34)
% labels(23)  idxUnCR(15) idxCR(8)
% rawfeatureName(34X1);
featureNum = length(rawfeatureName);
idxUnCR = find(labels==2);
idxCR = find(labels==1);
%%
statistic34order = cell(featureNum,3);
statistic34order(:,1) = rawfeatureName; 
featureDataTemp = zeros(23,featureNum);

for f =1:featureNum 
    d1 = rawData(idxUnCR, f);
    d2 = rawData(idxCR, f);
    data = [d1;d2];
    [P,H,STATS] = ranksum(d1,d2);
    statistic34order{f,2} = roundn(P,-3);
    statistic34order{f,3} = STATS.zval/(23^0.5)*(-1);
    featureDataTemp(:,f) = data;
end
% sort based on P value
[~,idx] = sort(cell2mat(statistic34order(:,2)),'ascend');
featureData34order = featureDataTemp(:,idx);
statistic34order = statistic34order(idx,:);

featureData = featureData34order;
statistic = statistic34order;

%% fisherRank 
featuresRank = fisherScore(rawData,labels,rawfeatureName);
for i=1:featureNum
    idx = find(strcmp(statistic{i,1},featuresRank(:,1)) ==1);
    statistic(i,4) = featuresRank(idx,2);
end


save('allCeThfeatures.mat','statistic','featureData','idxUnCR','idxCR');








%%
Data = featureData';% 34X23
rowName = statistic(:,1)';%1X34
type = [ones(1,15),2*ones(1,8)];
typeName = {'unCR','CR'};
selfCLim1 = {[-1.9,1.9],{'';''}};

% size
bubbleSize = cell2mat(statistic(:,4)');   %1X34
bubbleSizeName = 'FisherScore';
bubbleRange=[5 30];
selfCLim2 = {[0.1 0.6],{'<=0.1';'>=0.6'}};

% color
bubbleColor = cell2mat(statistic(:,3)');  %1X34
bubbleColorName = 'EffectSize';
selfCLim3 = {[0 0.6],{'0';'>=0.6'}};
%% Fig. 1C left
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