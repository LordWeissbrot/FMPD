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

%   Constants
KTS2MPS	= (1.852/3.6);
MPS2KTS = (3.6/1.852);
FT2M = 0.3048;
M2FT = (1/0.3048);
NM2M = 1852.0;
M2NM = (1/1852.0);
G_CONST	= 9.80665;
DEG2RAD = (pi/180.0);
RAD2DEG = (180.0/pi);

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

%% ================================== Solution Part 1 ==================================
% Initialize latitude and longitude arrays
lat = [];
lon = [];

% Iterate over all waypoints
for i = 1:length(all_wpts.name)-1
    % Check if lat and lon arrays are empty
    if isempty(lat) && isempty(lon)
        % Initialize the first point with lat and lon coordinates
        pt1.lat = lat_wpts(i) * pi/180;
        pt1.lon = lon_wpts(i) * pi/180;
    else
        % If not, use the last lat and lon coordinate
        pt1.lat = lat(end) * pi/180;
        pt1.lon = lon(end) * pi/180;
    end
    
    % Define the next waypoint
    pt2.lat = lat_wpts(i+1)*pi/180;
    pt2.lon = lon_wpts(i+1)*pi/180;
    
    % Handle last two waypoints
    if i == length(all_wpts.name)-1
        fprintf("FINAL:...calculating %s-leg from: %s\n", all_wpts.leg_type{i}, all_wpts.name{i});

        [lat_i, lon_i, dist12] = create_straight(pt1, pt2, 100);
        lat = [lat, lat_i*180/pi];
        lon = [lon, lon_i*180/pi];

    % Handle all other waypoints
    else
        %% Calculate NON-RF leg
        if all_wpts.leg_type{i+1} ~= "RF"
            fprintf("Non-RF:...calculating %s-leg to: %s\n", all_wpts.leg_type{i+1}, all_wpts.name{i});
            
            % Define coordinates 2 waypoints ahead
            pt3.lat = lat_wpts(i+2)*pi/180;
            pt3.lon = lon_wpts(i+2)*pi/180;
    
            % Calculate distances and courses between points
            [dist12, crs12, crs21] = inverse(pt1.lat,pt1.lon,pt2.lat,pt2.lon);
            [dist23, crs23, crs32] = inverse(pt2.lat,pt2.lon,pt3.lat,pt3.lon);

            % Calculate course change
            cours_change = abs(crs23-crs12);
        
            % Course change big enough and upcoming leg is NON-RF
            if cours_change > 1e-2 && all_wpts.leg_type{i+2} ~= "RF"

                % Compute air density, air pressure, temperature and speed of sound
                [rho, p, temp, soundSpeed] = Atmos(5000*FT2M);
                % Compute the true airspeed based on height and CAS schedule
                V = CAStoTAS(220,rho,p)*KTS2MPS;
                % Nominal bank angle of 22 degrees
                radius = V^2/(G_CONST*tan(22*DEG2RAD));

                % Calculate fixed radius arc
                [centerPt, startPt, endPt, dir] = wgs84_tangent_fixed_radius_arc(pt1, crs12, pt3, crs32-pi, radius);
                
                % Create straight line from pt1 to startPt of arc
                [lat_i, lon_i, dist12] = create_straight(pt1, startPt, 50);
                lat = [lat, lat_i*180/pi];
                lon = [lon, lon_i*180/pi];
                
                % Create arc from startPt to endPt
                [lat_i, lon_i, dist12] = create_arc(startPt, endPt, centerPt, 50);
                lat = [lat, lat_i*180/pi];
                lon = [lon, lon_i*180/pi];

            % Course change to small
            else
                % Create straight line from pt1 to pt2
                [lat_i, lon_i, dist12] = create_straight(pt1, pt2, 100);
                lat = [lat, lat_i*180/pi];
                lon = [lon, lon_i*180/pi];
            end

        %% Calculate RF leg    
        else
            fprintf("RF:...calculating %s-leg to: %s\n", all_wpts.leg_type{i+1}, all_wpts.name{i});
            
            % Define arc center as arbitrary pt3
            pt3.lat = all_wpts.center_lat{i+1}*pi/180;
            pt3.lon = all_wpts.center_lon{i+1}*pi/180;
    
            % Create arc around pt3
            [lat_i, lon_i, dist12] = create_arc(pt1,pt2,pt3,100);
            lat = [lat, lat_i*180/pi];
            lon = [lon, lon_i*180/pi];
        end
    end % end of loop; 
end % end of function: