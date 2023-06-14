

function [transitions] = get_transitions(airport_filename)

%   Open the file for the airport of interest
fid = fopen(airport_filename,'r');

% Go though the file and find the type and arrival
index = 2;
transitions.name{1} = '---';
transitions.rwys{1} = '---';
transitions.types{1} = '---';
while ~feof(fid) 
    
    % Get line of text
    a = fgetl(fid);
    
    % Break the line into two parts: part before and after the ':'
    b = split(a,',');
    
    if length(b) >= 4
        if strcmp(b{1},'APPTR')
            
            transitions.name{index} = b{4};
            transitions.rwys{index} = b{3};
            transitions.types{index} = b{2};
            index = index + 1;
   
        end
    end
end
%   Close the file for the airport of interest
fclose(fid);