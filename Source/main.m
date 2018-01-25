function main
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

% copyobj(get(fig,'Children'),panelPlots)                   

% Choose what he wants to do, e.g. plot the conductance or transcondutance
% Select where the files will come from, which ones are the variables
% that where used, e.g. T, Vg, their values and etc ...

[ DataList,Xvariables,Yvariables,Functions,cancel] = panelMain();

while cancel == 0
    
    
    
    
    % To save the handlers and type of plots for later
    
    plothandlerMatrix = ones(size(Functions,1),8);
    plotnameCell = cell(size(Functions,1),1);
    plotnameTypes = cell(size(Functions,1),1);
    plotindex = cell(size(Functions,1),1);
    legendindex = cell(size(Functions,1),1);
    
    % if 0 the no, if 1 then yes
    shoulditShowinPlotsPanel  = zeros(size(Functions,1),1);
    
    % Doing what he asked, first find out which function he chose and
    % act accordingly
    
    for nplot = 1:size(Functions,1)
        
        
        switch Functions{nplot,1}
            
            case 'Conductance'
                
                mode = 'Conductance';
                
                % Recover the data that was provided by the panelMain
                 [Nsweeps,Valeurs,Npoints,MinFrequency,MaxFrequency,...
                 FilePathNAME,figname,Gain_AOP,~,~] = translateData...
                                    ( DataList,mode,nplot);
                
                 [figureCTGP, DataCTPG, VectDataSheet, VectInfoSheet]...
                            = Cond_Transc(mode,Nsweeps,Valeurs,Gain_AOP,...
                                      Npoints,MinFrequency,MaxFrequency,...
                                      FilePathNAME,figname);

                
                % Recover the plot handlers that can be used in the second
                % part                
                plothandlerMatrix(nplot,1:size(get(figureCTGP,'Children')))...
                                        = get(figureCTGP,'Children')';
                shoulditShowinPlotsPanel(nplot,1) = 1;
                plotnameCell{nplot,1} = ['Conductance' '-' figname]; 
                plotnameTypes{nplot,1} = {'Phase','Gain','Phase','Cond'};
                plotindex{nplot,1} = [2 4 8 6];
                legendindex{nplot,1} = [1 3 7 5];
                
                % Ask the person if he wants to save it
                promptMessage = sprintf('Do you want to Save the data (not the plots) in Excel format ?');
       
                button = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');

                if strcmpi(button, 'Yes')
               
                   SaveDataExcel( DataCTPG,Nsweeps,figname,Npoints,...
                                               VectDataSheet,VectInfoSheet)
                    
                end

 
            case 'Transconductance'
                
                
                mode = 'Transconductance';
                
                % Recover the data that was provided by the panelMain
                [Nsweeps,Valeurs,Npoints,MinFrequency,MaxFrequency,...
                    FilePathNAME,figname,Gain_AOP,~,~ ] = translateData...
                    ( DataList,mode,nplot);
                
                % Plot and calculate the conductance and transconductance
               
                [figureCTGP, DataCTPG, VectDataSheet, VectInfoSheet]...
                            = Cond_Transc(mode,Nsweeps,Valeurs,Gain_AOP,...
                                      Npoints,MinFrequency,MaxFrequency,...
                                      FilePathNAME,figname);
                
                % Recover the plot handlers that can be used in the second
                % part                                   
                plothandlerMatrix(nplot,1:size(get(figureCTGP,'Children')))...
                                        = get(figureCTGP,'Children')';
                shoulditShowinPlotsPanel(nplot,1) = 1;
                plotnameCell{nplot,1} = ['Transconductance' '-' figname]; 
                plotnameTypes{nplot,1} = {'Phase','Gain','Phase','Trans'};
                plotindex{nplot,1} = [2 4 8 6];
                legendindex{nplot,1} = [1 3 7 5];
                
                % Ask the person if he wants to save it
                promptMessage = sprintf('Do you want to Save ?');
       
                button = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');

                if strcmpi(button, 'Yes')
               
                   SaveDataExcel( DataCTPG,Nsweeps,figname,Npoints,...
                                               VectDataSheet,VectInfoSheet)
                    
                end

                
            case 'I-V'
                
                
                mode = 'I-V';
                
                % Recover the data that was provided by the panelMain
                [~,Valeurs,Npoints,~,~,...
                    FilePathNAME,figname,~,sweepVoltage,~ ] = translateData...
                                                    ( DataList,mode,nplot);
                
                [figureIV] = I_V( Valeurs,sweepVoltage,Npoints,...
                    FilePathNAME,figname,Xvariables{nplot,1},...
                    Yvariables{nplot,1});
                
                shoulditShowinPlotsPanel(nplot,1) = 0;
                % Save the Handlers so they can be used later on
                
                

                
                
            case 'Dynamic Conductance-Schotkky'
                
                mode = 'Dynamic Conductance-Schotkky';
                
                % Recover the data provided by the user, i.e by PanelMain
                [Nsweeps,Valeurs,Npoints,MinFrequency,MaxFrequency,...
                    FilePathNAME,figname,~,~,~ ] = translateData...
                    ( DataList,mode,nplot);
                

                % Plot the data and do numerical manipulation
                
                [figureDC, DataDC, VectDataSheet, VectInfoSheet]...
                                = Dynamic_Cond_Schotkky(Nsweeps,Valeurs,...
                                      Npoints,MinFrequency,MaxFrequency,...
                                      FilePathNAME,figname);    
                                               
                
                % Save the Handlers so they can be used later on
                
                plothandlerMatrix(nplot,1:size(get(figureDC,'Children')))...
                                            = get(figureDC,'Children')';
                                        
                shoulditShowinPlotsPanel(nplot,1) = 1;
                plotnameCell{nplot,1} = ['Dynamic Conductance' '-' figname]; 
                plotnameTypes{nplot,1} = {'Cp','Gp(\omega)','Gp(\omega)/\omega'};
                plotindex{nplot,1} = [2 4 6];
                legendindex{nplot,1} = [1 3 5];
                
               % Ask the person if he wants to save it
                promptMessage = sprintf('Do you want to Save ?');
       
                button = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');

                if strcmpi(button, 'Yes')
               
                   SaveDataExcel( DataDC,Nsweeps,figname,Npoints,...
                                               VectDataSheet,VectInfoSheet)
                    
                end
                      
                
            case 'Dynamic Conductance - MOS'
                
                
                mode = 'Dynamic Conductance - MOS';
                
                % Recover the data provided by the user, i.e by PanelMain
                [Nsweeps,Valeurs,Npoints,MinFrequency,MaxFrequency,...
                    FilePathNAME,figname,~,~,Cox ] = translateData...
                    ( DataList,mode,nplot);
                

                % Plot the data and do numerical manipulation
                
                [figureDC, DataDC, VectDataSheet, VectInfoSheet]...
                                = Dynamic_Cond_MOS(Nsweeps,Valeurs,Cox,...
                                      Npoints,MinFrequency,MaxFrequency,...
                                      FilePathNAME,figname);   
                                               
                
                % Save the Handlers so they can be used later on
                
                plothandlerMatrix(nplot,1:size(get(figureDC,'Children')))...
                                            = get(figureDC,'Children')';
                                       
                shoulditShowinPlotsPanel(nplot,1) = 1;
                plotnameCell{nplot,1} = ['Dynamic Conductance' '-' figname]; 
                plotnameTypes{nplot,1} = {'Cp','Gp(\omega)','Gp(\omega)/\omega'};
                plotindex{nplot,1} = [2 4 6];
                legendindex{nplot,1} = [1 3 5];
                
               % Ask the person if he wants to save it
                promptMessage = sprintf('Do you want to Save ?');
       
                button = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');

                if strcmpi(button, 'Yes')
               
                   SaveDataExcel( DataDC,Nsweeps,figname,Npoints,...
                                               VectDataSheet,VectInfoSheet)
                    
                end   
                
                
                case 'Calculate Rs and Cox'
                
                
                mode = 'Calculate Rs and Cox';
                
                % Recover the data provided by the user, i.e by PanelMain
                [Nsweeps,Valeurs,Npoints,MinFrequency,MaxFrequency,...
                    FilePathNAME,figname,~,~,~ ] = translateData...
                    ( DataList,mode,nplot);
                

                % Plot the data and do numerical manipulation
                
                [ DataDC, VectDataSheet, VectInfoSheet]...
                                = Calc_Cox_Rs(Nsweeps,Valeurs,...
                                      Npoints,MinFrequency,MaxFrequency,...
                                      FilePathNAME,figname);
                                               
                shoulditShowinPlotsPanel(nplot,1) = 0;
                
               % Ask the person if he wants to save it
                promptMessage = sprintf('Do you want to Save ?');
       
                button = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');

                if strcmpi(button, 'Yes')
               
                   SaveDataExcel( DataDC,Nsweeps,figname,Npoints,...
                                               VectDataSheet,VectInfoSheet)
                    
                end 
                                
            otherwise
                
                cancel = 1;
                
                % break from here and go to the line before the end
                % corresponding to the while
                
        end
        
    end
        % Plot what he asked in the same figure, using the handles from
        % the plot from the previous function , use set(
        
        promptMessage = sprintf('Do you want to Continue ,\nor Cancel to abort processing?');
       
        button = questdlg(promptMessage, 'Continue', 'Continue', 'Cancel', 'Continue');
        
        
        if strcmpi(button, 'Cancel')
            return; % Or break or continue
        end
 
        if cancel == 0
            
            
            plotnameCellSPP = plotnameCell; % cell
            plothandlerMatrixSPP = plothandlerMatrix; % matrix
            plotnameTypesSPP = plotnameTypes; % cell
            plotindexSPP = plotindex; % Cell
            legendindexSPP = legendindex; % Cell
            
            % Delete row corresponding to I-V or Calculate Rs and Cox or
            % any other function that will not be plotted in showPlotsPanel
                    
            rowstoremove = find(shoulditShowinPlotsPanel == 0);
            
            plotnameCellSPP(rowstoremove,:) = [];
            plothandlerMatrixSPP(rowstoremove,:) = [];
            plotnameTypesSPP(rowstoremove,:) = [];
            plotindexSPP(rowstoremove,:) = [];
            legendindexSPP(rowstoremove,:) = [];
                        
   
            showPlotsPanel (plotnameCellSPP,plothandlerMatrixSPP,...
                plotnameTypesSPP,plotindexSPP,legendindexSPP);
            
        end
        
        cancel = 1;
          
end


end

%% TODO
%       Calculate the derivative of the conductance and transconductance
%       to find the peaks ?
%
%   Second GUI save button and cancel button
%   Both the Data as an excel file and as a matlab and fig ?
%   Try to revocer the X and Y data from the objects 
%           After try to use findpeaks
%                  After try to allow the user to select them manually










