function [ DataDC, VectDataSheet, VectInfoSheet]...
                                = Calc_Cox_Rs(Nsweeps,Valeurs,...
                                      Npoints,MinFrequency,MaxFrequency,...
                                      FilePathNAME,figname)
%   This function recevies the valeus from the user after they have bee
%  "translated" by the translateData function and calculate and plot
%   the Dynamic Conducntace (Gp(w)/w) as well as the Conducntace(Gp) and Cp
%   for the input definitions see translateData
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
Nparameters = 7;

DataDC = cell((Nsweeps+1),(size(Valeurs,2)+ Nparameters));

DataDC{1,1} = {'Files'};

DataDC(1,2:7) = {'Frequency','\omega','Conductance(Gp)',...
                        'Capacitance Cp','C - oxyde',...
                        'Series Resistance Rs'};
                                                           
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
VectDataSheet = [2 3 4 5 6 7];

VectInfoSheet = 8:size(DataDC,2);


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
    DataDC(pos+1,5) = Capacitance(pos,1);

end


% We calculate the series ressitance and Oxyde capacitance
% using the conductance and capacitance
% in accumulation.
SeriesResistance = cell(Nsweeps,1);
OxydeCapacitance = cell(Nsweeps,1);

for t = 1:size(FilePathNAME,1)

    
    SeriesResistance{t,1} = (Conductance{t,1})./...
                              (Conductance{t,1}.^2 +...
                                   (omega{t,1}.^2).*(Capacitance{t,1}.^2));
                               
                               
                               
    OxydeCapacitance{t,1} = Capacitance{t,1}.*...
                 (1+(Conductance{t,1}./(omega{t,1}.*Capacitance{t,1})).^2);
    
    DataDC(t+1,7) = SeriesResistance(t,1);
    DataDC(t+1,6) = OxydeCapacitance(t,1);
    
    
end


%% Plot

figureDC = figure('Name',figname);
    
cmap = jet(size(FilePathNAME,1));

subplot(3,2,[3,4])

hold all


handlesSeriesResistance = ones(1,size(FilePathNAME,1));
minAxis = ones(size(FilePathNAME,1),1);
maxAxis = ones(size(FilePathNAME,1),1);


for nplot = 1:size(FilePathNAME,1)

handlesSeriesResistance(nplot) = plot(omega{nplot,1},SeriesResistance{nplot,1},'-',...
                                        'Color',cmap(nplot,:));

minAxis(nplot) = min(SeriesResistance{nplot,1});
maxAxis(nplot) = max(SeriesResistance{nplot,1});
        
end  

xlabel('\omega (Hz)');

title([figname '-' 'Series Resistance']);

ylabel('Rs');

grid ON;
axis([MinFrequency*(2*pi) MaxFrequency*(2*pi) min(minAxis) ...
                        (max(maxAxis))]); 
legend(handlesSeriesResistance,legends')

hold off


subplot(3,2,[5,6])

hold all


handlesOxydeCapacitance = ones(1,size(FilePathNAME,1));
minAxis = ones(size(FilePathNAME,1),1);
maxAxis = ones(size(FilePathNAME,1),1);


for nplot4 = 1:size(FilePathNAME,1)


    handlesOxydeCapacitance(nplot4) = plot(omega{nplot4,1},OxydeCapacitance{nplot4,1},'-',...
                                        'Color',cmap(nplot4,:));

    minAxis(nplot4) = min(OxydeCapacitance{nplot4,1});
    maxAxis(nplot4) = max(OxydeCapacitance{nplot4,1});
       
end

xlabel('\omega (Hz)');

title(figname);

ylabel('Oxyde Capacitance (F)');


grid ON;
axis([MinFrequency*(2*pi) MaxFrequency*(2*pi) min(minAxis) ...
                        (max(maxAxis))]);
                    
legend(handlesOxydeCapacitance,legends')
hold off

subplot(3,2,2)

hold all

handlesConductance = ones(1,size(FilePathNAME,1));



for nplot3 = 1:size(FilePathNAME,1)

    
handlesConductance(nplot3) = plot(omega{nplot3,1},Conductance{nplot3,1},'-',...
                                        'Color',cmap(nplot3,:));

    minAxis(nplot3) = min(Conductance{nplot3,1});
    maxAxis(nplot3) = max(Conductance{nplot3,1});

end

xlabel('\omega (Hz)');
ylabel('Measured Conductance Gp(\omega)');


title('Conductance');

grid ON;
axis([MinFrequency*(2*pi) MaxFrequency*(2*pi) min(minAxis) ...
                        (max(maxAxis))]); 
                    
legend(handlesConductance,legends')
hold off

subplot(3,2,1)

hold all

handlesCapacitance = ones(1,size(FilePathNAME,1));



for nplot3 = 1:size(FilePathNAME,1)

    handlesCapacitance(nplot3) = plot(omega{nplot3,1},Capacitance{nplot3,1},'-',...
                                        'Color',cmap(nplot3,:));

    minAxis(nplot3) = min(Capacitance{nplot3,1});
    maxAxis(nplot3) = max(Capacitance{nplot3,1});

end

xlabel('\omega (Hz)');
ylabel('Measured Capacitance(F)');


title('Capacitance');

grid ON;
axis([MinFrequency*(2*pi) MaxFrequency*(2*pi) min(minAxis) ...
                        (max(maxAxis))]); 
                    
legend(handlesCapacitance,legends')
hold off

end

