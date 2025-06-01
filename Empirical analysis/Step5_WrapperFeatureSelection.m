%{
  Author: Simba Zhang
  Date: November 24, 2024
  Description: Step5/5_WrapperFeatureSelection
% a model-based feature selection (model equipped with L2 regularization)
% Iterate through nearly all feature combinations of important features in step 4 
% and test each one to find the optimal feature combination.

% Features with high weights in step 4 include:
% cluster6 (MUAstabilityTheta (stab-θ)), cluster15 (MUApowerTheta (pow-θ) and MUApowerAlpha 709 (pow-α)),
% cluster2 (FiringRates), cluster18 (sync MUA Gamma (sync-γ)), and cluster12 (MUAstabilityHGamma (stab-hγ)).
% Given the significant weight of stab-θ, we iterate through all feature combinations, but all include stab-θ.

% Here, we do not need to sparsify feature weights as in step 3. Instead, we use L2 regularization in the model.
% Following a model-based feature selection similar to step 3, model classification results for 32 feature 
% combinations have been obtained.
  Inputs:  ./Intermediate results/Step5_Modelresults/featureSet@.mat
  Outputs: Imf_final.mat
%}
clc
clear 
%% step5
featureName={'MUAstabilityTheta','syncMUAGamma','MUApowerTheta',...
    'MUApowerAlpha','FiringRates','MUAstabilityHGamma'}';
numFeatureName = length(featureName);

lenChosen=32;
wRound2L2 = cell(numFeatureName,1+lenChosen);
wRound2L2(:,1) =  featureName;
performance2=cell(5,1+lenChosen);
performance2(1:5,1) = {'featureSets','Accuracy','F1Score','Prob','randAcc'};

for i=1:lenChosen
    load(['./Intermediate results/Step5_Modelresults/featureSet',num2str(i),'.mat']);

%% performance
    MacroRecallF1=F1score(labels,Prediction);
     performance2(1,1+i) = {['Feature',num2str(i)]};
    performance2([2 4 5],1+i) = num2cell(roundn([accFinally,(1000-propability)/1000,chanceLevelaAcc],-2)); 
    performance2{3,1+i} = roundn(MacroRecallF1,-2);

%% weight    
    featuresRank = featureEffects(:,1);
    topN = length(featuresRank);
    featuresRank=updatingfeatureName(featuresRank);

    w1=cell(numFeatureName,2);
    w1(:,1) = featureName;
    w1(:,2) = num2cell(zeros(numFeatureName,1));

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
            tidx = find(strcmp(weight1{idx,1},featureName));
            if ~isempty(tidx)
                w1{tidx,2} =  w1{tidx,2} +weight1{idx,2};
            end
        end
    end

    for idx = 1:numFeatureName
       wRound2L2{idx,1+i} = roundn(cell2mat(w1(idx,2)),-2);
    end
end

%% Sort the w2 variable according to accuracy (Acc), and for items with the same acc, prioritize those with a higher F1 score.
I = [23 17 9 25 21 1 11 13 7 19 3 15 31 2 5 10 18 27 4 6 22 29 8 12 14 16 24 26 28 30 32 20];
performanceCollect = cell(size(performance2));
performance2_sort(:,1) = performance2(:,1);

wRound2L2_sort = cell(size(wRound2L2));
wRound2L2_sort(:,1) = wRound2L2(:,1);
for i =1:lenChosen
    performance2_sort(:,1+i) =performance2(:,I(i)+1);    
    wRound2L2_sort(:,1+i) = wRound2L2(:,I(i)+1);
end

%% Focus on the weight matrices where Acc>= 0.96.
idx = 1+find(cell2mat(performance2_sort(2,2:end))>0.95,1);
topWeight = cell2mat(wRound2L2_sort(:,idx:end));

colorList ={[195 13 35]/255,[0 105 52]/255,[11 49 143]/255,[146 7 131]/255,[248 182 45]/255,[106 57 6]/255};
countThre =23:-0.5:0;
countPercent = zeros(size(topWeight,1),length(countThre));
for i = 1:size(topWeight,1)
    for j = 1:length(countThre)
        countPercent(i,j) = roundn(sum(topWeight(i,:)>=countThre(j)) / size(topWeight,2) * 100, 0);      
    end
end
featureStability=cell(numFeatureName,2);
featureStability(:,1) = wRound2L2_sort(:,1);
featureStability(:,2) = num2cell(countPercent(:,find(countThre==11)));

save('Imf_final.mat','featureStability','wRound2L2_sort');








%% NOTE: Feature weights after normalization are the true feature weights reported in the manuscript.
Data = cell2mat(wRound2L2_sort(:,2:33));% 6X32
Data = Data./23;% normalized feature weights
Data(find(Data==0))=NaN;
rowName = nameUpdate(wRound2L2_sort(:,1)');
countTop = sum(cell2mat(performance2_sort(2,2:end))>0.95);
type = [ones(1,32-countTop),2*ones(1,countTop)];% lowAcc;topAcc
typeName = {'lowAcc','topAcc'};
selfCLim1 = {[0/23 23/23],{'';''}};

% size
bubbleSize = cell2mat(featureStability(:,2)); 
bubbleSize = bubbleSize/100;% normalized featureStability 
bubbleSizeName = 'Stable-importance';
bubbleRange=[5 30];
selfCLim2 = {[],{'';''}};
%% output: Extended Data Fig. 2g
% the visualization code was adapted from the code in a blog:
% https://blog.csdn.net/slandarer/article/details/128927655?ops_request_misc=%257B%2522request%255Fid%2522%253A%25222bde1068a85ae9dec72e9273d52f9df9%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fblog.%2522%257D&request_id=2bde1068a85ae9dec72e9273d52f9df9&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-1-128927655-null-null.nonecase&utm_term=%E7%83%AD%E5%9B%BE%20%E6%B0%94%E6%B3%A1%E5%9B%BE&spm=1018.2226.3001.4450
%
% % selfCLim1: limits for Data
% % selfCLim2: limits for bubbleSize
% heatMapWeightWIBubble(Data,rowName,type,typeName,selfCLim1...
%     ,bubbleSize,bubbleSizeName,bubbleRange,selfCLim2)
% orient(gcf,'landscape')


%% output: Extended Data Fig. 2h [Stable-Importance index]
figure
hold on
lgd=cell(size(topWeight,1),1);
for i=1:size(topWeight,1)
    lgd{i}=plot(countThre/23,countPercent(i,:),'-','Color',colorList{i},'LineWidth',2);
    plot(0.5,countPercent(i,find(countThre==23*0.5)),'o','Color',colorList{i},'MarkerSize',10,'LineWidth',2);
end
plot(0.5*ones(11),0:10:100,'k--','LineWidth',2);
ylabel('The percentage in all topAccSets (%)')
xlabel('Lower bound of feature weights')
axis([0 1 -inf inf ])
title('feature stability in the topAccSets')
legend([lgd{1},lgd{2},lgd{3},lgd{4},lgd{5},lgd{6}],nameUpdate(wRound2L2_sort(:,1)))