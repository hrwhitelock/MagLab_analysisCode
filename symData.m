% function to symmetrize data
% hope
% Oct 24, 2024

function [symX, symY] = symData(x,y, negXlim, posXlim)
    numpoints = round(length(x),-1) +1; % we're rounding to the nearest 10 and adding 1 to make an odd number of points
    interpX = linspace(negXlim,posXlim,numpoints); 
    interpY = interp1(x, y, interpX);
%     figure; 
%     plot(interpX, interpY)
    
    % okay, so now we do antisym for nernst
    % want to start at 0
    j =1;
    for posidx = (numpoints-1)/2+1:numpoints
        negidx =findNearest(interpX, -1*interpX(posidx));
        symY(j) = (interpY(posidx)+interpY(negidx))/2;
        symX(j) = interpX(posidx);
        j = j+1; 
    end
    
%     figure; hold on; grid on; 
%     plot(antiSymX, antiSymY); 
    
end