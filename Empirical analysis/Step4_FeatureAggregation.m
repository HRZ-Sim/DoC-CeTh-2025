%{
  Author: Simba Zhang
  Date: November 24, 2024
  Description: Step4/5_FeatureAggregation
  Inputs: ./Intermediate results/Step3_Modelresults/featureSet@.mat; step4_sampleData.mat
  Outputs: N/A
%}
clc
clear
load('step4_sampleData.mat');%'clusterCenterLabel2','clusterCenterLabel3','labels','statistic_C'
numClust = size(clusterCenterLabel2,1);

%% 21cluster_model weights
featureSetNoChosen=[1 2 3 4];%1:allUnfiltered 2:sign. 3:effectsize 4:fisherscore
wRound1L1_C = cell(numClust,1+4  );
wRound1L1_C(:,1) =  statistic_C(:,1);
performance_C=cell(5,1+4);
performance_C(1:5,1) = {'featureSets','Accuracy','F1Score','Prob','randAcc'};

for featureNo=featureSetNoChosen
    load(['./Intermediate results/Step3_Modelresults/featureSet',num2str(featureNo),'.mat']);

%% performance
    MacroRecallF1=F1score(labels,Prediction);
    performance_C(1,1+featureNo) = {['Feature',num2str(featureNo)]};
    performance_C([2 4 5],1+featureNo) = num2cell(roundn([accFinally,(1000-propability)/1000,chanceLevelaAcc],-2)); 
    performance_C{3,1+featureNo} = roundn(MacroRecallF1,-2);

%% weight    
    featuresRank = featureEffects(:,1);
    topN = length(featuresRank);    
    featuresRank=changingfeatureName(featuresRank);
    for i=1:length(featuresRank)
       idx = strcmp(featuresRank{i},clusterCenterLabel2);
       featuresRank{i} = clusterCenterLabel3{idx};
    end
    
    w1=cell(numClust,2);
    w1(:,1) = statistic_C(:,1);
    w1(:,2) = num2cell(zeros(numClust,1));


    KFolds =23;
    for foldcg = 1:KFolds
        weight1 =  cell(topN,2);
        weight1(:,1) = featuresRank;
    
        temp = featureWeight(foldcg,:);% 23fold X 21features  for classi
        temp(:,  isnan(temp(1,:)) )=[];
        tempabs = abs(temp)';
        if max(tempabs)==0
            weight1(:,2) = num2cell(0);    
        else
            weight1(:,2) = num2cell(tempabs./max(tempabs));                   
        end
    
        for idx = 1:topN
            tidx = find(strcmp(weight1{idx,1},statistic_C(:,1)));
            if ~isempty(tidx)
                w1{tidx,2} =  w1{tidx,2} +weight1{idx,2};
            end
        end
    end
    
    for idx = 1:numClust
       wRound1L1_C{idx,1+featureNo} = roundn(cell2mat(w1(idx,2)),-2);
    end
end









%% NOTE: Feature weights after normalization are the true feature weights reported in the manuscript.
Data = cell2mat(wRound1L1_C(:,[1:4]+1));% 21features X 4columns(all-sign.-ES-FS)
Data = Data./23;% normalized feature weights
Data(find(cell2mat(statistic_C(:,2))>=0.05),2)=NaN;
Data(find(abs(cell2mat(statistic_C(:,3)))<0.3),3)=NaN;
[~,I] = sort(cell2mat(statistic_C(:,4)));
Data(I(1:end-5),4)=NaN;%keep top 5 as inflectionN=5 in the Step2

rowName = wRound1L1_C(:,1)';%21 features
columnName = {'UnFiltered','Sign.','EffectSize','FisherScore'};
selfCLim1 ={[0/23,23/23],{'';''}};
%% output: Extended Data Fig. 2f
% the visualization code was adapted from the code in a blog:
% https://blog.csdn.net/slandarer/article/details/128927655?ops_request_misc=%257B%2522request%255Fid%2522%253A%25222bde1068a85ae9dec72e9273d52f9df9%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fblog.%2522%257D&request_id=2bde1068a85ae9dec72e9273d52f9df9&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-1-128927655-null-null.nonecase&utm_term=%E7%83%AD%E5%9B%BE%20%E6%B0%94%E6%B3%A1%E5%9B%BE&spm=1018.2226.3001.4450
%
% heatMapWeightNoBubble(Data,rowName,columnName,selfCLim1)
% orient(gcf,'landscape')