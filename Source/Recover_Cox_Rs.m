function [ SeriesResistance,OxydeCapacitance]...
                                = Recover_Cox_Rs(...
                                      Npoints,MinFrequency,MaxFrequency,...
                                      FilePathName)
%   This function calculates the Series Resistance as well as the oxyde
%   capacitance in function of the conductance and capacitance given by
%   the user

%% Data Recovery & Manipulation

   
Nsweeps = 1; % Only one file is possible

frequency = cell(Nsweeps,1);
omega = cell(Nsweeps,1);
Conductance = cell(Nsweeps,1);
Capacitance = cell(Nsweeps,1);           
    
frequency{1,1} = MinFrequency:(MaxFrequency-MinFrequency)/...
                    (Npoints(1,1)-1):MaxFrequency;  

omega{1,1} = (frequency{1,1}.*(2*pi))';

% Recover the data from the text file            
FileText = fopen(FilePathName,'rt');
DataText = textscan(FileText,'%f64%f64%f64');

Capacitance(1,1) = DataText(1,2);
Conductance(1,1) = DataText(1,3);
    


% We calculate the series ressitance and Oxyde capacitance
% using the conductance and capacitance
% in accumulation.

SeriesResistance = cell(1,1);
OxydeCapacitance = cell(1,1);

SeriesResistance{1,1} = (Conductance{1,1})./...
                          (Conductance{1,1}.^2 +...
                               (omega{1,1}.^2).*(Capacitance{1,1}.^2));



OxydeCapacitance{1,1} = Capacitance{1,1}.*...
             (1+(Conductance{1,1}./(omega{1,1}.*Capacitance{1,1})).^2);
         
         
         
    
end