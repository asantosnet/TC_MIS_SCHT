function SaveDataExcelCT( DataCTPG,Nsweeps,figname,Npoints)
% Save the data as an Excel file.
% Each set of Data corresponding from one file will be put into one sheet
% The first sheet will contain the name of the files, as well as other
% relevant information, such as the Gain_AOP, the values that were used for
% normalization as well as any variable initially chosen by the user.
% 
% For DataCTPG see example file (Variables Test)
% Nsweeps is equivalent to the number of sheets -1 



% Name of the file and sheets

NameExcel = [figname,regexprep(num2str(fix(clock)),'\W','')];
NameSheets = cell(Nsweeps+1,1);


% We are going to save the file in the same location as the original files

removeBar = strsplit(DataCTPG{2,1},'\');

location = strsplit(DataCTPG{2,1},removeBar{end});



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
    
    
    A = cell(Npoints(n)+1,7);
    
    % The sheet name
    DataCTPG{n+1,2} = DataCTPG{n+1,2}';
    NameSheet = strsplit(DataCTPG{n+1,1},'\');
    
    
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

    
    NameSheets{n+1,1} = NameSheet{end};
    
    for nCol = 1:7
        
        % Header for each column
        A{1,nCol} = DataCTPG{1,nCol +1};
        
        intermediary = num2cell(DataCTPG{n+1, nCol+1});
        
        % The value to be insered in each point in the column
        A(2:end,nCol) = intermediary(:,1);
          
    end
    
    % e.g. A1:B5 for 5x2 vect
    firstCol = xlsColNum2Str(1);
    lastCol = xlsColNum2Str(7);
    
    xlRange = [firstCol{1},num2str(1),':',lastCol{1},num2str(size(A,1))];
    
    % write the excel file
    xlswrite(filename,A,NameSheet{end},xlRange);
    
    waitbar(n/(Nsweeps+1));
    
end

% For the first sheet with some information

NameSheets{1,1}  = 'Information';

A = cell(Nsweeps+1,size(DataCTPG,2)-7);

A{1,1} = DataCTPG{1,1};
A(2:end,1) = NameSheets(2:end,1);


for nCol = 1:(size(DataCTPG,2)-8)
    
    A{1,nCol+1} = DataCTPG{1,nCol+8};
        
    intermediary = num2cell(DataCTPG{2, nCol+8});
        
    A(2:end,nCol+1) = intermediary(:,1);
    
end

firstCol = xlsColNum2Str(1);
lastCol = xlsColNum2Str(size(DataCTPG,2)-7);

xlRange = [firstCol{1},num2str(1),':',lastCol{1},num2str(size(A,1))];

xlswrite(filename,A,NameSheets{1,1},xlRange);

close(h);

end

