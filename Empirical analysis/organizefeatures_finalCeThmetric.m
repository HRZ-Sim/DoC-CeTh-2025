%{
  Author: Simba Zhang
  Date: November 24, 2024
  Description: organize and show final chosen optimal features
  Inputs: allCeThfeatures.mat; Imf_final.mat
  Outputs: N/A
%}
clc
clear
load('allCeThfeatures.mat');%statistic','featureData','idxUnCR','idxCR'
load('Imf_final.mat');%'featureStability','wRound2L2_sort'
%% finalFeatureSet
finalfeatureName={'MUAstabilityTheta','syncMUAGamma','MUApowerTheta',...
'MUAstabilityHGamma'}';
numFeatureName = length(finalfeatureName);
finalFeatures_sort = zeros(23,numFeatureName);
statistic_final = cell(numFeatureName,3);
statistic_final(:,1) = finalfeatureName;

for i=1:numFeatureName
    idxSort = find(strcmp(finalfeatureName{i},statistic(:,1)));
    finalFeatures_sort(:,i) = featureData(:,idxSort);
    % Effect Size
    statistic_final(i,2) = statistic(idxSort,3);
    % fisherscore
    statistic_final(i,3) = statistic(idxSort,4);    
    
    % featureStability
    idx = find(strcmp(finalfeatureName{i},featureStability(:,1)));
    statistic_final(i,4) = featureStability(idx,2);
    % finalWeights
    idx = find(strcmp(finalfeatureName{i},wRound2L2_sort(:,1)));
    statistic_final(i,5) = wRound2L2_sort(idx,end);
end






%%
% Swap syncMUAgamma and MUApowerTheta
finalFeatures_sort(:,[2 3]) = finalFeatures_sort(:,[3 2]);
statistic_final([2 3],:) = statistic_final([3 2],:);

Data = finalFeatures_sort';% 4X23
rowName = statistic_final(:,1)';%4

type = [ones(1,15),2*ones(1,8)];
typeName = {'unCR','CR'};
selfCLim1 = {[-1.9,1.9],{'';''}};

% size1:fisherScore
bubbleSize = cell2mat(statistic_final(:,3)');  
bubbleSizeName = 'FisherScore';
bubbleRange=[5 30];
selfCLim2 = {[0.1 0.6],{'<=0.1';'>=0.6'}};

% color1:effectSize
bubbleColor = cell2mat(statistic_final(:,2)');  
bubbleColorName = 'EffectSize';
selfCLim3 = {[0 0.6],{'0';'>=0.6'}};

% size2: featureStability
bubbleSize_b = cell2mat(statistic_final(:,4)'); 
bubbleSize_b = bubbleSize_b/100;% 归一化稳定性
bubbleSizeName_b = 'Stable-importance';
bubbleRange_b=[5 30];
selfCLim2_b = {[0 1],{}};

% color2:finalWeights
bubbleColor_b = cell2mat(statistic_final(:,5)'); 
bubbleColor_b = bubbleColor_b/23;
bubbleColorName_b = 'FinalWeights';
selfCLim3_b = {[0/23 23/23],{'0';'1'}};

%% Fig. 1c right
% the visualization code was adapted from the code in a blog:
% https://blog.csdn.net/slandarer/article/details/128927655?ops_request_misc=%257B%2522request%255Fid%2522%253A%25222bde1068a85ae9dec72e9273d52f9df9%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fblog.%2522%257D&request_id=2bde1068a85ae9dec72e9273d52f9df9&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-1-128927655-null-null.nonecase&utm_term=%E7%83%AD%E5%9B%BE%20%E6%B0%94%E6%B3%A1%E5%9B%BE&spm=1018.2226.3001.4450
%
% % selfCLim1: limits for Data
% % selfCLim2: limits for bubbleSize1
% % selfCLim3: limits for bubbleColor1
% % selfCLim2_b: limits for bubbleSize2
% % selfCLim3_b: limits for bubbleColor2
% heatMap2Bubbles(Data,rowName,type,typeName,selfCLim1...
%     ,bubbleSize,bubbleSizeName,bubbleRange,selfCLim2...    
%     ,bubbleColor,bubbleColorName,selfCLim3...
%     ,bubbleSize_b,bubbleSizeName_b,bubbleRange_b,selfCLim2_b...
%     ,bubbleColor_b,bubbleColorName_b,selfCLim3_b)
% orient(gcf,'landscape')