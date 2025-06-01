function MacroRecallF1=F1score(labels,Prediction)

n = length(unique(labels));
onehot_labels = full(ind2vec(labels',n));
onehot_Prediction = full(ind2vec(Prediction',n));

[a,b] = confusion(onehot_labels,onehot_Prediction);b=b'; %acc : 1-a;  

classNum=2;
TP = zeros(classNum,1);
FN = zeros(classNum,1);
FP = zeros(classNum,1);
Prescion = zeros(classNum,1);
Recall = zeros(classNum,1);
for classi = 1:classNum
    TP(classi) = b(classi,classi);
    for i = 1:classNum
        if i==classi
            continue
        end
        FP(classi) = FP(classi)+b(classi,i);
        FN(classi) = FN(classi)+b(i,classi);
    end
    Prescion(classi) =TP(classi) / (TP(classi) +FP(classi)) ;
    Recall(classi) =TP(classi) / (TP(classi) +FN(classi)) ;
end

    MacroPrescion = Prescion(1);
    MacroRecall = Recall(1);
MacroRecallF1 = 2* MacroPrescion*MacroRecall/(MacroPrescion+MacroRecall);