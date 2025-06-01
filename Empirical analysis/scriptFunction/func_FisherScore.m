function featuresRank =  func_FisherScore(x,label,featuresName)
% x:features
classNum = length(unique(label));
Jk = cell(size(x,2),2);
Jk(:,1) = featuresName;
n = length(label);
for k = 1:size(x,2) 
    Sbk = zeros(classNum,1);
    Swk = zeros(classNum,1);
    
    mk = mean(x(:, k),1);
    labeli = cell(classNum, 1);
    ni = zeros(classNum, 1);

    for i =1:classNum
        labeli{i} =find(label==i);
        ni(i) = length(labeli{i} );
    end
    for i = 1:classNum  
        mik = mean(x(labeli{i}, k));
        Sbk(i) = ni(i)/n*(mik-mk)^2;
        for j =1:ni(i)
            Swk(i,j) = 1/n* (x(labeli{i}(j),k)-mik)^2;
        end
    end
    Jk(k,2) = {sum(Sbk)/ sum(sum(Swk))};
end
temp = cell2mat(Jk(:,2));
[~, ind] = sort(temp,'descend');

featuresRank = Jk(ind,:);