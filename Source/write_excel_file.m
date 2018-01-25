function  [e,eWorkSheets,eWorkbook] = write_excel_file(Range,Data, name, ...
    sheets,location,CreatVect,varargin)
%[e,eWorkSheets,eWorkbook] = write_excel_file(Range,Data, name, ...
%                                    sheets,location,CreatVect)
%[e,eWorkSheets,eWorkbook] = write_excel_file(Range,Data, name, ...
%                                    sheets,location,CreatVect,excel)
%[e,eWorkSheets,eWorkbook] = write_excel_file(Range,Data, name, ...
%                                    sheets,location,CreatVect,Header)
%[e,eWorkSheets,eWorkbook] = write_excel_file(Range,Data, name, ...
%                                    sheets,location,CreatVect,excel,Header)
%   This function writes data in one excel file
%
%   INPUT
%
%   In Data (a cell), each line has the data to put in the Sheet, as one
%   changes the Sheet, the line that will be read changes. Each point in
%   the Data cell is occupied by a colomn vector, which contains the data
%   to be written  in the corresponding column (otherwise the traspose
%   needs to be used when inputing the data in the excel file)
%
%   Header provide the name for each colonmn in the Sheet, as the
%   sheet changes, so does the line, needs to be an cell.
%
%   Range, same thing as the Header, but with the range of the lines that
%   will be used in the excel file, e.g. 'A1:A5', the header will go in A1
%
%   Name is the name of the Excel file
%
%   Sheets a cell with one row and in each column the name of the sheets
%
%   location  - where to save your file
%
%   REMEBER TO CLOSE THE excel workbook, eWorkSheets,eWorkbook and e
%   REMEMBERM TO lauch excel = actxserver('Excel.Application')
%   FOR WHEN CratVect(1,2) == 1 the location needs to be the same for where
%   the excel file you want use is already saved
%
%   OUTPUT
%
%   e is the actxserver
%
%   eWorkSheets is the WorkSheets object
%
%   eWorkbook is the used Workbook (i.e. the file)
%
%   e.g Header = {'tt' 'to' 'ti' 'te';'a' 'b' 'v' 'd'};
%       Range = {'A1:A3' 'B1:B3' 'C1:C3';'A1:A3' 'B1:B3' 'C1:C3'};
%       name = 'teste';
%       sheets = {'teste1' 'tests2'}; Attention, if CreatVect(1,2) == 0,
%       then this need to match Sheets that exist aleady in the eWorkbook
%       that will be used
%       location = 'C:\Users\Q\Desktop\Files\Internship - INL\Codigo_Matlab\';
%       Data = cell(2,3);
%       Data{1,1} = [1;2];
%       Data{1,2} = [1;3];
%       Data{1,3} = [3;3];
%       Data{2,1} = [1;2];
%       Data{2,2} = [1;3];
%       Data{2,3} = [3;3];
%       CreatVect dictates if there is the need to creat another workbook,
%       worksheet or actxserver eg. .
%                                   CreatNewExcel = 0; Takes the active
%                                   actxserver
%                                   CreatNewWorkSheet = 0; Takes the
%                                   already existing worksheets
%                                   CreatNewWorkbook = 0; Takes the active
%                                   Workbook
%
%       CreatVect = [CreatNewExcel CreatNewWorkbook CreatNewWorkSheet];
%       excel is the actxserver being used
%       ATTENTION : If a new actxserver is created, a new Workbook and
%       Worksheet also need to be created, same thing for Workbook and
%       Worksheet
%
%

%% Checking inputs

switch nargin
    
    case 6
        
        if CreatVect(1,1) ~= 1
            error('Error. \nactxserver input missing');
        end
        
    case 7
        
        % In case Header is desired and there is the need to creat and
        % actxserver
        if iscell(varargin{1}) && CreatVect(1,1) ~= 1
            
            error('Error. \nactxserver input missing');
            
        end
        
        % In case Header is desired and there is no need to created and
        % actxserver
        if iscell(varargin{1}) && all(CreatVect(1,:) == zeros(1,3))
            
            Header = varargin{1};
            
        end
        
        % In case Header is desired and there is the need to creat
        % everything
        if iscell(varargin{1}) && all(CreatVect(1,:) == ones(1,3))
            
            Header = varargin{1};
            
        end
        
        
        
        % In case an actxserver has been sent
        if (strcmp(class(varargin{1}),'COM.Excel_Application') &&...
                CreatVect(1,1) ~= 1)
            
            excel = varargin{1};
            Header = '';
        end
        
        % In case an actxserver has been sent
        if (strcmp(class(varargin{1}),'COM.Excel_Application') &&...
                all(CreatVect(1,:) == zeros(1,3)))
            
            warning('A new actxserver will be initialized, try changing CreatVect')
            Header = '';
            
        end
        
    case 8
        
        % GUARD if clause
        if (ischar(varargin{1}) || ischar(varargin{2})) &&...
                all(CreatVect(1,:) == zeros(1,3))
            
            error('Error. \nWrong input arguments; excel needs to be an actxserver')
            
        end
        
        % "Normal" if clause
        if (iscell(varargin{1}) &&...
                (strcmp(class(varargin{2}),'COM.Excel_Application')||...
                ischar(varargin{2})))
            
            Header = varargin{1};
            excel = varargin{2};
            
            
        elseif (iscell(varargin{2}) &&...
                (strcmp(class(varargin{1}),'COM.Excel_Application')||...
                ischar(varargin{1})))
            
            Header = varargin{2};
            excel = varargin{1};
            
        else
            error('Error. \nWrong input arguments')
        end
        
    otherwise
        
        error('Error. \nToo many/few input arguments')
        
end


%% Begining of the code

% Creat or not a new atxserver

if CreatVect(1,1)
    
    try
        
        e = actxserver('Excel.Application');
    catch
        
        e = [];
        
    end
elseif CreatVect(1,1) == 0
    
    e = excel;
end


% This checks if the file exists or not and change CreatVect accordingly,
% it only does that if CreatVect(1,2) == 1

if (CreatVect(1,2) && exist(fullfile(location,name),'file')==2)
    
    CreatVect(1,2) = 0; % So now it will only try to open the file
    
end

% Add or not a Workbook
eWorkbooks = e.Workbooks;

if CreatVect(1,2)
    
    eWorkbook = eWorkbooks.Add;
    eWorkbook.Activate;
    e.Visible = 1;
    
elseif CreatVect(1,2) == 0
    
    % Verify if the ActiveWorkbook is the one that we wanna work with,
    % otherwise, open a new Woorkbook, Otherwise, creat a new one.
    
    [eWorkbook,CreatVect(1,2)] = find_workbook (e,name,location);
    
    % In case he says I do not need to creat a sheet, I need to change that
    % in case I need to creat a new excel file.
    
    if CreatVect(1,3) == 0
        CreatVect(1,3) = CreatVect(1,2);
    end
end


uiwait(warndlg('Close that thing if you have pirated version'))

nSheets = size(sheets,2);

% Putting the matlab data in the worksheet

for t = 1:nSheets
    
    % If we need to create the Sheet
    
    if CreatVect(1,3) == 1
        
        if t == 1
            
            % Initially no Worksheet will have been initialized
            dbstop in create_Sheet
            [eSheett,eWorkSheets] = create_Sheet(sheets{t},eWorkbook);
            
        else
            
            % One Worksheet wil already have been initialized
            [eSheett,~] = create_Sheet(sheets{t},eWorkSheets);
            
        end
        
        
        % otherwise recover the sheet that we want to work at
        
    elseif CreatVect(1,3) == 0
        
        
        eWorkSheets = eWorkbook.Worksheets;
        
        [eSheett,ignoreSheet] = find_sheet(sheets{t},eWorkSheets);
        
        % In case there are erros and the program is forced to ignore this
        % sheet
        if ignoreSheet
            
            % Go to the next iteration
            continue;
        end
        
    end
    
    % Activate the Sheet
    eSheett.Activate
    
    % Write the data in the Sheet
    dbstop in input_data_sheet
    if iscell(Header)
        input_data_sheet(eSheett,Range(t,:),Data(t,:),Header(t,:))
    else
        input_data_sheet(eSheett,Range(t,:),Data(t,:));
    end
    
end

% Saving the workbook

% If it's a new workbook it needs to be saved properly

if CreatVect(1,2) ==1
    
    % Remove any char that can't be used as a name
    
    name = regexprep(name,'[\/?*[]]','');
    
    
    SaveAs(eWorkbook,[location name '.xlsx']);
    
    eWorkbook.Saved = 1;
    
    % Otherwise we just save what has changed
elseif CreatVect(1,2) == 0
    
    invoke(eWorkbook,'Save');
    
end

% Close(eWorksheets)
% Close(eWorkbook);
% Quit(e);
% delete(e);

end


