function Name1=changingfeatureName(Name0)
Name1= Name0;

for i =1:length(Name0)
    if strfind(Name0{i},'powerRawSMUA')
        Name1{i} = ['MUApower(raw)' Name0{i}(13:end)];
    end
    if strfind(Name0{i},'powerNormSMUA')
        Name1{i} = ['MUApower' Name0{i}(14:end)];
    end   
    if strfind(Name0{i},'stabilitySMUA')
        Name1{i} = ['MUAstability' Name0{i}(14:end)];
    end  

    if strfind(Name0{i},'syncMUA')
        Name1{i} = ['syncMUA' Name0{i}(8:end)];
    end      

    if strfind(Name0{i},'meanSMUA')
        Name1{i} ='MUAmean';
    elseif strfind(Name0{i},'stabilityFR')
        Name1{i} ='FringRatesstability';   
    elseif strfind(Name0{i},'FR')
        Name1{i} ='FiringRates';   
    end

    idx = strfind(Name0{i},'-');%Remove '-' from 'cluster-i'
    if idx
        Name1{i} = [Name0{i}(1:idx-1) ' ' Name0{i}(idx+1:end)];
    end    


 end

end