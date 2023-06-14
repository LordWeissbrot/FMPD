

function [rwys] = get_takeoff_rwys(airport_filename)

%   Open the file for the airport of interest
fid = fopen(airport_filename,'r');

% Go though the file and find the type and arrival
done = false;
index = 1;
rwys = [];
while ~feof(fid) 
    
    % Get line of text
    a = fgetl(fid);
    
    % Break the line into two parts: part before and after the ':'
    b = split(a,',');
    
    if length(b) >= 4
        if strcmp(b{1},'SID')
            
            disp(b{3})
            rwys{index} = b{3};
            index = index + 1;
   
        end
    end
end

%   Remove duplicate entries
rwys = unique(rwys,'rows');

%   Close the file for the airport of interest
fclose(fid);