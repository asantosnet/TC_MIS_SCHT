function [figureDC, DataDC, VectDataSheet, VectInfoSheet]...
                                = Dynamic_Cond_MOS(Nsweeps,Valeurs,Cox,...
                                      Npoints,MinFrequency,MaxFrequency,...
                                      FilePathNAME,figname)
%   This function recevies the valeus from the user after they have bee
%  "translated" by the translateData function and calculate and plot
%   the Dynamic Conducntace (Gp(w)/w) as well as the Conducntace(Gp) and Cp
%   for the input definitions see translateData
%   Cox = [2;5;8;7;9;3] for 6 sweeps
%   figureDC = the handler of the figure plotting those plots. To get the
%   plots use get(figureDC,'Children') = [handlerPhase 
%                                           handlerGain
%                                           handlerLegend
%                                           handlerGain]
%   DataDC is a cell with everything [Add proper description here]
%
%   VectDataSheet = [2 3 4 5 6];
%                
%   VectInfoSheet = [9 10 11 12];



%% Initialization

% Number of parameters to be saved before the "Valeurs" are saved. The
% latter is used for the legend
Nparameters = 8;

DataDC = cell((Nsweeps+1),(size(Valeurs,2)+ Nparameters));

DataDC{1,1} = {'Files'};

DataDC(1,2:6) = {'Frequency','\omega','Conductance(Gp)',...
                        'Dynamic Conductance (Gp/\omega)',...
                        'Capacitance Cp'};
                                       

DataDC(1,7) = {'Cox'}; 
DataDC(1,8) = {'Rs'};

% Cox is a column vector with the values for Cox for each sweep
DataDC{2,7} = Cox;
DataDC{2,8} = 0;
                    
legends = cell(1,Nsweeps);


for t = 1:Nsweeps

    for d = 1:size(Valeurs,2)
        
    legends{1,t} = [legends{1,t} ';' Valeurs{1,d} '=' num2str(Valeurs{t+1,d})];
    
    DataDC(1,(Nparameters+d)) = Valeurs(1,d);
    
    end

end


Valeursvect = ones(Nsweeps,1);

for t = 1:size(Valeurs,2)

    for d = 1:Nsweeps 
        Valeursvect(d,1) = Valeurs{d+1,t};
    end
    
    DataDC{2,Nparameters+t} = Valeursvect;

end

% To help reading DataDC
VectDataSheet = [2 3 4 5 6];

VectInfoSheet = 7:size(DataDC,2);


%% Data Recovery & Manipulation

   
frequency = cell(Nsweeps,1);
omega = cell(Nsweeps,1);
Conductance = cell(Nsweeps,1);
Capacitance = cell(Nsweeps,1);

for pos = 1:size(FilePathNAME,1)
                  
    
    
    frequency{pos,1} = MinFrequency:(MaxFrequency-MinFrequency)/...
        (Npoints(pos,1)-1):MaxFrequency;  

    omega{pos,1} = (frequency{pos,1}.*(2*pi))';
                             
    % Recover the data from the text file            
    FileText = fopen(FilePathNAME{pos,1},'rt');
    DataText = textscan(FileText,'%f64%f64%f64');
    
    Capacitance(pos,1) = DataText(1,2);
    Conductance(pos,1) = DataText(1,3);
    
    % Save all the Data in a cell DataDC
    DataDC{pos+1,1} = FilePathNAME{pos,1};
    DataDC(pos+1,2) = frequency(pos,1);
    DataDC(pos+1,3) = omega(pos,1);
    DataDC(pos+1,4) = Conductance(pos,1);
    DataDC(pos+1,6) = Capacitance(pos,1);

end


% We plot Gp(w)/w

DynamicConductance = cell(Nsweeps,1);

choice = 0;

ConsiderRs = 0;

ConsiderOx = 0;

% Before anything, ask if he wants to consider Rs and Cox

% Ask the person if he wants to save it
promptMessage = sprintf('Do you want to Consider Rs or Cox?');

buttonConsiderRsCox = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');

% If it is a no ConsiderRs and ConsiderOx remains unchanged
if strcmpi(buttonConsiderRsCox, 'Yes')

    % Ask for the user to provide the file
    
    [Filename, Pathname, Filterindex] =...
            uigetfile('All Files','Select your file','MultiSelect','off');


    % If he cancels it              

    if Filterindex == 0

        % While no choice has been made
        while Filterindex == 0 && choice == 0
        
            promptMessage = sprintf('You have failed to Select a FIle, do you still want to use Rs or Cox ?');

            buttonConsiderRsCoxAgain = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');
            
            if strcmpi(buttonConsiderRsCoxAgain,'Yes')
               
                    [Filename, Pathname, Filterindex] =...
            uigetfile('All Files','Select your file','MultiSelect','off');
                
            else
                
                % In case he doesn't want to use Rs 
                choice = 1;
                
            end
           
        end
        
        % In case he decided to choose an Rs file 
        if Filterindex ~= 0
            
            
            FilePathName = [Pathname,Filename];
            
            [ SeriesResistance,OxydeCapacitance]...
                                = Recover_Cox_Rs(...
                                      Npoints,MinFrequency,MaxFrequency,...
                                      FilePathName);
                                  
             
            promptMessage = sprintf('Do you want to consider Rs ?');

            buttonConsiderRs = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');
            
            if strcmpi(buttonConsiderRs,'Yes')
               
               ConsiderRs = 1;
                  
            end    
            
            
            promptMessage = sprintf('Do you want to consider Cox ?');

            buttonConsiderCox = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');
            
            if strcmpi(buttonConsiderCox,'Yes')
               
               ConsiderOx = 1;
                  
            end   
        end  
        
    % if he doesn't cancels it
    else
      
        FilePathName = [Pathname,Filename];

        [ SeriesResistance,OxydeCapacitance]...
                            = Recover_Cox_Rs(...
                                  Npoints,MinFrequency,MaxFrequency,...
                                  FilePathName);


        promptMessage = sprintf('Do you want to consider Rs ?');

        buttonConsiderRs = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');

        if strcmpi(buttonConsiderRs,'Yes')

           ConsiderRs = 1;

        end    


        promptMessage = sprintf('Do you want to consider Cox ?');

        buttonConsiderCox = questdlg(promptMessage, '..', 'Yes', 'No', 'Yes');

        if strcmpi(buttonConsiderCox,'Yes')

           ConsiderOx = 1;

        end 
    end                         
end



% Don't consider anything
if ConsiderRs == 0 && ConsiderOx ==0

    for t = 1:size(FilePathNAME,1)

        % The Cox must be taken in account to calculate Gp(w)/w
        Coxvect = ones(size(Capacitance{t,1}))*Cox(t,1);
        deltaC = Coxvect - Capacitance{t,1};

        DynamicConductance{t,1} = (omega{t,1}.*Conductance{t,1}*(Cox(t,1)^2))./...
                                  (Conductance{t,1}.^2 +...
                                            (omega{t,1}.^2).*(deltaC.^2));

        DataDC(t+1,5) = DynamicConductance(t,1);

    end
    
% Only Consider the Series Resistance value    
elseif ConsiderRs == 1 && ConsiderOx == 0
   
DataDC(2,8) = SeriesResistance(1,1);    

    for t = 1:size(FilePathNAME,1)

        % The Cox must be taken in account to calculate Gp(w)/w
        Coxvect = ones(size(Capacitance{t,1}))*Cox(t,1);
        
        % To take into account the Series Resistance into the capacitance
        C1stterm = (1 - SeriesResistance{1,1}.*Conductance{t,1}).^2;
        C2ndterm = (omega{t,1}.*SeriesResistance{1,1}.*Capacitance{t,1}).^2;
        CapacitanceC = (Capacitance{t,1})./(C1stterm + C2ndterm);
        
        % To take into account the Series Resistance inot the conductance
        GCnumerator = ((omega{t,1}.^2).*SeriesResistance{1,1}.*...
                            Capacitance{t,1}.*CapacitanceC) -...
                                Conductance{t,1};
        GCdenominator = (SeriesResistance{1,1}.*Conductance{t,1} - 1);
        ConductanceC = GCnumerator./GCdenominator;
        
        
        deltaC = Coxvect - CapacitanceC;

        % Tunneling conducntace set to zero
        DynamicConductance{t,1} = (omega{t,1}.*ConductanceC.*(Cox(t,1)^2))./...
                                  (ConductanceC.^2 +...
                                            (omega{t,1}.^2).*(deltaC.^2));

        DataDC(t+1,5) = DynamicConductance(t,1);

    end
    
    
% Only consider the Oxyde capacitance values    
elseif ConsiderOx == 1 && ConsiderRs == 0
    
DataDC(2,7) = OxydeCapacitance(1,1);    
    
    for t = 1:size(FilePathNAME,1)

        % The Cox must be taken in account to calculate Gp(w)/w
        deltaC = OxydeCapacitance{1,1} - Capacitance{t,1};

        DynamicConductance{t,1} = (omega{t,1}.*Conductance{t,1}.*(OxydeCapacitance{1,1}.^2))./...
                                  (Conductance{t,1}.^2 +...
                                            (omega{t,1}.^2).*(deltaC.^2));

        DataDC(t+1,5) = DynamicConductance(t,1);

    end    
    
    
% Consider Both    
elseif ConsiderOx == 1 && ConsiderRs == 1
    
DataDC(2,8) = SeriesResistance(1,1);    
DataDC(2,7) = OxydeCapacitance(1,1);    


    for t = 1:size(FilePathNAME,1)

        
        % To take into account the Series Resistance into the capacitance
        C1stterm = (1 - SeriesResistance{1,1}.*Conductance{t,1}).^2;
        C2ndterm = (omega{t,1}.*SeriesResistance{1,1}.*Capacitance{t,1}).^2;
        CapacitanceC = (Capacitance{t,1})./(C1stterm + C2ndterm);
        
        % To take into account the Series Resistance inot the conductance
        GCnumerator = ((omega{t,1}.^2).*SeriesResistance{1,1}.*...
                            Capacitance{t,1}.*CapacitanceC) -...
                                Conductance{t,1};
        GCdenominator = (SeriesResistance{1,1}.*Conductance{t,1} - 1);
        ConductanceC = GCnumerator./GCdenominator;
        
        
        
        deltaC = OxydeCapacitance{1,1} - CapacitanceC;

        % Tunneling conducntace set to zero
        DynamicConductance{t,1} = (omega{t,1}.*ConductanceC.*...
                                            (OxydeCapacitance{1,1}.^2))./...
                                  (ConductanceC.^2 +...
                                            (omega{t,1}.^2).*(deltaC.^2));

        DataDC(t+1,5) = DynamicConductance(t,1);

    end
    


end

%% Plot

figureDC = figure('Name',figname);
    
cmap = jet(size(FilePathNAME,1));

subplot(3,2,[3,4])

hold all


handlesDynamicCondTransNorm = ones(1,size(FilePathNAME,1));
minAxis = ones(size(FilePathNAME,1),1);
maxAxis = ones(size(FilePathNAME,1),1);


for nplot = 1:size(FilePathNAME,1)

handlesDynamicCondTransNorm(nplot) = plot(omega{nplot,1},DynamicConductance{nplot,1},'-',...
                                        'Color',cmap(nplot,:));

minAxis(nplot) = min(DynamicConductance{nplot,1});
maxAxis(nplot) = max(DynamicConductance{nplot,1});
        
end  

xlabel('\omega (Hz)');

title([figname '-' 'Dynamic Conductance (MOS)']);

ylabel('Gp(\omega)/\omega');

grid ON;
axis([MinFrequency*(2*pi) MaxFrequency*(2*pi) min(minAxis) ...
                        (max(maxAxis))]); 
legend(handlesDynamicCondTransNorm,legends')

hold off

subplot(3,2,[5,6])

hold all


handlesCond = ones(1,size(FilePathNAME,1));
minAxis = ones(size(FilePathNAME,1),1);
maxAxis = ones(size(FilePathNAME,1),1);


for nplot2 = 1:size(FilePathNAME,1)


    handlesCond(nplot2) = plot(omega{nplot2,1},Conductance{nplot2,1},'-',...
                                        'Color',cmap(nplot2,:));

    minAxis(nplot2) = min(Conductance{nplot2,1});
    maxAxis(nplot2) = max(Conductance{nplot2,1});
       
end

xlabel('\omega (Hz)');

title(figname);

ylabel('Gp(\omega)');


grid ON;
axis([MinFrequency*(2*pi) MaxFrequency*(2*pi) min(minAxis) ...
                        (max(maxAxis))]);
                    
legend(handlesCond,legends')
hold off



subplot(3,2,[1 2])

hold all

handlesCapacitance = ones(1,size(FilePathNAME,1));



for nplot3 = 1:size(FilePathNAME,1)

    handlesCapacitance(nplot3) = plot(omega{nplot3,1},Capacitance{nplot3,1},'-',...
                                        'Color',cmap(nplot3,:));

    minAxis(nplot3) = min(Capacitance{nplot3,1});
    maxAxis(nplot3) = max(Capacitance{nplot3,1});

end

xlabel('\omega (Hz)');
ylabel('Capacitance(F)');


title('Capacitance');

grid ON;
axis([MinFrequency*(2*pi) MaxFrequency*(2*pi) min(minAxis) ...
                        (max(maxAxis))]); 
                    
legend(handlesCapacitance,legends')
hold off

end

