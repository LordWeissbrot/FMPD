

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
lat = [];
lon = [];

disp(all_wpts.name);
disp(all_wpts.leg_type);


%   Iterate over all generated waypoints
for i = 1:length(all_wpts.name)-1
    %wp = all_wpts.name{i};
    %leg = all_wpts.leg_type{i};
    %disp(wp);
    %disp(leg);
    

    %   Case 1: TF-leg or RW-leg (artificial leg added to the departure runway)
    if all_wpts.leg_type{i} == "TF" || all_wpts.leg_type{i} == "RW"
        fprintf("...calculating ");
        fprintf(all_wpts.leg_type{i});
        fprintf("-leg from:");
        fprintf(all_wpts.name{i});
        fprintf("\n");

        pt1.lat = lat_wpts(i)*pi/180;
        pt1.lon = lon_wpts(i)*pi/180;
        
        pt2.lat = lat_wpts(i+1)*pi/180;
        pt2.lon = lon_wpts(i+1)*pi/180;
        [lat_i, lon_i, dist12]=create_straight(pt1, pt2, 100);
        lat = [lat, lat_i*180/pi];
        lon = [lon, lon_i*180/pi];

    end

    %   Case 2: DF-leg
    if all_wpts.leg_type{i} == "DF"
        %disp("...calculating DF-leg values...\n");

    end

    %   Case 3: CF-leg
    if all_wpts.leg_type{i} == "CF"
        %disp("...calculating CF-leg values...\n");

    end
end % end of loop; 
end % end of function:



