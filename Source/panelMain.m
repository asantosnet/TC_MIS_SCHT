function [ DataList,Xvariables,Yvariables,Functions,cancel] = panelMain()
%This panel allows the user to select the files that he wants to use and 
% the plots that he wants to make
%   DataList = {[<4x7 cell>' char(10) '];[<2x7 cell>' char(10) '];
%                [<5x7 cell>' char(10) ']}
%               
%   [<4x7 cell>' char(10) '] = (for Transconductace/Condutcance)
%   '-'          Title    'Variable'  'Gain_AOP' 'Npoints' 'MinFrea'
%   'C\Users...' 'Jeft'         10      100         401         10
%   'C\Users...' 'Jeft'         10      100         401         [] 
%   'C\Users...' 'Jeft'         10      100         401         []
%   'C\Users...' 'Jeft'         10      100         401         []
%
%   'MaxFreq'
%       10000
%       []
%       []
%
%
%   [<2x7 cell>' char(10) '] = (for IV)
%
%   [<4x7 cell>' char(10) '] = (for Transconductace/Condutcance)
%   '-'          Title    'Variable'  'Pas' 'Npoints' 'Vmin'    'Vmax'
%   'C\Users...' 'Jeft'         10      0.5       91      -5        5
%   
%   Functions = {'Transconductance';'I-V';'Conductance'}
%   XVariables = {'X';'X';'X'}
%   YVariables = {'y';'y';'y'}
%
%   Cancel = 0
%   


Close = 0;
DataList = cell(2,1);
DataList{1,1} = {'data',2;'Data',1};
DataList{2,1} = {'data',4;'Data',2};

FunctionsNames = {'test1name';'test2name'};
Functions = {'test1';'test2'};
Xvariables = {'test1X';'test2X'};
Yvariables = {'test1Y';'test2Y'};

figmain = figure('numbertitle','off','name','SelectData 1');
set(figmain,'Units','pixels','position',[200 200 1037 550]);
set(figmain,'Resize','off');
% set(figmain,'Color','black');


%% Push

pushNext = uicontrol('parent',figmain,'style','push','Units',...
                             'Normalized','position',[0.85,0.05,0.10,0.1],...
                             'String','Next','Callback',@foncpushNext);
                         
pushCancel = uicontrol('parent',figmain,'style','push','Units',...
                     'Normalized','position',[0.7,0.05,0.10,0.1],...
                     'String','Cancel','Callback',@foncpushCancel);
               
pushAdd = uicontrol('parent',figmain,'style','push','Units',...
                     'Normalized','position',[0.05,0.05,0.10,0.05],...
                     'String','Add','Callback',@foncpushAdd);
                 
pushSave = uicontrol('parent',figmain,'style','push','Units',...
                     'Normalized','position',[0.20,0.05,0.10,0.05],...
                     'String','Save','Callback',@foncpushSave);
                 
                 
pushDelete = uicontrol('parent',figmain,'style','push','Units',...
                     'Normalized','position',[0.35,0.05,0.10,0.05],...
                     'String','Delete','Callback',@foncpushDelete);                    
                 
%% Listboxes


listSelectPlots = uicontrol('parent',figmain,'Style','Listbox','String',...
                             FunctionsNames(:,1),'Units','Normalized',...
                             'Position',[0.7,0.2,0.25,0.6],'Callback',...
                             @fonclistSelectPlots);    
                         
                 
%% Table

tableData = uitable('parent',figmain,'Data',DataList{1,1},'Units',...
                      'Normalized','Position',[0.05,0.2,0.6,0.6],...
                      'ColumnEditable',true(1,2));    
              
                  
                  
           
%% Callback functions


   %-----------------------------------------------------------------------
   % The user can edit the Table so he can input the values that he desires
    function foncpushSave(~,~)
    
        newData = get(tableData,'Data');
        pos = get(listSelectPlots,'Value');
        DataList{pos,1} = newData;
        
    end



   %-----------------------------------------------------------------------
    % Modify the values in the table in function of the selected dataset
    function fonclistSelectPlots(~,~)
    
        pos = get(listSelectPlots,'Value');
        set(tableData,'Data',DataList{pos,1});
        set(tableData,'ColumnEditable',true(1,size(DataList{pos,1},2)));
    
    end


    %-----------------------------------------------------------------------
    % Allows the user to select the files that will be used and the type of
    % data manipulation
    
    function foncpushAdd(~,~)
    
        
        % Recover the files and nescessary information
        [names,locations,functiontype,Xaxis,Yaxis,numvariables,cancel] =...
            addPanel;
        
        % Define the shape of each matrix that will save the nescessary 
        % values. As a consequence, this defines which values the user
        % will have to provide to the pogram
        selectedData = cell(size(names,2)+1,numvariables+2);        
        
        selectedData(1,2) = {'Title'};
        selectedData(1,3:end) = {'Variable Name'};
        selectedData(1,1) = {'-'};
        
        if strcmp(functiontype{1,1},'Conductance') ||...
                strcmp(functiontype{1,1},'Transconductance')
            
            selectedData{1,size(selectedData,2)+1} = 'Gain_AOP (V/A)';
            selectedData(2:end,size(selectedData,2)) = deal(num2cell(1e+3));
            
            selectedData{1,size(selectedData,2)+1} = 'Npoints';
            selectedData(2:end,size(selectedData,2)) = deal(num2cell(401));
                                                    
            
            selectedData{1,size(selectedData,2)+1} = 'MinFrequency (Hz)';
            selectedData(2,size(selectedData,2)) = deal(num2cell(10));
                                                   
            
            selectedData{1,size(selectedData,2)+1} = 'MaxFrequency (Hz)';
            selectedData(2,size(selectedData,2)) = deal(num2cell(100000000));
                                                    
        elseif strcmp(functiontype{1,1},'I-V')
            
            
            selectedData(2,3) = {'Vgs'};
            
            selectedData{1,size(selectedData,2)+1} = 'Pas';
            selectedData(2:end,size(selectedData,2)) = deal(num2cell(0.5));
            
            selectedData{1,size(selectedData,2)+1} = 'Npoints';
            selectedData(2:end,size(selectedData,2)) = deal(num2cell(91));
                                                    
            
            selectedData{1,size(selectedData,2)+1} = 'Vmin (V)';
            selectedData(2,size(selectedData,2)) = deal(num2cell(-5));
                                                   
            
            selectedData{1,size(selectedData,2)+1} = 'Vmax (V)';
            selectedData(2,size(selectedData,2)) = deal(num2cell(5));
            
            
        elseif strcmp(functiontype{1,1},'Dynamic Conductance-Schotkky')
            
            selectedData{1,size(selectedData,2)+1} = 'Npoints';
            selectedData(2:end,size(selectedData,2)) = deal(num2cell(401));
                                                    
            
            selectedData{1,size(selectedData,2)+1} = 'MinFrequency (Hz)';
            selectedData(2,size(selectedData,2)) = deal(num2cell(100));
                                                   
            
            selectedData{1,size(selectedData,2)+1} = 'MaxFrequency (Hz)';
            selectedData(2,size(selectedData,2)) = deal(num2cell(100000));
            
         
        elseif strcmp(functiontype{1,1},'Dynamic Conductance - MOS')   
            
            selectedData{1,size(selectedData,2)+1} = 'Cox (F)';
            selectedData(2:end,size(selectedData,2)) = deal(num2cell(1e-6));
            
            selectedData{1,size(selectedData,2)+1} = 'Npoints';
            selectedData(2:end,size(selectedData,2)) = deal(num2cell(401));
                                                    
            
            selectedData{1,size(selectedData,2)+1} = 'MinFrequency (Hz)';
            selectedData(2,size(selectedData,2)) = deal(num2cell(100));
                                                   
            
            selectedData{1,size(selectedData,2)+1} = 'MaxFrequency (Hz)';
            selectedData(2,size(selectedData,2)) = deal(num2cell(100000));
            
        
        elseif strcmp(functiontype{1,1},'Calculate Rs and Cox') 
            
            selectedData{1,size(selectedData,2)+1} = 'Npoints';
            selectedData(2:end,size(selectedData,2)) = deal(num2cell(401));
                                                    
            
            selectedData{1,size(selectedData,2)+1} = 'MinFrequency (Hz)';
            selectedData(2,size(selectedData,2)) = deal(num2cell(100));
                                                   
            
            selectedData{1,size(selectedData,2)+1} = 'MaxFrequency (Hz)';
            selectedData(2,size(selectedData,2)) = deal(num2cell(100000));
            
        
        end
        
        locationsname = cell(size(names,2),1);
        
        if cancel == 0
        
        for t = 1:size(names,2)
        
            locationsname{t,1} = [locations{1,1},'\',names{1,t}];
        
        end
            
        selectedData(2:end,1) = locationsname;
        selectedData(2:end,2) = names;
     
        DataList{size(DataList,1)+1,1} = selectedData;
                
        Functions(size(Functions,1)+1,1) = functiontype;
         
        FunctionsNames{size(FunctionsNames,1)+1,1} = [functiontype{1,1},'-',...
                                                        names{1,1}];
                                                    
        set(listSelectPlots,'String',FunctionsNames(:,1));
        
        Xvariables{size(Xvariables,1)+1,1} = Xaxis;
       
        Yvariables{size(Yvariables,1)+1,1} = Yaxis;
    

        else
        end

        

    end


    %----------------------------------------------------------------------
    function foncpushDelete(~,~)
        
        pos = get(listSelectPlots,'Value');
        
        DataList (pos,:) = [];
        
        fonclistSelectPlots
        
        FunctionsNames (pos,:) = [];
        Functions (pos,:) = [];
        Xvariables (pos,:) = [];
        Yvariables (pos,:) = [];
        
        set(listSelectPlots,'String',FunctionsNames(:,1));
                    
        
    end


    %----------------------------------------------------------------------
    function foncpushCancel(~,~)
        
        cancel = 1;
        close(figmain);
    end


    %----------------------------------------------------------------------
    function foncpushNext(~,~)
       
        cancel = 0;

        promptMessage = sprintf('Have you saved all your modifications, have you filled all spaces (otherwise it will crash)?');

        button = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');

        if strcmpi(button, 'Yes')

            close(figmain);
        end
              

    end


                         
uiwait(figmain);               
                  
end

