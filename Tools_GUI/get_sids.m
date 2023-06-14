

function [sids_rwys, sids] = get_sids(airport_filename)

%   Open the file for the airport of interest
fid = fopen(airport_filename,'r');

% Go though the file and find the type and arrival
done = false;
index = 1;
strs = [];
rwys = [];
sids_rwys = {};
sids = {};
while ~feof(fid) 
    
    % Get line of text
    a = fgetl(fid);
    
    % Break the line into two parts: part before and after the ':'
    b = split(a,',');
    
    if length(b) >= 4
        if strcmp(b{1},'SID')
            
            sids{index} = b{2};
            sids_rwys{index} = b{3};
            index = index + 1;
   
        end
    end
end

%   Close the file for the airport of interest
fclose(fid);