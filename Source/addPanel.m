function [names,locations,functionype,Xaxis,Yaxis,numvariables,cancel] = addPanel
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%% Initialization

functionName = {'I-V','Transconductance','Conductance',...
                'Dynamic Conductance-Schotkky','Dynamic Conductance - MOS',...
                'Calculate Rs and Cox'};

names = {};
locations = {};
cancel = 0;




%% Figures 

figAdd = figure('numbertitle','off','name','Add data');
set(figAdd,'Units','pixels','position',[200 200 300 350]);
set(figAdd,'Resize','off');
set(figAdd,'Color','black');

      
%% Listboxes

listSelectFunction = uicontrol('parent',figAdd,'Style','Listbox','String',...
                             functionName(1,1:end),'Units','Normalized',...
                             'Position',[0.25,0.7,0.5,0.2]);


%% Push

pushNext = uicontrol('parent',figAdd,'style','push','Units',...
                             'Normalized','position',[0.75,0.05,0.2,0.1],...
                             'String','Next','Callback',@foncpushNext);
                         
pushCancel = uicontrol('parent',figAdd,'style','push','Units',...
                     'Normalized','position',[0.5,0.05,0.2,0.1],...
                     'String','Cancel','Callback',@foncpushCancel);
               
pushSelect = uicontrol('parent',figAdd,'style','push','Units',...
                     'Normalized','position',[0.25,0.5,0.5,0.1],...
                     'String','Select','Callback',@foncpushSelect);
                 
%% Edit Text Fields
                 
EditXString = 'X';

EditX = uicontrol('parent',figAdd,'Style','edit','Units',...
                     'Normalized','Position',[0.20,0.3,0.25,0.1],...
                     'String',EditXString);
                 
EdityString = 'y';
                
EditY = uicontrol('parent',figAdd,'Style','edit','Units',...
                         'Normalized','Position',[0.55,0.3,0.25,0.1],...
                         'String',EdityString);
                     
                     
EditNVariables = '1';
                
EditNvariables = uicontrol('parent',figAdd,'Style','edit','Units',...
                         'Normalized','Position',[0.1,0.1,0.25,0.1],...
                         'String',EditNVariables);                     
                     
                                   
%% Callback functions




    %----------------------------------------------------------------------
    % This function allows the user to recover the nescessary file(s)
    function foncpushSelect(~,~)
        
        [Filename, Pathname, Filterindex] =...
              uigetfile('All Files','Select your file','MultiSelect','on');
    
          
         % If he cancels it              

         if Filterindex == 0
         
            msgbox('You have failed to select a file')
            
         end
        
        % Take the trasponse of the cell if it is a cell
         
        if iscell(Filename)
         
        names = [names;Filename];
        locations = [locations;Pathname];
        
        else
            
        names = [names;Filename];
        locations = [locations;Pathname];    
            
        end
    end
 

    %----------------------------------------------------------------------
    function foncpushNext(~,~)
        
        functionype = functionName(1,get(listSelectFunction,'Value'));
        Xaxis = get(EditX,'String');
        Yaxis = get(EditY,'String');
        numvariables = str2num(get(EditNvariables,'String'));
        close(figAdd);
        
    end




    %----------------------------------------------------------------------
    function foncpushCancel(~,~)
        
        cancel = 1;
        close(figAdd);
    
    end










uiwait(figAdd);  

end

