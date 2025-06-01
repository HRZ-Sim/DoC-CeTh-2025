%{
  Author: Simba Zhang
  Date: November 24, 2024
  Description: Step3/5_EmbeddedFeatureSelection
  Inputs: step3_@@@@@@@@featureSets.mat
  Outputs: ./Intermediate results/Step3_Modelresults/featureSet@.mat; step4_sampleData.mat
%}
%% Inputs: 4 pathways from step2
% load('step3_UnFilteredfeatureSets.mat');%'features','featureEffects','labels'
% load('step3_SignfeatureSets.mat');
% load('step3_ESfeatureSets.mat');
% load('step3_FSfeatureSets.mat');

%% linear SVM + nested LOPO see Method Section for details
% linear SVM: using the liblinear-2.43
% hyper-parameter tuning within each outer-train fold, we utilized nested LOPO cross-validation combined with a grid search strategy
% LIBSVM page:
% http://www.csie.ntu.edu.tw/~cjlin/libsvm

%% Output:
% ./Intermediate results/Step3_Modelresults/featureSet1.mat;% UnFilteredfeatureSets
% ./Intermediate results/Step3_Modelresults/featureSet2.mat;% SignfeatureSets
% ./Intermediate results/Step3_Modelresults/featureSet3.mat;% ESfeatureSets
% ./Intermediate results/Step3_Modelresults/featureSet4.mat;% FSfeatureSets
