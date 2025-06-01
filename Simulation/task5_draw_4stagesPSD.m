
clc
clear
roundTotal=100;

%% Stage I II III IIII
% param=[-67,90,0; -67,30,0; -67,30,0.04; -65,0,0];

levelNeed = [1 2 3 6];% get correponding files
Table5_eeg=cell(length(levelNeed),1);
for level =1:length(levelNeed)
    Table5_eeg{level} =zeros(roundTotal,7002);
end
for roundI = 1:roundTotal        
    load(['./Task5/Task5_roundI',num2str(roundI),'.mat']);
    for level = 1:length(levelNeed)
        Table5_eeg{level}(roundI,:)= eeg_dataCollect{levelNeed(level)};
    end
end


srate= 1000;
L=2000;    
noverlap = fix(0.5.*L);

colorR = [0 103 180
1,146,255
235 124 19.5
169 209 142
]./255;
colorB = [50 50 50
70,70,70
90,90,90
110,110,110
]./255;% 

freq1 = 4;
freq2 = 8;

%%
p = cell(length(levelNeed),1);
figure()
for level=1:length(levelNeed)
    dbb = zeros(roundTotal, (srate/2)*2+1);
    for i = 1:roundTotal
        eeg_data = Table5_eeg{level}(i,:);
        [pxx, f] = pwelch(eeg_data,L,noverlap, srate*2, srate);
        dbb(i,:) = pow2db(pxx);
    end
    psd_mean = mean(dbb, 1);
    psd_std = std(dbb, 1, 1);

    idx2 = find(f>=0.5&f<=80);
    fill([f(idx2); flipud(f(idx2))], [psd_mean(idx2)+psd_std(idx2), fliplr(psd_mean(idx2)-psd_std(idx2))]', [0.9 0.9 0.9], 'linestyle', 'none'); % 绘制灰色误差范围
    hold on

    plot(f(idx2),psd_mean(idx2),'Color',colorB(level,:),'linewidth',4);  
    idx1 = find(f>=freq1&f<=freq2);
    p{level} = plot(f(idx1),psd_mean(idx1),'Color',colorR(level,:),'linewidth',4);  
end

legend([p{1} p{2} p{3} p{4}],'stage I','stage II','stage III','stage IV')
axis([0 80 -inf inf])
grid  
h =title('PSD with four consciouness stages');
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')    
set(h,'FontSize',12,'FontWeight','normal')
