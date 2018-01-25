function  showPlotsPanel (plotnameCell,plothandlerMatrix,plotnameTypes,...
                            plotindex,legendindex)
%This function is the panel that plot the plots associated with the
% handles provided in handlesPlots and that have a name defined in 
% Names               
%   plotnameCell = {'name1' ; 'name2'}.....                
%   plothandlerMatrix = [handlerPhase1, HandlerGain1, Handlerlegen
%                    handlerCond/Trans1; ....]
%   plotnameTypes = {'type1' , 'type2; 'type1a', 'type2a'} 
%   plotindex = [1 2 4 6];
%   legendindex = [3 3 3 5];



%% Main Figure

% The plotindex vector and legendindex vector that concenrs the current
% plot and some other variables that must be initialized

currentplotindex = plotindex{1,:};
currentlegendindex = legendindex{1,:};

xYPeakPos = [0 0];

Peaks = cell(2,1);
Peaks{1,1} = {'data',2;'Data',1};
Peaks{2,1} = {'data',4;'Data',2};

figshowPlotsPanel = figure('numbertitle','off','name','Add data');
set(figshowPlotsPanel,'Units','pixels','position',[200 200 1000 650]);
set(figshowPlotsPanel,'Resize','off');
% set(figshowPlotsPanel,'Color','black');


%% Panels

panelPlots = uipanel('parent',figshowPlotsPanel,... 
                       'Units','Normalized','Position',[0.02,0.1,0.7,0.8]);
                   

% The first plot will show up as soon as the thing is open

copyobj(plothandlerMatrix(1,1),panelPlots);                   
set(get(panelPlots,'Children'),'Units','Normalized',...
        'Position',[0.1,0.1,0.80,0.80])

%% Table

tablePeaksData = uitable('parent',figshowPlotsPanel,'Data',Peaks{1,1},'Units',...
                      'Normalized','Position',[0.73,0.18,0.26,0.3],...
                      'ColumnEditable',true(1,3));
                  
set(tablePeaksData,'ColumnEditable',false(1,1));


                   
%% Pop-Up menu

listPlotsCT = uicontrol('parent',figshowPlotsPanel,'Style','pop',...
                        'String',plotnameCell,'Callback',@fonclistPlotsCT,...
                        'Units','Normalized','Position',[0.83,0.7,0.15,0.1]);
                    
  
                    
listPlotsGPCT = uicontrol('parent',figshowPlotsPanel,'Style','pop',...
                        'String',plotnameTypes{1,1},...
                        'Callback',@fonclistPlotsGPCT,...
                        'Units','Normalized','Position',[0.83,.65,0.15,0.1]);
                                        
  
%% BPush

findPeaksButton = uicontrol('parent',figshowPlotsPanel,'style','push','Units',...
                             'Normalized','position',[0.73,0.5,0.1,0.05],...
                             'String','Find Peaks',...
                             'Callback',@foncfindPeaksButton);
                         
                         
plotSelectPeakButton = uicontrol('parent',figshowPlotsPanel,'style','push','Units',...
                             'Normalized','position',[0.73,0.1,0.1,0.05],...
                             'String','Select Peak',...
                             'Callback',@foncplotSelectPeakButton,'Visible','Off');
                         
                         
plotSavePeakButton = uicontrol('parent',figshowPlotsPanel,'style','push','Units',...
                             'Normalized','position',[0.73,0.05,0.1,0.05],...
                             'String','Save Peak',...
                             'Callback',@foncplotSavePeakButton,'Visible','Off');                         
                                                  
%% EditText 

editNumberofPeaks = uicontrol('parent',figshowPlotsPanel,'Style','edit','Units',...
                     'Normalized','Position',[0.87,0.5,0.1,0.05],...
                     'String','Number of Peaks');
                 
editSelectPeakNumber = uicontrol('parent',figshowPlotsPanel,'Style','edit','Units',...
                     'Normalized','Position',[0.87,0.05,0.1,0.1],...
                     'String','Peak Number(from Table)','Visible','Off');

                         
              
%% Callback functions

%   -----------------------------------------------------------------------
    % When the user selects the type of plot, it will automatically change 
    % the one that is shown at the panel
    function fonclistPlotsCT(~,~)
    
        % get the selected value
        selectedplotCT = get(listPlotsCT,'Value');
        
        % update the other list
        set(listPlotsGPCT,'String',plotnameTypes{selectedplotCT,:});
        
        
        selectedplotGPCT = get(listPlotsGPCT,'Value');
        
        delete(get(panelPlots,'Children'));
        
        % update the current index and list vectors
        currentplotindex = plotindex{selectedplotCT,:};
        currentlegendindex = legendindex{selectedplotCT,:};

            
        % The plot object
        copyobj(plothandlerMatrix(selectedplotCT,currentplotindex(selectedplotGPCT)),panelPlots);
        set(get(panelPlots,'Children'),'Units','Normalized',...
        'Position',[0.1,0.1,0.80,0.80]);
        set(get(panelPlots,'Children'),'Title',plotnameCell{selectedplotCT,1});
        
        % The legend object-    
        copyobj(plothandlerMatrix(selectedplotCT,currentlegendindex(selectedplotGPCT)),panelPlots);     
        
        
        % So they are visible
        currentplotindex = plotindex{selectedplotCT,:};
        HandlerPlots = get(plothandlerMatrix(selectedplotCT,...
                                currentplotindex(selectedplotGPCT)),...
                                'Children');
        set(HandlerPlots,'Visible','On')

     
    end


%   -----------------------------------------------------------------------
    % When the user selects the type of plot, it will automatically change 
    % the one that is shown at the panel
    function fonclistPlotsGPCT(~,~)
    
        selectedplotCT = get(listPlotsCT,'Value');
        selectedplotGPCT = get(listPlotsGPCT,'Value');
        
        delete(get(panelPlots,'Children'));

         % The plot object
        copyobj(plothandlerMatrix(selectedplotCT,currentplotindex(selectedplotGPCT)),panelPlots);
        set(get(panelPlots,'Children'),'Units','Normalized',...
        'Position',[0.1,0.1,0.80,0.80]);
        
        % The legend object-    
        copyobj(plothandlerMatrix(selectedplotCT,currentlegendindex(selectedplotGPCT)),panelPlots);     
        
                % So they are visible
        currentplotindex = plotindex{selectedplotCT,:};
        HandlerPlots = get(plothandlerMatrix(selectedplotCT,...
                                currentplotindex(selectedplotGPCT)),...
                                'Children');
                            
        set(HandlerPlots,'Visible','On')


        % The plots must be updated 
        delete(get(panelPlots,'Children'));

        % The plot object
        copyobj(plothandlerMatrix(selectedplotCT,...
                currentplotindex(selectedplotGPCT)),panelPlots);
        set(get(panelPlots,'Children'),'Units','Normalized',...
        'Position',[0.1,0.1,0.80,0.80]) 
        
        
        
    end

%   -----------------------------------------------------------------------
    % It will find the peaks for the current plot
    
    function foncfindPeaksButton(~,~)
    
        % get the selected value
        selectedplotCT = get(listPlotsCT,'Value');
        
        % update the other list
        set(listPlotsGPCT,'String',plotnameTypes{selectedplotCT,:});
        
        
        selectedplotGPCT = get(listPlotsGPCT,'Value');
        
        % update the current index and list vectors
        currentplotindex = plotindex{selectedplotCT,:};
        currentlegendindex = legendindex{selectedplotCT,:};

        % Function to find the peaks
        nPeaks = str2double(get(editNumberofPeaks,'String'));
        
        if isnan(nPeaks) == 1
        
            warndlg('The number of selected peaks per plot will be 1')
            nPeaks = 1;
            
        
        end
        
        
        [ Peaks ] = FindPeaksDC(currentplotindex(selectedplotGPCT),nPeaks,...
            plothandlerMatrix,selectedplotCT );
        
        set(tablePeaksData,'Data',Peaks);
        set(plotSelectPeakButton,'Visible','On');
        set(plotSavePeakButton,'Visible','On');
        set(editSelectPeakNumber,'Visible','On');
     
    end


%   -----------------------------------------------------------------------
    % Allows the user to select himself the peaks, as the automatic
    % function migth not work properly and the result migth not be exact, 
    % notably for multiple peaks
    
    function foncplotSelectPeakButton(~,~)
        
        Peakcell = get(tablePeaksData,'Data');
        
        % Get the peak that he wants to change
        selectedPeak = str2double(get(editSelectPeakNumber,'String'));
        
        if isnan(selectedPeak) == 1 
        
            warndlg('Type an interger')
            
        elseif selectedPeak > (size(Peaks,1))
            
            warndlg('Value too High, choose a higher number of peaks per plot')
        
        elseif selectedPeak == 1
            
            warndlg('This value cannot be replaced');
            
        else
            
            currentPeakLegend = Peakcell{selectedPeak,1};
            
            % Hide all plots
            
            selectedplotCT = get(listPlotsCT,'Value');
            selectedplotGPCT = get(listPlotsGPCT,'Value');
            currentplotindex = plotindex{selectedplotCT,:};
            HandlerPlots = get(plothandlerMatrix(selectedplotCT,...
                                currentplotindex(selectedplotGPCT)),...
                                'Children');
            allLegend = get(HandlerPlots,'DisplayName');
            set(HandlerPlots,'Visible','Off')

            
            % Set only the one that we are interested at visible
                   
            realplotindex = find(strcmp(allLegend, currentPeakLegend));
            
            set(HandlerPlots(realplotindex),'Visible','On');
            
            
            % The plots must be updated 
            delete(get(panelPlots,'Children'));

            % The plot object
            copyobj(plothandlerMatrix(selectedplotCT,...
                    currentplotindex(selectedplotGPCT)),panelPlots);
            set(get(panelPlots,'Children'),'Units','Normalized',...
            'Position',[0.1,0.1,0.80,0.80])
        
            % Turn on the Data Cuursor, the function SavePeak will
            % do the rest
            
            dataCursorHandler = datacursormode(figshowPlotsPanel);
            set(dataCursorHandler,'UpdateFcn',@foncupdatedataCursorHandler,...
                'SnapToDataVertex','on');
            datacursormode on
           
        end
        
        
        
     
    end

%   -----------------------------------------------------------------------
    % Allows the user to select himself the peaks, as the automatic
    % function migth not work properly and the result migth not be exact, 
    % notably for multiple peaks
    
    function foncplotSavePeakButton(~,~)
        
        
        selectedPeak = str2double(get(editSelectPeakNumber,'String'));
        
        % recover the peaks cell and change the X and Y positions of the
        % relevant peaks
        Peakcell = get(tablePeaksData,'Data');
        Peakcell{selectedPeak,3} = xYPeakPos(1);
        Peakcell{selectedPeak,2} = xYPeakPos(2);
        
        % update table shown to the user and etc..
        set(tablePeaksData,'Data',Peakcell);

        selectedplotCT = get(listPlotsCT,'Value');
        selectedplotGPCT = get(listPlotsGPCT,'Value');        
        currentplotindex = plotindex{selectedplotCT,:};
        HandlerPlots = get(plothandlerMatrix(selectedplotCT,...
                                currentplotindex(selectedplotGPCT)),...
                                'Children');
                            
        set(HandlerPlots,'Visible','On')
        
        
        % The plots must be updated 
        delete(get(panelPlots,'Children'));

        % The plot object
        copyobj(plothandlerMatrix(selectedplotCT,...
                currentplotindex(selectedplotGPCT)),panelPlots);
        set(get(panelPlots,'Children'),'Units','Normalized',...
        'Position',[0.1,0.1,0.80,0.80])
        
        
        datacursormode off

    end

%   -----------------------------------------------------------------------
    % Gets the position of the cursor each time that a click is made
    
    function [txt] = foncupdatedataCursorHandler(~,event_obj)
        
        % get the position of the handler
        
        xYPeakPos = get(event_obj,'Position');
        txt = {['\omega: ',num2str(xYPeakPos(1))],...
            ['G(\omega)/\omega: ',num2str(xYPeakPos(2))]};
    end


uiwait(figshowPlotsPanel);    

end

