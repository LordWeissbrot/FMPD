

function [rwys_llh] = get_rwy_coordinates(airport_filename, rwys)

%   Open the file for the airport of interest
fid = fopen(airport_filename,'r');

% Go though the file and find the type and arrival
index = 1;
rwys_llh = zeros(3,length(rwys));
while ~feof(fid) 
    
    % Get line of text
    a = fgetl(fid);
    
    % Break the line into two parts: part before and after the ':'
    b = split(a,',');
    
    if length(b) >= 4
        if strncmp(b{2},'RW',2)       
            for jj=1:length(rwys)
                s = ['RW' rwys{jj}];
                if strcmp(b{2},s)
                    rwys_llh(1,jj) = str2double(b{3});
                    rwys_llh(2,jj) = str2double(b{4});
                    rwys_llh(3,jj) = str2double(b{12})-50.0;
                    break;
                end
            end
        end
    end
end

%   Remove duplicate entries
rwys = unique(rwys);

%   Close the file for the airport of interest
fclose(fid);