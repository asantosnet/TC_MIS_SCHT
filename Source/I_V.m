function [handlesIV,figureIV] = I_V( Valeurs,sweepVoltage,Npoints,...
                             FilePathNAME,figname,xlabelstring,ylabelstring)
%   This function recevies the valeus from the user after they have bee
%  "translated" by the translateData function and calculate and plot
%   the I-V
%   for the input definitions see translateData
%   handlesIV = [handler1 handler2 ] 
%   figureIV = the handler of the figure plotting those plots. To get the
%   plots use get(figureIV,'Children')
%






%% Data Recovery & Manipulation
        

NVpoints = size(sweepVoltage,2);
    
FileText = fopen(FilePathNAME{1,1},'rt');

DataText = textscan(FileText,'%f64%f64');


Vsall = DataText{1,1};
Vsvect = Vsall(1:Npoints,1);

Isall = DataText{1,2};

IVvect = ones((NVpoints+1),Npoints);
IVvect(1,:) = Vsvect';

start = 1:Npoints:(Npoints*(NVpoints)); 
stop = Npoints:Npoints:(Npoints*(NVpoints));



for nV = 1:NVpoints
    
    
    IVvect((nV+1),:) = Isall(start(nV):stop(nV),1);

    
    
end

I_Vvect = ones((NVpoints+1),Npoints+1);

I_Vvect(2:end,1) = sweepVoltage';
I_Vvect(:,2:end) = IVvect;



legends = cell(1,size(sweepVoltage,2));

for t = 1:NVpoints


    legends{1,t} = [Valeurs{2,1} ' = ' num2str(sweepVoltage(t))];

end


%% Plot

figureIV = figure('name',figname);

hold on

handlesIV = ones(1,size(sweepVoltage,2));
minAxis = ones(size(sweepVoltage,2),1);
maxAxis = ones(size(sweepVoltage,2),1);

for nplot = 1:NVpoints
    
    handlesIV(nplot) = plot(I_Vvect(1,2:end),I_Vvect(nplot+1,2:end),'-');
    
    
    minAxis(nplot) = min(IVvect(nplot+1,1));
    maxAxis(nplot) = max(IVvect(nplot+1,1));
    
    
end

set(handlesIV,'Color',[0 0 1]);
set(handlesIV(1),'Color',[0 0 0]);

xlabel(xlabelstring);
ylabel(ylabelstring);
grid ON;

legend(handlesIV,legends)


hold off


end

