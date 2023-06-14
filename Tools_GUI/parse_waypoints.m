
%
%   parse_waypoints.m   
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%
function [wpt] = parse_waypoints(fid)

idx = 1;


%   Read theapp first line
a = fgetl(fid);
table_fixes = [];
while length(a) >= 1
    
    %   Break each line in separate pieces separated by a comma
    b = split(a,',');
    
    %   Whole line of the data file
    wpt.line{idx} = a;
    
    %   Terminator type
    wpt.leg_type{idx} = b{1};
    
    %   Name of end waypoint
    wpt.name{idx} = b{2};
    
    %   If the end point is a fix (F), then extract the latitude and
    %   longitude
    if b{1}(2) == 'F'
        wpt.lat{idx} = str2double(b{3});
        wpt.lon{idx} = str2double(b{4});
    else
        wpt.lat{idx} = nan;
        wpt.lon{idx} = nan;
    end
    
    %   Altitude constraints
    %   Speed constraints
    %   1: at, 2: above, 3: below, 4: between
    if strcmp(b{1},'TF') 
        wpt.alt_constraint{idx} = str2double(b{11});
        wpt.alt_top{idx} = str2double(b{12});
        wpt.alt_bottom{idx} = str2double(b{13});
        wpt.spd_constraint{idx} = str2double(b{14});
        wpt.spd_value{idx} = str2double(b{15});
        wpt.crs{idx} = NaN;
        wpt.center_lat{idx} = NaN;
        wpt.center_lon{idx} = NaN;
    elseif strcmp(b{1},'CF') 
        wpt.alt_constraint{idx} = str2double(b{11});
        wpt.alt_top{idx} = str2double(b{12});
        wpt.alt_bottom{idx} = str2double(b{13});
        wpt.spd_constraint{idx} = str2double(b{14});
        wpt.spd_value{idx} = str2double(b{15});
        wpt.crs{idx} = str2double(b{9}); 
        wpt.center_lat{idx} = NaN;
        wpt.center_lon{idx} = NaN;
    elseif strcmp(b{1},'IF')
        wpt.alt_constraint{idx} = str2double(b{8});
        wpt.alt_top{idx} = str2double(b{9});
        wpt.alt_bottom{idx} = str2double(b{10});
        wpt.spd_constraint{idx} = str2double(b{11});
        wpt.spd_value{idx} = str2double(b{12});
        wpt.crs{idx} = NaN; 
        wpt.center_lat{idx} = NaN;
        wpt.center_lon{idx} = NaN;
    elseif strcmp(b{1},'DF')
        wpt.alt_constraint{idx} = str2double(b{9});
        wpt.alt_top{idx} = str2double(b{10});
        wpt.alt_bottom{idx} = str2double(b{11});
        wpt.spd_constraint{idx} = str2double(b{12});
        wpt.spd_value{idx} = str2double(b{13});
        wpt.crs{idx} = NaN;
        wpt.center_lat{idx} = NaN;
        wpt.center_lon{idx} = NaN;
    elseif strcmp(b{1},'RF')
        wpt.alt_constraint{idx} = str2double(b{9});
        wpt.alt_top{idx} = str2double(b{10});
        wpt.alt_bottom{idx} = str2double(b{11});
        wpt.spd_constraint{idx} = str2double(b{12});
        wpt.spd_value{idx} = str2double(b{13});
        wpt.crs{idx} = NaN;
        
        center_name = b{6};
        if isempty(table_fixes)
            table_fixes = readtable('Waypoints.txt');
        end
        
        % Find waypoint and coordinate
        % Find the navaid in the table
        index = find(ismember(table_fixes{:,1},{center_name}) == 1);

        % Obtain the latitude and longitude
        wpt.center_lat{idx} = table_fixes{index,2};
        wpt.center_lon{idx} = table_fixes{index,3};
    elseif strcmp(b{1},'CA')
        wpt.alt_constraint{idx} = str2double(b{4});
        wpt.alt_top{idx} = NaN;
        wpt.alt_bottom{idx} = str2double(b{5});
        wpt.spd_constraint{idx} = 0;
        wpt.spd_value{idx} = NaN;
        wpt.crs{idx} = str2double(b{3});
        wpt.center_lat{idx} = NaN;
        wpt.center_lon{idx} = NaN;
    else
        wpt.alt_constraint{idx} = 0;
        wpt.alt_top{idx} = NaN;
        wpt.alt_bottom{idx} = NaN;
        wpt.spd_constraint{idx} = 0;
        wpt.spd_value{idx} = NaN;
        wpt.crs{idx} = NaN;
        wpt.center_lat{idx} = NaN;
        wpt.center_lon{idx} = NaN;
    end
    
    %   Increment the index
    idx = idx + 1;
    
    a = fgetl(fid);
end