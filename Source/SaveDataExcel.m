function SaveDataExcel( Data,Nsweeps,figname,Npoints,VectDataSheet,VectInfoSheet)
% Save the data as an Excel file.
% Each set of Data corresponding from one file will be put into one sheet
% The first sheet will contain the name of the files, as well as other
% relevant information, such as the Gain_AOP, the values that were used for
% normalization as well as any variable initially chosen by the user.
% 
% For DataCTPG see example file (Variables Test)
% Nsweeps is equivalent to the number of sheets -1 
% VectDataSheet = [2 3 4 5 6 7 8];
% 
% VectInfoSheet = [9 10 11 12];



% Name of the file and sheets

NameExcel = [figname,regexprep(num2str(fix(clock)),'\W','')];
NameSheets = cell(Nsweeps+1,1);


% We are going to save the file in the same location as the original files

removeBar = strsplit(Data{2,1},'\');

location = strsplit(Data{2,1},removeBar{end});



% Remove any character that is not allowed (Excel)

NameExcel = regexprep(NameExcel,']','');
NameExcel = regexprep(NameExcel,'[','');
NameExcel = regexprep(NameExcel,'*','');
NameExcel = regexprep(NameExcel,':','');
NameExcel = regexprep(NameExcel,'?','');
NameExcel = regexprep(NameExcel,'/','');
NameExcel = regexprep(NameExcel,'\','');
NameExcel = regexprep(NameExcel,'>','');
NameExcel = regexprep(NameExcel,'<','');
NameExcel = regexprep(NameExcel,'|','');


filename = [location{1},NameExcel];



% So it respects the size condition (Excel)
if size(filename ,2) > 218

    filename  = filename(1:218);
end  

h = waitbar(0,'Saving Data, please wait...');


% To save in one sheet the data corresponding to one
% sweep (e.g. Transdoncutance, conductance, etc...)

for n = 1:Nsweeps
    
    
    A = cell(Npoints(n)+1,size(VectDataSheet,2)+1);
    
    % The sheet name
    Data{n+1,2} = Data{n+1,2}';
    NameSheet = strsplit(Data{n+1,1},'\');
    
    
    % Remove any character that is not allowed
    
    NameSheet = regexprep(NameSheet,']','');
    NameSheet = regexprep(NameSheet,'[','');
    NameSheet = regexprep(NameSheet,'*','');
    NameSheet = regexprep(NameSheet,':','');
    NameSheet = regexprep(NameSheet,'?','');
    NameSheet = regexprep(NameSheet,'/','');
    NameSheet = regexprep(NameSheet,'\','');
    NameSheet = regexprep(NameSheet,'>','');
    NameSheet = regexprep(NameSheet,'<','');
    NameSheet = regexprep(NameSheet,'|','');

    
    % So it respects the size condition (Excel thing)
    if size(NameSheet{end} ,2) > 30
        
        NameSheet{end}  = NameSheet{end}(1:30);

       

        
    end

    % Header for each column
    NameSheets{n+1,1} = NameSheet{end};
    
    
        
    for nCol = 1:size(VectDataSheet,2)
        
        % Header for each column
        A{1,nCol} = Data{1,VectDataSheet(nCol)};
        
        intermediary = num2cell(Data{n+1, VectDataSheet(nCol)});
        
        % In case the cell is empty so it doens't gives a size erro in the
        % line bellow
        if isempty(intermediary) == 1
            
            intermediary = num2cell(zeros(size(A,1)-1,1));
        
        end
        
        % The value to be insered in each point in the column
        A(2:end,nCol) = intermediary(:,1);
          
    end
    
    % e.g. A1:B5 for 5x2 vect
    firstCol = xlsColNum2Str(1);
    lastCol = xlsColNum2Str(7);
    
    xlRange = [firstCol{1},num2str(1),':',lastCol{1},num2str(size(A,1))];
    
    % write the excel file
    xlswrite(filename,A,NameSheet{end},xlRange);
    
    waitbar(n/(2*(Nsweeps+1)));
    
end

% For the first sheet with some information


NameSheets{1,1}  = 'Information';

A = cell(Nsweeps+1,size(VectInfoSheet,2)+1);

A{1,1} = Data{1,1};

A(2:end,1) = NameSheets(2:end,1);

for nCol = 1:(size(VectInfoSheet,2))
    
    A{1,nCol+1} = Data{1,VectInfoSheet(nCol)};
        
    intermediary = num2cell(Data{2, VectInfoSheet(nCol)});
    
    % In case the cell is empty so it doens't gives a size erro in the
    % line bellow
    if isempty(intermediary) == 1

        intermediary = num2cell(zeros(size(A,1)-1,1));

    end
        
    A(2:(size(intermediary(:,1),1)+1),nCol+1) = intermediary(:,1);
    
    waitbar((nCol + n)/(2*(Nsweeps+1)));
end

firstCol = xlsColNum2Str(1);
lastCol = xlsColNum2Str(size(VectInfoSheet,2)+1);

xlRange = [firstCol{1},num2str(1),':',lastCol{1},num2str(size(A,1))];

xlswrite(filename,A,NameSheets{1,1},xlRange);

close(h);

end

