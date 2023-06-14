%
%   load_sid_waypoints.m 
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%
function [wpt] = load_sid_waypoints(airport_filename, sid, runway)

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
        if strcmp(b{1},'SID') && strcmp(b{2},sid) && strcmp(b{3},runway)
            
            % Extract all the waypoints
            [wpt] = parse_waypoints(fid);
            
            % If all is extracted, exit the while loop
            done = true;
            
        elseif strcmp(b{1},'SID') && strcmp(b{2},sid) && strcmp(b{3},'ALL')
            
            % Extract all the waypoints
            [wpt] = parse_waypoints(fid);
            
        end
    end
end


