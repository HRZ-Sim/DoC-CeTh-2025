function List2=nameUpdate(List)
    List2=cell(size(List));
    for i=1:length(List)
    
if strcmp(List{i},'MUAstabilityTheta')
    List2{i} = 'stab-θ';
elseif strcmp(List{i},'syncMUAGamma')
    List2{i} = 'sync-γ';
elseif strcmp(List{i},'MUApowerTheta')
    List2{i} = 'pow-θ';
elseif strcmp(List{i},'MUApowerAlpha')
    List2{i} = 'pow-α';
elseif strcmp(List{i},'FiringRates')
    List2{i} = 'FiringRates';
elseif strcmp(List{i},'MUAstabilityHGamma')
    List2{i} = 'stab-hγ';
end
    
    end
end