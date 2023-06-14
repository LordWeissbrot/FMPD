%
%   load_transition_waypoints.m   
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%
function [wpt] = load_transition_waypoints(airport_filename, transition, type)

% Load the file for the airport of interest
fid = fopen(airport_filename,'r');

idx = 0;

% Set boolean for loop search
done = false;

% Go though the file and find the type and arrival

%   At least return an empty cell array
[wpt] = make_empty_wpts();
while ~feof(fid) && ~done
    
    % Get line of text
    a = fgetl(fid);
    
    % Break the line into two parts: part before and after the ':'
    b = split(a,',');
    
    if length(b) >= 4
        if strcmp(b{1},'APPTR') && strcmp(b{2},type) && strcmp(b{4},transition) 
            
            % Extract all the waypoints
            [wpt] = parse_waypoints(fid);
            
            % If all is extracted, exit the while loop
            done = true;
            
        end
    end
end

a = 1;


