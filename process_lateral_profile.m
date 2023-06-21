

%
%   process_lateral_profile.m  - TEMPLATE 
%
%   Flight Management and Procedure Design
%
%   Input - all_wpts: structure with the following members
%
%           line            = line from the navigation database file
%           leg_type        = path termination type (e.g. IF, TF etc.)
%           name            = name of the waypoint;
%           lat             = latitude of the waypoint if available [deg];
%           lon             = longitude of the waypoint if available [deg];
%           alt_constraint  = altitude constraint 
%                             (1: at, 2: above, 3:below, 4: between)
%           alt_top         = top altitude of constraint (top if it is a
%                             between constraint)
%           alt_bottom      = bottom altitude of the altitude window (if between)
%           spd_constraint  = speed constraint (1 = at orn below)
%           spd_value       = value of constraint
%           crs             = course in case of an CF leg
%           center_lat      = latitude of center of radius in case of a RF leg
%           center_lon      = longitude of center of radius in case of a RF leg
%
%   Copyright (c) 2021 TU Berlin FF
%
function [all_wpts_out, lat, lon, lat_wpts, lon_wpts] = process_lateral_profile(all_wpts)

all_wpts_out = all_wpts;

lat_wpts = cell2mat(all_wpts.lat);
lon_wpts = cell2mat(all_wpts.lon);

%   Compute the distances between the waypoints, 
%   except for ARC --> then NaN
for ind = 1:length(all_wpts.lat)-1
    
    pt1.lat = lat_wpts(ind)*pi/180;
    pt1.lon = lon_wpts(ind)*pi/180;
    
    pt2.lat = lat_wpts(ind+1)*pi/180;
    pt2.lon = lon_wpts(ind+1)*pi/180;
    
    [all_wpts_out.dist_to_nxt{ind}, all_wpts_out.crs_to_nxt{ind}, crs21] = inverse(pt1.lat,pt1.lon,pt2.lat,pt2.lon);
    
end

ind = length(all_wpts.lat);
all_wpts_out.crs_to_nxt{ind} = NaN;
all_wpts_out.dist_to_nxt{ind} = NaN;


%   Iterate over all generated waypoints
for i = 1:length(all_wpts.name)
    wp = all_wpts.name{i};
    leg = all_wpts.leg_type{i};
    disp(wp);
    disp(leg);

    %   Case 1: TF-leg
    if all_wpts.leg_type{i} == "TF"
        disp("...calculating TF-leg values...\n");

    end

    %   Case 2: RW-leg
    if all_wpts.leg_type{i} == "RW"
        disp("...calculating RW-leg values...\n");

    end

    %   Case 3: DF-leg
    if all_wpts.leg_type{i} == "DF"
        disp("...calculating DF-leg values...\n");

    end

    %   Case 4: CF-leg
    if all_wpts.leg_type{i} == "TF"
        disp("...calculating CF-leg values...\n");

    end

    disp("___"); %linebreak
end



lat = [];
lon = [];
