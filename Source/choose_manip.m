function [Chosenfunc,Inputfunc,Close] = choose_manip(Availablefunc,...
                                AvailablefuncPanel,Data,SheetsName,FILENAME)
%choose_manip(availablefunc,availablefuncpanel) Allows the
% user to choose which functions will be applied to the set of Data
%   
%   Inputs :
%
%   Availablefunc is a cell(n,2) with all available functions name in the 
%   first column and its type in the second column
%   AvailablefuncPanel (cell(n,2)) is the function that contaisn the Panel 
%   that will be used to allow the user to input its data, name is in the
%   first coumn and type in the second
%   e.g. Availablefunc = {'plotIVexcel' 'Plot'}  
%        AvailablefuncPanel ={'panel_plotIV' 'Plot'};
%        Data the one that comes from read_select_excel   
%        NomSheets the one that comes from read_select_excel
%        FILENAME the one that comes from read_select_excel
%
%
%   
%   Types : 
%
%       Plot : for the function e.g. 
%       [excel,eWorkSheets,eWorkbook] = plotIVexcel(Data, FILENAME,...
%                                      ColumnI,ColumnV, name,location )
%               for the panel function
%               panel_plotIV(panelSelectedFunction )
%
%
%   chosenfunc is a cell(n,2) with all choosen functions and their
%   respective types
%   inputfunc is a cell(n,m) with all the Data needed to make the functions
%   work



Close = 0;


Chosenfunc = cell(1,1);
Inputfunc = cell(1,1);

% Allows the user to assign a tag to the function, it helps in case one
% wants to plot different things for example ( using the same function)
ChosenfuncStatus = cell(1,1);

figmain = figure('numbertitle','off','name','SelectFunc');
set(figmain,'Units','pixels','position',[200 200 937 800]);
set(figmain,'Resize','off');
set(figmain,'Color','black');

%% Push

pushNext = uicontrol('parent',figmain,'style','push','Units',...
    'Normalized','position',[0.89,0.01,0.1,0.05],...
    'String','Next','Callback',@foncpushNext);

pushCancel = uicontrol('parent',figmain,'style','push','Units',...
    'Normalized','position',[0.78,0.01,0.1,0.05],...
    'String','Cancel','Callback',@foncpushCancel);

pushAdd = uicontrol('parent',figmain,'style','push','Units',...
    'Normalized','position',[0.43,0.8,0.15,0.05],...
    'String','Add','Callback',@foncpushAdd);

pushRemove = uicontrol('parent',figmain,'style','push','Units',...
    'Normalized','position',[0.43,0.7,0.15,0.05],...
    'String','Remove','Callback',@foncpushRemove);


%% Listbox



listSelectAvailablefunc = uicontrol('parent',figmain,'Style','Listbox','String',...
    Availablefunc(1:end,1),'Units','Normalized',...
    'Position',[0.03,0.6,0.35,0.3],'Callback',...
    @fonclistSelectAvailablefunc);

% for it to allow multiselection


set(listSelectAvailablefunc,'Min',0,'Max',2);



listSeeChosenfunc = uicontrol('parent',figmain,'Style','Listbox','String',...
    Chosenfunc(1:end,1),'Units','Normalized',...
    'Position',[0.63,0.60,0.35,0.3],'Callback',...
    @fonclistSeeChosenfunc);



%% Textfields

namelistSAfunc = uicontrol('parent',figmain,'Style','text','String',...
    'Choose the functios to be used among the folowing available functions',...
    'Units','Normalized','Position',...
    [0.03,0.90,0.3,0.05],'BackgroundColor','black',...
    'ForegroundColor','white');


namelistSAfunc = uicontrol('parent',figmain,'Style','text','String',...
    'The chosen functions, double click for changing its input data',...
    'Units','Normalized','Position',...
    [0.63,0.90,0.3,0.05],'BackgroundColor','black',...
    'ForegroundColor','white');


namePanel = uicontrol('parent',figmain,'Style','text','String',...
    ' No function has benn chosen yet',...
    'Units','Normalized','Position',...
    [0.03,0.55,0.3,0.03],'BackgroundColor','black',...
    'ForegroundColor','white');
                         

%% Panels
% Panel which will contain the specific demands coming from the chose
% function

panelSelectedFunction = uipanel('parent',figmain,'Units',...
    'Normalized','Position',[0.03,0.07,0.95,0.47]);

%% Edit text filed


% It will contain the tag and allow the user to write their own.
tagEdit = uicontrol('parent',figmain,'Style','edit','String','Nothing',...
                    'Units','Normalized','Position',[0.805 0.54 0.1 0.06],...
                    'Callback',@fonctagEdit);



%% Callbacks for figmain

%-------------------------------------------------------------------------

    function fonctagEdit(hObject,~)
        
         % to get which fonction are we modifying its status
         chosenFoncIndex = get(listSeeChosenfunc,'Value');
         
         % to allow the user to assign his "status"
         
         if isempty(chosenFoncIndex) == 0
            ChosenfuncStatus{chosenFoncIndex,1} = get(hObject,'String');
         else
             wardlg('Please selected a fonction that you want to tag');
         end
         
    end


%-------------------------------------------------------------------------
    function foncpushNext(~,~)
        
        
        % Check for empty cells
        if ~cellfun('isempty',Chosenfunc) == zeros(size(Chosenfunc,1),...
                size(Chosenfunc,2))
            
            warndlg('No function has been selected')
            
        else
            
            % Check if he filled every information nescesary concerning the
            % Chosen functions
            if all(cellfun('isempty',Inputfunc),2) == zeros(size(Inputfunc,1),1)
            
                uiresume(figmain);
                close(figmain);
                
            else
                
                warndlg('No input has been selected');
     
            end
            
            
        end
        
        
        
    end

%----------------------------------------------------------------------
    function foncpushCancel(~,~)
        
        Close = 1;
        uiresume(figmain);
        close(figmain);
    end

%----------------------------------------------------------------------
% This function will give us the Available functions that the user can
% choose from, once chosen, double click, the function will be sent to the
% selected functions list

    function fonclistSelectAvailablefunc(hObject,~)
        
        % To remove empty cell
        
        Chosenfunc(all(cellfun('isempty',Chosenfunc),2),:) = [];        
        
        % To add the chosen functions to the Chosen listbox
            
            indexSelectedFile = get(hObject,'Value');
            toAddFunc = Availablefunc(indexSelectedFile,1); 
            Chosenfunc = [Chosenfunc;toAddFunc];
            
            % To add a status to the new fonction
            ChosenfuncStatus{size(Chosenfunc,1),1} = 'Empty';
            
            % I need to do so, so it created the empty space used to
            % detectec if information cocerning the Chosenfunc is missing
            % or not
            
            indexSelectedFunc = size(Chosenfunc,1);
            Inputfunc{indexSelectedFunc,1} = {};
            
            set(listSeeChosenfunc,'String',Chosenfunc(1:end,1));

        
    end

%----------------------------------------------------------------------
% This function will Add a new function to the Chosenfunc lsit box
    function foncpushAdd(~,~)
        
        % To remove empty cell
        
        Chosenfunc(all(cellfun('isempty',Chosenfunc),2),:) = []; 
        
        % To add the chosen functions to the Chosen listbox
        
        indexSelectedFile = get(listSelectAvailablefunc,'Value');
        toAddFunc = Availablefunc(indexSelectedFile,1);
        Chosenfunc = [Chosenfunc;toAddFunc];
        
        % To add a status to the new fonction and assing it as Empty
        ChosenfuncStatus{size(Chosenfunc,1),1} = 'Empty';
            
        % I need to do so, so it created the empty space used to
        % detectec if information cocerning the Chosenfunc is missing
        % or not

        indexSelectedFunc = size(Chosenfunc,1);
        Inputfunc{indexSelectedFunc,1} = {};
        
        set(listSeeChosenfunc,'String',Chosenfunc(1:end,1));
        
    end

%----------------------------------------------------------------------
% This function will Remove a function from the Chosenfunc lsit box
    function foncpushRemove(~,~)
        
        % To remove function from the SeeChosenfunc listbox
        
        if size(Chosenfunc,1) == 1
            
            indexSelectedFile = get(listSeeChosenfunc,'Value');
            
            % This will only remove the Data from the cell but not the cell
            % itself
            Chosenfunc{indexSelectedFile,1} = [];
            ChosenfuncStatus{ndexSelectedFile,1} = [];
            
            % Veify that Inputfunc has already been filled for this
            % Chosenfunc
            
            Inputsize = size(Inputfunc,1);
            
            if Inputsize < indexSelectedFile
            else
                Inputfunc(indexSelectedFile,:) = [];
            end
            
            set(listSeeChosenfunc,'String',Chosenfunc(1:end,1));
            
        else
            
            indexSelectedFile = get(listSeeChosenfunc,'Value');
            
            % This will not only remove the data but also the place within
            % the cell that was occupied by this value
            Chosenfunc(indexSelectedFile,:) = [];
            ChosenfuncStatus(indexSelectedFile,:) = [];
            
            % Veify that Inputfunc has already been filled for this
            % Chosenfunc
            
            Inputsize = size(Inputfunc,1);
            
            if Inputsize < indexSelectedFile
            else
                Inputfunc(indexSelectedFile,:) = [];
            end
            
            % This step is nescessary so the value of the listBox is not
            % bigger than the size of the list itself. This is a problem
            % when deleting the last file.
            set(listSeeChosenfunc,'Value',size(Chosenfunc,1));
            
            set(listSeeChosenfunc,'String',Chosenfunc(1:end,1));
            
        end
    end

%----------------------------------------------------------------------
% This function will allow the user to change the panel that is shown
% bellow so he can change the input data nescessary for the function to
% work


    function fonclistSeeChosenfunc(hObject,~)
        
        indexSelectedFunc = get(hObject,'Value');

        set(tagEdit,'String',ChosenfuncStatus{indexSelectedFunc,1});
        
        % If it is a doubleclick
        
        if strcmp(get(figmain,'SelectionType'),'open');
            
            newNamePanel = Chosenfunc{indexSelectedFunc,1};
            set(namePanel,'String',newNamePanel);
            
            % look for the index on the Availablefunc and then use this
            % index to recover the name of the function with the Panel
            % associated with the selected Availablefunc
            
            indexSelectedPanel = find(ismember(Availablefunc(1,1:2),newNamePanel));
            
            % To transfor the desired string into a function
            newPanel = AvailablefuncPanel{indexSelectedPanel,1};
            newPanelfunc = str2func(newPanel);
            
            % To know which input one can provide
            newPanelType = AvailablefuncPanel{indexSelectedPanel,2};
            
            switch newPanelType
                
                case 'Plot'
                    

                    [ColumnX,ColumnY,X,Y,posSheet]= ...
                        newPanelfunc(panelSelectedFunction,Data,SheetsName,FILENAME);
                    
                    
                    % The sheets that are not desired will be set to empty,

                    
                    DataPlot = Data; % We don't wanna to mess with Data 
                                     % directly
                    
                    % Use () to access the cel and replace by another cell,
                    % {[]} is an empty cell. This mantains the cell shape
                    
                    DataPlot(logical((ones(size(posSheet,1),size(posSheet,2))...
                                    -posSheet))) = {[]};
                                     
                    % Creat a cell with the same number of inputs required
                    % for the Plot type function
                    
                    NInputsOutputs = Availablefunc{indexSelectedPanel,3};
                    
                    Inputfunc(indexSelectedFunc,1:NInputsOutputs(1)) = ...
                               cell(1,NInputsOutputs(1));
                    
                    % Populate that cell with the relevant Data, the order
                    % of the Data is the same as the one that will be
                    % accepted by this type of function
                    
                    Inputfunc{indexSelectedFunc,1} = ColumnX;
                    Inputfunc{indexSelectedFunc,2} = ColumnY;
                    Inputfunc{indexSelectedFunc,3} = X;
                    Inputfunc{indexSelectedFunc,4} = Y;
                    Inputfunc{indexSelectedFunc,5} = DataPlot;
                    
                    % To change its status if the user didn't choose one by
                    % himself if it is 'Empty' the user has not tuched it
                    
                    if  strcmp(ChosenfuncStatus{indexSelectedFunc,1},'Empty')
                        
                         ChosenfuncStatus{indexSelectedFunc,1} = 'Ready';
                         set(tagEdit,'String',ChosenfuncStatus{indexSelectedFunc,1});
                    end
                  
                otherwise
                    warndlg('Type doesn''t exist, problem in function delcaration')
            end
        end
        
    end

uiwait(figmain);


end

