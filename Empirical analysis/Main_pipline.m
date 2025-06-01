clc
clear
%% 5 Steps machine learning pipline for feature selection
addpath('./scriptFunction/')

%% sample data
load('step1_sampleData.mat');
% 'rawData': 23(subjects)X34(features)
% 'rawfeatureName': 34(features)X1
% 'labels': 23(subjects)X1  for prognosis. CR:1 unCR:2

%% show all raw features
organizeAllCeThfeatures% run for Fig. 1(c,left)

%% 5 steps pipline 
Step1_clusteringFeatures% run for Extended Data Table 2 and Extended Data Fig. 2(d) 
% Clustering is conducted because some features have high similarity, as shown in Fig. 1(c left); 
% these clustered features are then used for subsequent analysis.
% However, for this initial step, only features with very high similarity are clustered 
% to ensure that all pairs of features within each cluster maintained a Spearman correlation
% strength with |r| ≥ 0.8, representing very strong correlations.

Step2_filteredFeatureSelection% run for Extended Data Fig. 2(b, c and e)
% Filtering features in 3 different pathways, including by significance, effect size, and Fisher scores.
% Thus, combined with the original "UnFiltered" pathway, there are 4 pathways in total.
 
Step3_EmbeddedFeatureSelection
% a model-based feature selection (model equipped with Lasso regularization)
% Lasso regularization inherently penalizes and reduces the coefficients of less contributive features,
% thereby effectively sparsifying feature weights. 
% In other words, it directly incorporates feature selection into the model by sparsifying the weights.

Step4_FeatureAggregation% run for Extended Data Fig. 2(f)
% Aggregate features with high weights derived from different ways in step 3.

Step5_WrapperFeatureSelection% run for Extended Data Fig. 2(g and h)
% a model-based feature selection (model equipped with L2 regularization)
% Iterate through nearly all feature combinations of important features in step 4 and test each one
% to find the optimal feature combination.


%% show the final optimal feature combination
organizefeatures_finalCeThmetric% run for Fig. 1(c,right)
