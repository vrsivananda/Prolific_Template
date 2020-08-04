% This function downloads all the data from your experiment subject-by-subject
% and stores them in the 'Data' folder in 2 forms: 
% (1) Cell Array, and 
% (2) Data Structure
% This was done such that you have all your data locally and can run any
% analyses on them. If you post this data online, other researchers can
% also run their own analyses on them without accessing your database.
%
% You can then either: 
% (1) Use the analyzeData.m file to analyze the downloaded data, or
% (2) Make another script of your own to analyze the data, or 
% (3) Modify this file to download the data based on what you need and
%     analyze it

clear;
close all;

% Add the java file that you'll need to use to connect to the database
% (This needs to be in the same directory or have the path added)
% Get this file from the Oracle website if you don't have it otherwise.
javaaddpath('mysql-connector-java-5.1.42-bin.jar');

% Create a connection object by connecting to our SQL database.
databaseUsername = '';
databasePassword = '';
databaseName = '';
tableName = '';
serverAddess = '';
conn = database(databaseName,databaseUsername,databasePassword,'Vendor','MySQL',...
    'Server',serverAddess);


% Load a text file that lists all of the subjects.
path='subjects.txt';
% Make an ID for the subject list file
subjectListFileId=fopen(path);
% Read in the number from the subject list
numberOfSubjects = fscanf(subjectListFileId,'%d');
disp('Number of subjects: ');
disp(numberOfSubjects); 

% Loop through all the subjects to get all the data from the database
for i = 1:numberOfSubjects
    
    % Read the subject ID from the file, stop after each line
    subjectId = fscanf(subjectListFileId,'%s',[1 1]);
    % Print out the subject ID
    fprintf('subject: %s\n',subjectId);

    % Make the SQL query to download everything.
    sqlquery = ['SELECT * FROM ' tableName ' WHERE workerId = "' subjectId '"'];
    
    % Change the path
    currentFolderPath = pwd;
    desiredFolderPath = [pwd '/Data'];
    
    %------------%
    % CELL ARRAY %
    %------------%
    
    dataFormat = 'cellarray';
    
    % Execute the query
    cursor = exec(conn,sqlquery);
    % Set the format of how you want the data to be stored
    setdbprefs('DataReturnFormat',dataFormat);
    cursor = fetch(cursor);
    % Get the data in the format specified above
    data = cursor.Data;
    %Save the data
    savingFileName = [dataFormat '_data_' subjectId];
    savingFilePath = [desiredFolderPath '/' savingFileName];
    save(savingFilePath, 'data');
    
    %-----------------%
    % STRUCTURE ARRAY %
    %-----------------% 
    
    dataFormat = 'structure';
    
    % Execute the query
    cursor = exec(conn,sqlquery);
    % Set the format of how you want the data to be stored
    setdbprefs('DataReturnFormat',dataFormat);
    cursor = fetch(cursor);
    % Get the data in the format specified above
    data = cursor.Data;
    % Save the data
    savingFileName = [dataFormat '_data_' subjectId];
    savingFilePath = [desiredFolderPath '/' savingFileName];
    save(savingFilePath, 'data');
    

end % End of for loop that goes through all the subjects