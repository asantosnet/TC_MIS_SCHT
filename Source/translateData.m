function [Nsweeps,Valeurs,Npoints,MinFrequency,MaxFrequency,...
                   FilePathNAME,figname,Gain_AOP,sweepVoltage,Cox ] = translateData...
                                    ( DataList,mode,nplot)
% This function gets the Data from the user and recovers the nescessary
% values from it.
%   Nsweeps = 3
%   Valeurs = {'Vg';2;3;4,'Vg';2;3;4,'Vg';2;3;4}
%   Npoints = [151,152,153]
%   MinFrequency =  [10]
%   MaxFrequency = [100000000]
%   FilePathName = {'C:\Users\Q\';'12DBM(1)';'C:\Users\Q\'}
%   figname = ['Title']
%   Gain_AOP = [1000;1000;1000]
%   sweepVoltage = [1,2,3,4,5]
%
%
%


    sweepVoltage = zeros(2,2);
    MinFrequency = 0;
    MaxFrequency = 0;
    Nsweeps = 0;
    Gain_AOP = zeros(2,2);
    Cox = zeros(2,2);
    
if strcmp(mode,'Conductance') ||...
          strcmp(mode,'Transconductance')
   
    Nsweeps = size(DataList{nplot,1},1)-1;

    FilePathNAME = DataList{nplot,1}(2:end,1);
    Valeurs = DataList{nplot,1}(1:end,3:(end-4));
    Gain_AOP = cell2mat(DataList{nplot,1}(2:end,...
                        size(DataList{nplot,1},2)-3));
    Npoints = cell2mat(DataList{nplot,1}(2:end,...
        size(DataList{nplot,1},2)-2));                

    MinFrequency = DataList{nplot,1}{2,size(DataList{nplot,1},2)-1};
    MaxFrequency = DataList{nplot,1}{2,size(DataList{nplot,1},2)};
    figname = DataList{nplot,1}{1,2};
    
elseif strcmp(mode,'I-V')

    
    FilePathNAME = DataList{nplot,1}(2:end,1);
    Valeurs = DataList{nplot,1}(1:end,3:(end-4));
    Pas = cell2mat(DataList{nplot,1}(2:end,...
                        size(DataList{nplot,1},2)-3));
    
    Vmin = DataList{nplot,1}{2,size(DataList{nplot,1},2)-1};
    Vmax = DataList{nplot,1}{2,size(DataList{nplot,1},2)};
    
    % I will only get one value for pas, Vmin and Vmax
    
    sweepVoltage = [Vmin:Pas(1):Vmax];
   
    Npoints = cell2mat(DataList{nplot,1}(2:end,...
        size(DataList{nplot,1},2)-2));                
    figname = DataList{nplot,1}{1,2};
    
elseif strcmp(mode,'Dynamic Conductance-Schotkky')
    
      
    Nsweeps = size(DataList{nplot,1},1)-1;

    FilePathNAME = DataList{nplot,1}(2:end,1);
    Valeurs = DataList{nplot,1}(1:end,3:(end-3));

    Npoints = cell2mat(DataList{nplot,1}(2:end,...
        size(DataList{nplot,1},2)-2));                

    MinFrequency = DataList{nplot,1}{2,size(DataList{nplot,1},2)-1};
    MaxFrequency = DataList{nplot,1}{2,size(DataList{nplot,1},2)};
    figname = DataList{nplot,1}{1,2};    
    
  
elseif strcmp(mode,'Dynamic Conductance - MOS')  
      
    Nsweeps = size(DataList{nplot,1},1)-1;

    FilePathNAME = DataList{nplot,1}(2:end,1);
    Valeurs = DataList{nplot,1}(1:end,3:(end-4));
    Cox = cell2mat(DataList{nplot,1}(2:end,...
                        size(DataList{nplot,1},2)-3));
    Npoints = cell2mat(DataList{nplot,1}(2:end,...
        size(DataList{nplot,1},2)-2));                

    MinFrequency = DataList{nplot,1}{2,size(DataList{nplot,1},2)-1};
    MaxFrequency = DataList{nplot,1}{2,size(DataList{nplot,1},2)};
    figname = DataList{nplot,1}{1,2};
    
elseif strcmp(mode,'Calculate Rs and Cox')
    
    Nsweeps = size(DataList{nplot,1},1)-1;

    FilePathNAME = DataList{nplot,1}(2:end,1);
    Valeurs = DataList{nplot,1}(1:end,3:(end-3));

    Npoints = cell2mat(DataList{nplot,1}(2:end,...
        size(DataList{nplot,1},2)-2));                

    MinFrequency = DataList{nplot,1}{2,size(DataList{nplot,1},2)-1};
    MaxFrequency = DataList{nplot,1}{2,size(DataList{nplot,1},2)};
    figname = DataList{nplot,1}{1,2};       
    

    
end
            

end

