function [ Peaks ] = FindPeaksDC(plotnumber,nPeaks,...
                                    plothandlerMatrix,Graphnumber )
%This function will find the n largest peaks for the Dynamic 
% Conductance graph. 
% It returns a cell with n*(number of plots per graph) +1 lines and 
% 3 columns with the legend,value and position of the peak   


% get handler corresponding to the first graph

%Graphnumber = 2;

HandlerPlots = get(plothandlerMatrix(Graphnumber,plotnumber),'Children');

% to get the Data corresponding to each of the plot in the graph

allYData = get(HandlerPlots,'YData');
allXData = get(HandlerPlots,'XData');

% get the legend associated with each plot

allLegend = get(HandlerPlots,'DisplayName');

% To store the peaks, n peaks per plot

%nPeaks = 2;

Peaks = cell((size(allYData,1)*nPeaks+1),3);

Peaks{1,1} = 'Legend Name';
Peaks{1,2} = 'Peak Value';
Peaks{1,3} = 'Peak Position';

savepos = 2;

for nplot = 1:size(allYData,1)

    % find the peaks and their positions in the matrix
    [peaks,loc] = findpeaks(allYData{nplot,1});
    
    currentXData = allXData{nplot,1};
    
    % the highest value will be the last one

    peakstosort = peaks;
    
    sortedPeaks = sort(peakstosort);
    
    % get the highest n values and their position 
    
    for npeak = 1:nPeaks
    
        peakvalue = sortedPeaks(size(peaks,2)-(npeak-1));
        
        % store value
        Peaks{savepos,2} = peakvalue;
        
        peakindexinPeaks = find(peaks == peakvalue);
        
        peakindexinXdata = loc(peakindexinPeaks);
        
        peakomega = currentXData(peakindexinXdata);
        
        % store position
        Peaks{savepos,3} = peakomega;
        
        % store name
        
        Peaks{savepos,1} = allLegend{nplot,1};
        
        savepos = savepos +1;
        
    end
    
end

end

