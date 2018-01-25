function [figureCTGP, DataCTPG] = Dynamic_Cond(mode,...
                                    Nsweeps,Valeurs,Gain_AOP,...
                                    Npoints,MinFrequency,MaxFrequency,...
                                    FilePathNAME,figname)
%   This function recevies the valeus from the user after they have bee
%  "translated" by the translateData function and calculate and plot
%   the Dynamic Conducntace (Gp(w)/w) as well as the Conducntace(Gp) and Cp
%   for the input definitions see translateData
%   figureCTGP = the handler of the figure plotting those plots. To get the
%   plots use get(figureCTGP,'Children') = [handlerPhase 
%                                           handlerGain
%                                           handlerLegend
%                                           handlerGain]
%   DataCTPG is a cell with everything [Add proper description here]
%   
%   Default is the normalized Transcondutance / Condutance, the value used
%   to make the normalization is the one at 10Hz . Modify the way that I am
%   normalizing it ? 

%% Initialization

DataCTPG = cell((Nsweeps+1),(size(Valeurs,2)+ 11));

DataCTPG{1,1} = {'Files'};

DataCTPG(1,2:8) = {'Frequence','Transconductance','Conductance',...
                        'Normalized Transconductance',...
                        'Normalized Conductance',...
                        'Phase','Gain'};
                                       
DataCTPG(1,9:11) = {'Gain_AOP','NC','NT'};

DataCTPG{2,9} = Gain_AOP;

legends = cell(1,Nsweeps);


for t = 1:Nsweeps

    for d = 1:size(Valeurs,2)
        
    legends{1,t} = [legends{1,t} ';' Valeurs{1,d} '=' num2str(Valeurs{t+1,d})];
    
    DataCTPG(1,(11+d)) = Valeurs(1,d);
    
    end

end


Valeursvect = ones(Nsweeps,1);

for t = 1:size(Valeurs,2)

    for d = 1:Nsweeps 
        Valeursvect(d,1) = Valeurs{d+1,t};
    end
    
    DataCTPG{2,11+t} = Valeursvect;

end

%% Data Recovery & Manipulation

   
frequency = cell(Nsweeps,1);
Gain = cell(Nsweeps,1);
Phase = cell(Nsweeps,1);

for pos = 1:size(FilePathNAME,1)
                  
    
    frequency{pos,1} = MinFrequency:(MaxFrequency-MinFrequency)/...
        (Npoints(pos,1)-1):MaxFrequency;  

                             
                
    FileText = fopen(FilePathNAME{pos,1},'rt');
    DataText = textscan(FileText,'%f64%f64%f64');
    
    Gain(pos,1) = DataText(1,2);
    Phase(pos,1) = DataText(1,3);
    
    DataCTPG{pos+1,1} = FilePathNAME{pos,1};
    DataCTPG(pos+1,2) = frequency(pos,1);
    DataCTPG(pos+1,8) = Gain(pos,1);
    DataCTPG(pos+1,7) = Phase(pos,1);

end



% Conductance mode or Transconductance mode masurement

 
if (strcmp(mode,'Conductance')) 
    
    
    ConductanceNormalized = cell(Nsweeps,1);
    Conductance = cell(Nsweeps,1);
    
    % To avoid problems afterwards
    TransconductanceNormalized = cell(Nsweeps,1);
    TransconductanceNormalized(:) = {0};
    Transconductance = cell(Nsweeps,1);
    Transconductance(:) = {0};
  
    NT = ones(size(FilePathNAME,1),1);
    NC = ones(size(FilePathNAME,1),1);
    
    for t = 1:size(FilePathNAME,1)
        
        Conductance{t,1} = (10.^(Gain{t,1}./20))./Gain_AOP(t,1);
        ConductanceNormalized{t,1} = Conductance{t,1} ./...
                                        Conductance{t,1}(1,1);
       
        NC(t,1) = Conductance{t,1}(1,1);
        DataCTPG(t+1,4) = Conductance(t,1);
        DataCTPG(t+1,6) = ConductanceNormalized(t,1);  
        
        % To avoid problems afterwards
        NT(t,1) = Transconductance{t,1}(1,1);                                
        DataCTPG(t+1,3) = Transconductance(t,1);
        DataCTPG(t+1,5) = TransconductanceNormalized(t,1);
        
    end
    
    DataCTPG{2,11} = NT;
    DataCTPG{2,10} = NC;

elseif (strcmp(mode,'Transconductance')) 

    TransconductanceNormalized = cell(Nsweeps,1);
    Transconductance = cell(Nsweeps,1);
    
    % To avoid problems afterwards
    ConductanceNormalized = cell(Nsweeps,1);
    ConductanceNormalized(:) = {0};
    Conductance = cell(Nsweeps,1);
    Conductance(:) = {0};
    
    NT = ones(size(FilePathNAME,1),1);
    NC = ones(size(FilePathNAME,1),1);
    
    for t = 1:size(FilePathNAME,1)
    
         
        
        Transconductance{t,1} = (10.^(Gain{t,1}./20))./Gain_AOP(t,1);
        TransconductanceNormalized{t,1} = Transconductance{t,1}...
                                            ./ Transconductance{t,1}(1,1);
        
        
        NT(t,1) = Transconductance{t,1}(1,1);                                
        DataCTPG(t+1,3) = Transconductance(t,1);
        DataCTPG(t+1,5) = TransconductanceNormalized(t,1);
        
        % To avoid problmes afterwards
        NC(t,1) = Conductance{t,1}(1,1);
        DataCTPG(t+1,4) = Conductance(t,1);
        DataCTPG(t+1,6) = ConductanceNormalized(t,1);
                                        
    
    end
    
    DataCTPG{2,10} = NC;
    DataCTPG{2,11} = NT;
        
end




%% Plot

figureCTGP = figure('Name',figname);
    

subplot(3,2,[3,4])

hold all


handlesCondTransNorm = ones(1,size(FilePathNAME,1));
minAxis = ones(size(FilePathNAME,1),1);
maxAxis = ones(size(FilePathNAME,1),1);


for nplot = 1:size(FilePathNAME,1)

    if (strcmp(mode,'Conductance'))

        handlesCondTransNorm(nplot) = plot(frequency{nplot,1},ConductanceNormalized{nplot,1},'-');

        minAxis(nplot) = min(ConductanceNormalized{nplot,1});
        maxAxis(nplot) = max(ConductanceNormalized{nplot,1});

    elseif (strcmp(mode,'Transconductance')) 

        handlesCondTransNorm(nplot) = plot(frequency{nplot,1},...
        TransconductanceNormalized{nplot,1},'-');

        minAxis(nplot) = min(TransconductanceNormalized{nplot,1});
        maxAxis(nplot) = max(TransconductanceNormalized{nplot,1});


    end

end

xlabel('Frequency (Hz)');

title([figname '-' 'Normalized']);

if (strcmp(mode,'Conductance'))
    
    ylabel('Gds(f)/ Gds(10Hz)');

elseif (strcmp(mode,'Transconductance')) 
    
    ylabel('Gm(f)// Gm(10Hz)');

end

grid ON;
axis([MinFrequency MaxFrequency min(minAxis) ...
                        (max(maxAxis))]); 
legend(handlesCondTransNorm,legends')

hold off

subplot(3,2,[5,6])

hold all


handlesCondTrans = ones(1,size(FilePathNAME,1));
minAxis = ones(size(FilePathNAME,1),1);
maxAxis = ones(size(FilePathNAME,1),1);


for nplot = 1:size(FilePathNAME,1)

    if (strcmp(mode,'Conductance'))

        handlesCondTrans(nplot) = plot(frequency{nplot,1},Conductance{nplot,1},'-');

        minAxis(nplot) = min(Conductance{nplot,1});
        maxAxis(nplot) = max(Conductance{nplot,1});
        
    elseif (strcmp(mode,'Transconductance')) 

        handlesCondTrans(nplot) = plot(frequency{nplot,1},...
        Transconductance{nplot,1},'-');

        minAxis(nplot) = min(Transconductance{nplot,1});
        maxAxis(nplot) = max(Transconductance{nplot,1});


    end

end

xlabel('Frequency (Hz)');

title(figname);


if (strcmp(mode,'Conductance'))
    
    ylabel('Gds(f)');

elseif (strcmp(mode,'Transconductance')) 
    
    ylabel('Gm(f)');

end

grid ON;
axis([MinFrequency MaxFrequency min(minAxis) ...
                        (max(maxAxis))]); 
legend(handlesCondTrans,legends')
hold off



subplot(3,2,1)

hold all

handlesGain = ones(1,size(FilePathNAME,1));



for nplot = 1:size(FilePathNAME,1)

    handlesGain(nplot) = plot(frequency{nplot,1},Gain{nplot,1},'-');

    minAxis(nplot) = min(Gain{nplot,1});
    maxAxis(nplot) = max(Gain{nplot,1});

end

xlabel('Frequency (Hz)');
ylabel('Gain(Db)');


title('Gain');

grid ON;
axis([MinFrequency MaxFrequency min(minAxis) ...
                        (max(maxAxis))]); 


hold off


subplot(3,2,2)

hold all

handlesPhase = ones(1,size(FilePathNAME,1));



for nplot = 1:size(FilePathNAME,1)

    handlesPhase(nplot) = plot(frequency{nplot,1},Phase{nplot,1},'-');

    minAxis(nplot) = min(Phase{nplot,1});
    maxAxis(nplot) = max(Phase{nplot,1});

end

xlabel('Frequency (Hz)');
ylabel('Phase');


title('Phase');

grid ON;
axis([MinFrequency MaxFrequency min(minAxis) ...
                        (max(maxAxis))]); 


hold off



end

