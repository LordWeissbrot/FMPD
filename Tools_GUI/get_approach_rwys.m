

function [approaches] = get_approach_rwys(airport_filename)

%   Open the file for the airport of interest
fid = fopen(airport_filename,'r');

% Go though the file and find the type and arrival
index = 1;
while ~feof(fid) 
    
    % Get line of text
    a = fgetl(fid);
    
    % Break the line into two parts: part before and after the ':'
    b = split(a,',');
    
    if length(b) >= 4
        if strcmp(b{1},'FINAL')
            
            approaches.rwys{index} = b{3};
            approaches.types{index} = b{2};
            
            app_type = b{2};
            if length(app_type) > 3
                if app_type(4) == 'L' || app_type(4) == 'C' || app_type(4) == 'R'
                    id = app_type(2:4);
                end
            else
                id = app_type(2:3);
            end
            
            extra = [];
            if length(app_type) > 4
                extra = app_type(5:end);
            end
            
            nav = [];
            if app_type(1) == 'D'
                nav = 'VOR';
            elseif app_type(1) == 'R'
                nav = 'RNAV (GPS)';
            elseif app_type(1) == 'J'
                nav = 'GLS';
            elseif app_type(1) == 'I'
                nav = 'ILS';
            elseif app_type(1) == 'Q'
                nav = 'NDB/DME';
            elseif app_type(1) == 'N'
                nav = 'NDB';
            end
            
            str = [nav extra];
            %approaches.full{index} = sprintf('%s Rwy %s', str, id);
            approaches.full{index} = sprintf('%s %s', str, id);
            index = index + 1;
   
        end
    end
end

%   Close the file for the airport of interest
fclose(fid);