function [FR,thetaNorm,stabilityTheta,transData] = func_simulating(Task,restVect,Ndeaffre,EXCpercent,N,dt,t_end,CRX_fr,W,rhythmPercent)

% IFB4_1Loop_clean48

t_vect = 0:dt:t_end;
lenT = length(t_vect);
V_th = [-35,-35,-35];                      
V_reset = [-50,-50,-50];  
V_spike=[30,30,30];
E_exc = [0,0,0];
E_inh = [-85,-85,-85];

%% CRX input
C = 2;      
tau_s_exc_fromCRX = [10,7,7];
delay_fromCRX = [7 0 0]/dt;

%% leak current
V_L = [restVect,restVect,restVect];                                            
g_L =1.1*[0.035,0.035,0.035];

%% calcium LTS
% Two conditions for the release of LTS: 
% 1) V >= V_h (activation gate open);  
% 2) h has accumulated > 0 (corresponds to the inactivation gate being open: allows for keeping it open temporarily).
V_h = [-64,-66,-66]; 
tau_h_minus = [40,20,20];  % ms The higher the number, the longer the LTS effect lasts. The calcium channels in the TRN deactivate slowly, resulting in more bursts
tau_h_plus = [100,100,100];% ms The higher the number, the faster the accumulation rate
V_T= [120,120,120];
g_T = [0.07 0.07 0.07];
I_T=zeros(3,100,lenT); 

%% intra-thalamus
tau_s_exc_toTRN = 20;%   The higher the number, the longer the excitement lasts.
tau_s_inh_fromTRN =30;%   The higher the number, the longer the inhibition lasts.                 
delay_intrathalamus = 3/dt;

%% initialization
I_total=zeros(3,100,lenT);%TRN¡¢CT¡¢SR
I_input=zeros(3,100,lenT);
I_L=zeros(3,100,lenT);
neuron_fr= false(3,100,lenT);

V_vect =zeros(3,100,lenT);
V_vect(1,:,1)=  V_L(1);V_vect(2,:,1)= V_L(2);  V_vect(3,:,1)= V_L(3); 
V_plot_vect = zeros(3,100,lenT);
V_plot_vect(1,:,1)= V_L(1);  V_plot_vect(2,:,1)= V_L(2);  V_plot_vect(3,:,1)= V_L(3); 
% All state values in the model were initialized to a value of 0
h_vect = zeros(3,100,lenT);
%h, represents the inactivation of the low-threshold Ca2+ conductance£» h=1:Ca2+ de-inactivation
h_vect(1,:,1) = 0; h_vect(2,:,1) = 0; h_vect(3,:,1) = 0;

%% Input-TRN; 
g_S_input(1,1) = 0.01; %    CRXinput to TRN (0.01)
W_Input2TRN = zeros(100,lenT);
g_S_Input2TRN = zeros(100,lenT);
%% CeTh-TRN; SR-TRN
g_S_input(1,2) = 0.01;% CeTh to TRN                             
W_CTtoTRN = zeros(100,100,lenT);
g_S_allCT2TRN=zeros(100,lenT);

g_S_input(1,3) = 0.02; % SR to TRN           
W_SRtoTRN = zeros(100,lenT);
g_S_SR2TRN=zeros(100,lenT);

%% Input-CeTh;
g_S_input(2,1) = 0.0078;% CRXinput to CeTh
W_Input2CT = zeros(100,lenT);
g_S_Input2CT = zeros(100,lenT);
%% TRN-CeTh
g_S_input(2,2) = 0.03;% TRN to CeTh                             
W_TRNtoCT = zeros(100,100,lenT);
g_S_allTRN2CT = zeros(100,lenT);

%%  Input-SR
g_S_input(3,1) = 0.0078;% CRXinput to SR 
W_Input2SR= zeros(100,lenT);
g_S_Input2SR= zeros(100,lenT);
%% TRN-SR
g_S_input(3,2) = 0.02;% TRN to SR             
W_TRN2SR = zeros(100,lenT);
g_S_TRN2SR = zeros(100,lenT);


%% Begin Updating
i=1;
for t=dt:dt:t_end   
for type = 1:3%TRN\CeTh\SR
for neuronIdx=1:100 
%% I_input
    switch type
        case 1                           
            if  i+delay_fromCRX(1)<=lenT % CRX to TRN       
                if CRX_fr{1}(neuronIdx,i)==1
                     W_Input2TRN(neuronIdx,i+delay_fromCRX(1) )= 1;    
                end
            end          
            if i+delay_intrathalamus<=lenT % CeTh to TRN     
                if neuron_fr(2,1:100,i) * W{1,2}(1:100,neuronIdx) >=1  
                    W_CTtoTRN(1:100,neuronIdx,i + delay_intrathalamus)= neuron_fr(2,1:100,i)' .* W{1,2}(1:100,neuronIdx);
                end
                if neuron_fr(3,neuronIdx,i) ==1 % SR to TRN            
                     W_SRtoTRN(neuronIdx,i + delay_intrathalamus)= 1;                   
                end
            end
            if W_Input2TRN(neuronIdx,i) ==1
                    g_S_Input2TRN(neuronIdx,i)= g_S_Input2TRN(neuronIdx,i)+ g_S_input(1,1);                
            end
            
            if sum(W_CTtoTRN(1:100,neuronIdx,i) ) >0
                    g_S_allCT2TRN(neuronIdx,i)= g_S_allCT2TRN(neuronIdx,i)+ sum(W_CTtoTRN(1:100,neuronIdx,i)) * g_S_input(1,2);
            end
            if W_SRtoTRN(neuronIdx,i) ==1
                    g_S_SR2TRN(neuronIdx,i)= g_S_SR2TRN(neuronIdx,i)+ g_S_input(1,3);                
            end
            
             if i~=lenT % prepare [i+1] g_S
                    g_S_Input2TRN(neuronIdx,i+1)=  g_S_Input2TRN(neuronIdx,i) +dt*( -g_S_Input2TRN(neuronIdx,i) / tau_s_exc_fromCRX(1) );
                    g_S_allCT2TRN(neuronIdx,i+1)=  g_S_allCT2TRN(neuronIdx,i) +dt*( -g_S_allCT2TRN(neuronIdx,i) / tau_s_exc_toTRN ) ;
                    g_S_SR2TRN(neuronIdx,i+1)=     g_S_SR2TRN(neuronIdx,i) +dt*( -g_S_SR2TRN(neuronIdx,i) / tau_s_exc_toTRN ) ;
             end                        
            % »ã×ÜTRN
            I_input(1,neuronIdx,i) = (E_exc(1) - V_vect(1,neuronIdx,i) ) * ...
            (  g_S_Input2TRN(neuronIdx,i) + g_S_allCT2TRN(neuronIdx,i) +g_S_SR2TRN(neuronIdx,i)   ) ;
        
        
        case 2           
%% CRX-CeTh, TRN-CeTh             
            if	i+delay_fromCRX(2)<=lenT && CRX_fr{2}(neuronIdx,i) ==1 % CRX to CeTh 
                W_Input2CT(neuronIdx,i + delay_fromCRX(2))= 1;
            end
            
            if i+delay_intrathalamus<=lenT && neuron_fr(1,1:100,i) * W{2,2}(1:100,neuronIdx) >=1 % TRN to CeTh   
                W_TRNtoCT(1:100,neuronIdx,i + delay_intrathalamus)= neuron_fr(1,1:100,i)' .* W{2,2}(1:100,neuronIdx);
            end                   
            if W_Input2CT(neuronIdx,i) ==1
                    g_S_Input2CT(neuronIdx,i)= g_S_Input2CT(neuronIdx,i)+  g_S_input(2,1);                
            end                      
             if sum(W_TRNtoCT(1:100,neuronIdx,i) ) >0
                    g_S_allTRN2CT(neuronIdx,i)= g_S_allTRN2CT(neuronIdx,i)+ sum(W_TRNtoCT(1:100,neuronIdx,i)) * g_S_input(2,2);
            end
            
            if	i~=lenT% prepare [i+1] g_S
                g_S_Input2CT(neuronIdx,i+1)=  g_S_Input2CT(neuronIdx,i) +dt*( -g_S_Input2CT(neuronIdx,i) / tau_s_exc_fromCRX(2) );
                g_S_allTRN2CT(neuronIdx,i+1)= g_S_allTRN2CT(neuronIdx,i) +dt*( -g_S_allTRN2CT(neuronIdx,i) / tau_s_inh_fromTRN );
            end       

                I_input(2,neuronIdx,i) = (E_exc(2) - V_vect(2,neuronIdx,i) )* g_S_Input2CT(neuronIdx,i) ...
       + (E_inh(2) - V_vect(2,neuronIdx,i) )*g_S_allTRN2CT(neuronIdx,i);
   
  
        case 3     
%% CRX-SR, TRN-SR           
            if	i+delay_fromCRX(3)<=lenT && CRX_fr{3}(neuronIdx,i) ==1 % CRX to SR   
            	W_Input2SR(neuronIdx,i + delay_fromCRX(3))= 1;                
            end
            if	i+delay_intrathalamus<=lenT && neuron_fr(1,neuronIdx,i)==1% TRN to SR   
                     W_TRN2SR(neuronIdx,i + delay_intrathalamus)= 1;              
            end
            if W_Input2SR(neuronIdx,i) ==1
                    g_S_Input2SR(neuronIdx,i)= g_S_Input2SR(neuronIdx,i)+  g_S_input(3,1);               
            end                 
            if W_TRN2SR(neuronIdx,i) ==1
                    g_S_TRN2SR(neuronIdx,i)= g_S_TRN2SR(neuronIdx,i)+ g_S_input(3,2);                
            end
            
            if i~=lenT% prepare [i+1] g_S
                    g_S_Input2SR(neuronIdx,i+1)=  g_S_Input2SR(neuronIdx,i) +dt*( -g_S_Input2SR(neuronIdx,i) / tau_s_exc_fromCRX(3) );
                    g_S_TRN2SR(neuronIdx,i+1)=  g_S_TRN2SR(neuronIdx,i) +dt*( -g_S_TRN2SR(neuronIdx,i) / tau_s_inh_fromTRN ) ;  
            end

                I_input(3,neuronIdx,i) = (E_exc(3) - V_vect(3,neuronIdx,i) )* g_S_Input2SR(neuronIdx,i) ...
       + (E_inh(3) - V_vect(3,neuronIdx,i) )*g_S_TRN2SR(neuronIdx,i);
    end  
    % [i] I_Leak
    I_L(type,neuronIdx,i) = g_L(type) * (V_vect(type,neuronIdx,i) - V_L(type));   
    % I_T channel Calcium
    if  V_vect(type,neuronIdx,i) >= V_h(type)
        m= 1;
        % prepare [i+1] h
        h_vect(type,neuronIdx,i+1) =h_vect(type,neuronIdx,i) - dt * h_vect(type,neuronIdx,i) / tau_h_minus(type);
    else 
        m=0;
        h_vect(type,neuronIdx,i+1) =h_vect(type,neuronIdx,i) + dt * (1-h_vect(type,neuronIdx,i)) / tau_h_plus(type);
    end   
    % [i]: I_T
    I_T(type,neuronIdx,i) = g_T(type) * m * h_vect(type,neuronIdx,i) * (V_vect(type,neuronIdx,i) - V_T(type));   
	% [i]: I_total 
    I_total(type,neuronIdx,i)= I_input(type,neuronIdx,i) - I_L(type,neuronIdx,i) - I_T(type,neuronIdx,i); 
    % [i+1]: V_vect
    V_vect(type,neuronIdx,i+1) = V_vect(type,neuronIdx,i) + dt/ C *I_total(type,neuronIdx,i);           
	if (V_vect(type,neuronIdx,i+1) >= V_th(type))        
        V_vect(type,neuronIdx,i+1) = V_reset(type); 
        V_plot_vect(type,neuronIdx,i+1) = V_spike(type); 
        neuron_fr(type,neuronIdx,i+1) = true;
	else 
        V_plot_vect(type,neuronIdx,i+1) = V_vect(type,neuronIdx,i+1); 
	end
    
end%end neuronIdx
end%endtype
if mod(i,1000)==0%each 1s
fprintf('%ds\t',floor(i/1000));
end
i = i+1; 
end



%% plot preparation
CM_TRNcollect=[64,0,75
118,42,131
153,112,171
194,165,207
231,212,232]/255;
CM_CTcollect=[84,48,5
140,81,10
191,129,45
223,194,125
246,232,195]/255;
CM_SRcollect=[0,60,48
1,102,94    
53,151,143
128,205,193
199,234,229]/255;

CM_TRN=CM_TRNcollect(4,:);
CM_CT=CM_CTcollect(4,:);
CM_SR=CM_SRcollect(4,:);
colorGrey=[0.5 0.5 0.5];

%%
if Task==1
        deaffreStart=5001;
end
figure
subplot(3,1,1)
hold on 
for neuronIdx = 1:N
    spikePos = t_vect(neuron_fr(1,neuronIdx, :));
    for spikeCount = 1:length(spikePos)
plot(spikePos(spikeCount),neuronIdx,'o','LineStyle','none','MarkerEdgeColor',CM_TRN,...
        'MarkerFaceColor',CM_TRN,'MarkerSize',1.5);        
    end
end
axis([deaffreStart-1 t_end+1 0 N+1])
clear xticks;xticks(5000:1000:t_end);
xticklabels({'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'});
xlabel('Time (s)')
ylabel('NeuroIdx')
title('TRN')
ylabel('Spike events');

subplot(3,1,2)
hold on
for neuronIdx = 1:N
    spikePos = t_vect(neuron_fr(2,neuronIdx, :));
    IDXbaseline = find(spikePos<deaffreStart);
    if length(IDXbaseline)==0
        IDXbaseline=0;    
    else
        IDXbaseline=IDXbaseline(end);
        for spikeCount = 1:IDXbaseline
            plot(spikePos(spikeCount),neuronIdx,'o','LineStyle','none','MarkerEdgeColor',CM_CT,...
                    'MarkerFaceColor',CM_CT,'MarkerSize',1.5);
        end     
    end

        for spikeCount = IDXbaseline+1:length(spikePos)
            plot(spikePos(spikeCount),neuronIdx,'o','LineStyle','none','MarkerEdgeColor',CM_CT,...
                    'MarkerFaceColor',CM_CT,'MarkerSize',1.5);                 
        end
end
if Ndeaffre>0
    tRange=0:t_end;
    plot(tRange,(Ndeaffre+0.5)*ones(length(tRange),1),'--','Color',colorGrey,'LineWidth',2)    
end
axis([deaffreStart-1 t_end+1 0 N+1])
clear xticks;xticks(5000:1000:t_end);
xticklabels({'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'});
xlabel('Time (s)')
ylabel('NeuroIdx')
title('CeTh')

if Task==5||Task==6
        deaffreStart=5001;
    yy = 0:0.1:Ndeaffre;
    plot(deaffreStart*ones(length(yy),1),yy,':r','LineWidth',1.5)
    yy2 = deaffreStart:10:t_end;
        plot(yy2,Ndeaffre*ones(length(yy2),1),':r','LineWidth',1.5)
end

subplot(3,1,3)
hold on
for neuronIdx = 1:N
    spikePos = t_vect(neuron_fr(3,neuronIdx, :));
    IDXbaseline = find(spikePos<deaffreStart);
    if length(IDXbaseline)==0
        IDXbaseline=0;
    else
        IDXbaseline=IDXbaseline(end);
        for spikeCount = 1:IDXbaseline  
            plot(spikePos(spikeCount),neuronIdx,'o','LineStyle','none','MarkerEdgeColor',CM_SR,...
                    'MarkerFaceColor',CM_SR,'MarkerSize',1.5);                
        end
    end

        for spikeCount = IDXbaseline+1:length(spikePos)
            plot(spikePos(spikeCount),neuronIdx,'o','LineStyle','none','MarkerEdgeColor',CM_SR,...
                    'MarkerFaceColor',CM_SR,'MarkerSize',1.5);                     
        end
end
if Ndeaffre>0
    tRange=0:t_end;
    plot(tRange,(Ndeaffre+0.5)*ones(length(tRange),1),'--','Color',colorGrey,'LineWidth',2)    
end
axis([deaffreStart-1 t_end+1 0 N+1])
clear xticks;xticks(5000:1000:t_end);
xticklabels({'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'});
xlabel('Time (s)')
ylabel('NeuroIdx')
title('SR')
ylabel('Spike events');
if Task==5||Task==6
        deaffreStart=5001;
    yy = 0:0.1:Ndeaffre;
    plot(deaffreStart*ones(length(yy),1),yy,':r','LineWidth',1.5)
    yy2 = deaffreStart:10:t_end;
        plot(yy2,Ndeaffre*ones(length(yy2),1),':r','LineWidth',1.5)
end

%%  bin for FR
binSize =10;%10ms
neuron_frData = squeeze(neuron_fr(2,:,:));
neuron_fr_CT = [zeros(100,binSize/2) neuron_frData zeros(100,binSize/2)];

aveBin=zeros(1,length(t_vect));
for i=binSize/2+1:length(neuron_fr_CT)-(binSize/2)
        aveBin(i-binSize/2)=sum(sum(neuron_fr_CT(:,i-binSize/2:i+binSize/2))) / (binSize+1);
end


if Task==1
    deaffreStart=5001;
    if restVect == -67
        sgtitle('deafferented LTB sample')    
    elseif restVect== -65
        sgtitle('normal tonic sample')    
    end
    stabilityTheta = NaN;FR = NaN;thetaNorm=NaN;
%% Fig. 4: Network simulation of neural dynamics underlying theta rhythms in CeTh
%    subfig(d and g)
% Extended Data Fig. 7: Raster plots for tonic and bursting regimes in thalamic neurons

    if restVect==-67 % LTB sample 
        neuronIdxC2=[19 14 1 27 5];
        neuronIdxC1=[22 27 7 6 29];
        tRange=9001:10000;
    
        figure
        subplot(2,1,1)
        hold on    
        y=squeeze(V_plot_vect(2,neuronIdxC2,tRange));
        arrayfun(@(i) plot(tRange, y(i,:), 'Color',CM_CTcollect(i,:), 'LineWidth', 2), 1:size(y, 1));
        hold off
        ylim([-80 35])
        subplot(2,1,2)
        xx = 9100:9500;
        plot(xx,squeeze(V_plot_vect(2,neuronIdxC2(4),xx)),'Color',CM_CT, 'LineWidth', 2)
        hold on
        plot(xx,V_h(2)*ones(length(xx),1),'--','Color',CM_CTcollect(2,:),'LineWidth',2)
        plot(xx,V_th(2)*ones(length(xx),1),'--','Color',colorGrey,'LineWidth',2)        
        ylim([-80 35])
    
        figure
        subplot(2,1,1)
        hold on    
        y=squeeze(V_plot_vect(1,neuronIdxC1,tRange));
        arrayfun(@(i) plot(tRange, y(i,:), 'Color',CM_TRNcollect(i,:), 'LineWidth', 2), 1:size(y, 1));
        hold off
        ylim([-80 35])    
        subplot(2,1,2)
        xx = 9000:9500;
        plot(xx,squeeze(V_plot_vect(1,neuronIdxC1(4),xx)),'Color',CM_TRN, 'LineWidth', 2)
        hold on
        plot(xx,V_h(1)*ones(length(xx),1),'--','Color',CM_TRNcollect(2,:),'LineWidth',2)
        plot(xx,V_th(1)*ones(length(xx),1),'--','Color',colorGrey,'LineWidth',2)        
        ylim([-80 35])    
    
    else % tonic
        neuronIdxC2=[1 7 8 13 24];
        neuronIdxC1=[1 6 7 15 27];
        tRange=9001:10000;
    
        figure
        subplot(2,1,1)
        hold on    
        y=squeeze(V_plot_vect(2,neuronIdxC2,tRange));
        arrayfun(@(i) plot(tRange, y(i,:), 'Color',CM_CTcollect(i,:), 'LineWidth', 2), 1:size(y, 1));
        hold off
        ylim([-80 35])
        subplot(2,1,2)
        xx = 9100:9500;
        plot(xx,squeeze(V_plot_vect(2,neuronIdxC2(1),xx)),'Color',CM_CT, 'LineWidth', 2)
        hold on
        plot(xx,V_h(2)*ones(length(xx),1),'--','Color',CM_CTcollect(2,:),'LineWidth',2, 'LineWidth', 2)
        plot(xx,V_th(2)*ones(length(xx),1),'--','Color',colorGrey,'LineWidth',2, 'LineWidth', 2)
        ylim([-80 35])
    
        figure
        subplot(2,1,1)
        hold on    
        y=squeeze(V_plot_vect(1,neuronIdxC1,tRange));
        arrayfun(@(i) plot(tRange, y(i,:), 'Color',CM_TRNcollect(i,:), 'LineWidth', 2), 1:size(y, 1));
        hold off
        ylim([-80 35])    
        subplot(2,1,2)
        xx = 9100:9500;
        plot(xx,squeeze(V_plot_vect(1,neuronIdxC1(3),xx)),'Color',CM_TRN,'LineWidth',2)
        hold on
        plot(xx,V_h(1)*ones(length(xx),1),'--','Color',CM_TRNcollect(2,:),'LineWidth',2)
        plot(xx,V_th(1)*ones(length(xx),1),'--','Color',colorGrey,'LineWidth',2)
        ylim([-80 35])    
    end  



elseif Task==2 || Task==3
    if Task==2
        deaffreStart = 8000;
        subplot(4,1,4)      
        bar(0:length(t_vect)-1,aveBin);
        hold on
        yy = 0:0.1:max(aveBin);
        plot(deaffreStart*ones(length(yy),1),yy,':')
        axis([0 t_end/dt -inf inf])
        title('PSTH')
    elseif Task==3
        deaffreStart = 8000;
        subplot(4,1,4)              
        bar(0:length(t_vect)-1,aveBin);
        hold on
        yy = 0:0.1:max(aveBin);
        plot(deaffreStart*ones(length(yy),1),yy,':')
        axis([0 t_end/dt -inf inf])
        title('PSTH')    
    end

    FR = mean(   mean(neuron_fr(2,:,deaffreStart:end),3)  *(1000/dt) )   ;% CeTh FR:    spk/neuron/s 
    CTsignal = mean(squeeze(V_vect(2,:,:)),1);% CeTh
    eeg_data = CTsignal(deaffreStart:end);
    sampleRate=1000;%1kHz same as the empirical data
    figName=['CeTh PSD ',', restVect=',num2str(restVect),'mV, Ndeaffre=',num2str(Ndeaffre), 'EXCpercent=',num2str(EXCpercent)];
    power_features = ExtractPowerSpectralFeature(4,8,eeg_data, sampleRate,figName);
    thetaNorm = power_features(2) /  power_features(8) * 100;% same to the pow-¦È in the empirical study

    sampleRate = 1000;
    movstdSize= 1;%0.2s
    stabilityVect = zeros(1,7);
    envelope = abs(hilbert(real(eeg_data)));
    movstdData{1,1} =  movstd(envelope,sampleRate*movstdSize,'Endpoints','discard');% envelope of the data
    for f=2 %only for [4-8Hz] here
        [BL,AL] = butter(2,[4 8]/(sampleRate/2));
        tdata=filtfilt(BL, AL, eeg_data);
        tenvelope = abs(hilbert(real(tdata)));
        movstdData{1,f+1} =movstd(tenvelope,sampleRate*movstdSize,'Endpoints','discard');     

        movstd_CV = std(movstdData{1,f+1}) / mean(movstdData{1,f+1});    
        stabilityVect(f+1) = 1/movstd_CV;   % same to the stab-¦È in the empirical study
        saveDataVect = {eeg_data,tdata,tenvelope,movstdData{1,f+1},stabilityVect(f+1) };
    end
    stabilityTheta = stabilityVect(3);
    transData = saveDataVect;


elseif Task ==4 || Task==6
    deaffreStart=8000;
    subplot(4,1,4)          
    bar(0:length(t_vect)-1,aveBin);
    hold on
    yy = 0:0.1:max(aveBin);
    plot(deaffreStart*ones(length(yy),1),yy,':')
    xlabel('Time (ms)');
    ylabel('Spike counts');
    axis([0 t_end/dt -inf inf])
    title('PSTH')

    CTsignal = mean(squeeze(V_vect(2,:,:)),1);
    eeg_data = CTsignal(deaffreStart:end);
    sampleRate = 1000;%1kHz same as the empirical data
    figName=['CeTh PSD _','rhythmPercent',num2str(rhythmPercent)];
    power_features = ExtractPowerSpectralFeature(4,8,eeg_data, sampleRate,figName);
    thetaNorm = power_features(2) /  power_features(8) * 100;% same to the pow-¦È in the empirical study
    
    movstdSize= 1;%0.2s
    stabilityVect = zeros(1,7);
    envelope = abs(hilbert(real(eeg_data)));
    movstdData{1,1} =  movstd(envelope,sampleRate*movstdSize,'Endpoints','discard');% envelope of the data
    for f=2
        [BL,AL] = butter(2,[4 8]/(sampleRate/2));
        tdata=filtfilt(BL, AL, eeg_data);
        tenvelope = abs(hilbert(real(tdata)));
        movstdData{1,f+1} =movstd(tenvelope,sampleRate*movstdSize,'Endpoints','discard');     
        
        movstd_CV = std(movstdData{1,f+1}) / mean(movstdData{1,f+1});    
        stabilityVect(f+1) = 1/movstd_CV;   % same to the stab-¦È in the empirical study
        saveDataVect = {eeg_data,tdata,tenvelope,movstdData{1,f+1},stabilityVect(f+1) };
    end
    %theta band activity
    stabilityTheta = stabilityVect(3)
    % FR = NaN;
    FR = mean(   mean(neuron_fr(2,:,deaffreStart:end),3)  *(1000/dt) )   ;
    transData = saveDataVect;
        
elseif Task ==5
    deaffreStart = 8000;

    subplot(4,1,4)        
    bar(0:length(t_vect)-1,aveBin);
    hold on
    yy = 0:0.1:max(aveBin);
    plot(deaffreStart*ones(length(yy),1),yy,':')
    xlabel('Time (ms)');
    ylabel('Spike counts');%Voltage in mV    
    axis([0 t_end/dt -inf inf])
    title('PSTH')


CTsignal = mean(squeeze(V_vect(2,:,:)),1);% CeTh
eeg_data = CTsignal(deaffreStart:end);
FR =  NaN;
thetaNorm=NaN;stabilityTheta=NaN;
transData = eeg_data;
end


end 