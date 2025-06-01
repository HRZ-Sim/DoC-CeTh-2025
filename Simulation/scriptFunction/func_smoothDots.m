function smoothedY=func_smoothDots(y)


if length(y)==17
    windowSize = 5; 
    sigma = 1.2;  
elseif length(y)==9

elseif length(y)==8

end

gaussFilter = fspecial('gaussian', [windowSize, 1], sigma);
gaussFilter = gaussFilter / sum(gaussFilter); 

halfwin = floor(windowSize / 2);
replicatedY = [repmat(y(1), halfwin,1); y; repmat(y(end), halfwin,1)];


fullConv = conv(replicatedY, gaussFilter, 'same'); 
smoothedY = fullConv(halfwin+1:end-halfwin);
end