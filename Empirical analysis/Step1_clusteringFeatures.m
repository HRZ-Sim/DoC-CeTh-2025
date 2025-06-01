%{
  Author: Simba Zhang
  Date: November 24, 2024
  Description: Step1/5_clusteringFeatures
  Inputs: step1_sampleData.mat
  Outputs: step2_sampleData.mat
%}
%% 
clc
clear
load('step1_sampleData.mat');%'rawData','rawfeatureName','labels'
% rawData(23X34)
% labels(23)  idxUnCR(15) idxCR(8)
% rawfeatureName(34X1);
clusterData =rawData';
clusterLabel=rawfeatureName';

%%
dist_h='spearman';
link='weighted';
Z = linkage(clusterData,link,dist_h);
Z3 = transz(Z);Z3(:,3) = 1-Z3(:,3);
numClust=sum(Z3(:,3)<0.8)+1;% intra-cluster correlation |r| >=0.8

figure()
[H,T,OUTPERM] = dendrogram(Z,numClust,'Orientation','left','labels',clusterLabel);%use find(T==k)
%% output: Extended Data Table 2 CeTh-activity feature clusters and associated features
tab=crosstab(T,clusterLabel);
clusterCenter = zeros(length(OUTPERM),size(clusterData,2));
clusterCenterLabel2 = cell(size(tab,1),1);
clusterCenterLabel3 = cell(size(tab,1),1);

Z2 = transz(Z);
innerClusterMinR=1;
for i =1:numClust
   idx = find(tab(i,:)==1);
   fprintf('Cluster %d_',i);
   clusterCenterLabel{i} = cell(length(idx),1);
   for j =1:length(idx)
        fprintf('%s_',clusterLabel{idx(j)});
        clusterCenter(i,:) = clusterCenter(i,:)+clusterData(idx(j),:);
        clusterCenterLabel{i}{j} = clusterLabel{idx(j)};
   end
   clusterCenter(i,:) = clusterCenter(i,:)/length(idx);
   fprintf('\b\n');     
   if length(idx)==1
       clusterCenterLabel2{i} = clusterCenterLabel{i}{1};
       clusterCenterLabel3{i} = ['cluster ',num2str(i)];
   else
       clusterCenterLabel2{i} = ['cluster ',num2str(i)];
       clusterCenterLabel3{i} = ['cluster ',num2str(i)];

   end
   for j =length(Z2):-1:1
      if find(Z2(j,1)==idx) & find(Z2(j,2)==idx)
          lastClusteringid =j;
          break
      end
   end
   RHO = 1-Z2(lastClusteringid,3);
   
   if RHO<innerClusterMinR
        innerClusterMinR=RHO;
   end
end
fprintf('the minimum |r| in all clusters is %f.\n',innerClusterMinR);

%% output: Extended Data Fig. 2d
set(H,'LineWidth',2);
xlabel('R value')
tempy = yticklabels;
for i =1:numClust
    if str2num(tempy{i})
        tempy{i} = ['Cluster ' tempy{i}];
    else
        tempy{i} =['Cluster ', num2str(find(strcmp(tempy{i},clusterCenterLabel2))) ];
    end          
end
yticklabels(tempy)
xticks(0.2:0.1:1)
xticklabels({'0.8','0.7','0.6','0.5','0.4','0.3','0.2','0.1','0'})
orient(gcf,'landscape')
title('Step1: Hierarchical Clustering for All CeTh features')



save('step2_sampleData.mat','clusterCenter','clusterCenterLabel2','clusterCenterLabel3','labels');