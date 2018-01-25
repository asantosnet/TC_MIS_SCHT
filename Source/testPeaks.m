


% get handler corresponding to the first graph

pos = 2;

HandlerPlots = get(plothandlerMatrix(pos),'Children');

% to get the Data corresponding to each of the plot in the graph

allYData = get(HandlerPlots,'YData');
allXData = get(HandlerPlots,'XData');

% get the legend associated with each plot

allLegend = get(HandlerPlots,'DisplayName');

% To store the peaks, n peaks per plot

n = 2;

Peaks = cell((size(allYData,1)*2+1),3);

Peaks{1,1} = 'Legend Name';
Peaks{1,2} = 'Peak Value';
Peaks{1,3} = 'Peak Position';

for tt = 1:size(allYData,1)

    % find the peaks and their positions in the matrix
    [peaks,locs] = findpeaks(allYData{n,1});
    
    currentXData = allXData{n,1};
    
    % the highest value will be the last one

    sortedPeaks = sort(peaks);
    
    % get the highest n values and their position 
    
    for nn = 1:n
    
        peakvalue = sortedPeaks(size(peaks,2)-(n-1));
        
        % store value
        Peaks{tt+(nn-1)+1,2} = peakvalue;
        
        peakindex = find(peaks == peakvalue);
        
        peakomega = currentXData(peakindex);
        
        % store position
        Peaks{tt+(nn-1)+1,3} = peakomega;
        
        % store name
        
        Peaks{tt+(nn-1)+1,1} = allLegend{tt,1};
        
    end
    
end