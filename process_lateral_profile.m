% process_lateral_profile.m
% Template for processing lateral profile data for flight management and procedure design
%
% Inputs:
%   - all_wpts: a structure containing navigation database data including waypoint names, 
%     geographical information and various constraints.
%
% Outputs:
%   - all_wpts_out: Updated navigation data
%   - lat: Latitude values
%   - lon: Longitude values
%   - lat_wpts: Waypoint latitude values
%   - lon_wpts: Waypoint longitude values
%
% Copyright (c) 2021 TU Berlin FF

function [all_wpts_out, lat, lon, lat_wpts, lon_wpts] = process_lateral_profile(all_wpts)

% Define constants used in conversions
KTS2MPS	= (1.852/3.6);       % Knots to meters per second
MPS2KTS = (3.6/1.852);       % Meters per second to knots
FT2M = 0.3048;               % Feet to meters
M2FT = (1/0.3048);           % Meters to feet
NM2M = 1852.0;               % Nautical miles to meters
M2NM = (1/1852.0);           % Meters to nautical miles
G_CONST	= 9.80665;            % Gravitational constant
DEG2RAD = (pi/180.0);        % Degrees to radians
RAD2DEG = (180.0/pi);        % Radians to degrees

% Prepare the output by copying the input waypoint data
all_wpts_out = all_wpts;

% Convert cell arrays to matrices for easier mathematical operations
lat_wpts = cell2mat(all_wpts.lat);
lon_wpts = cell2mat(all_wpts.lon);
 
% Compute the distances between the waypoints, except for ARC type waypoints
for ind = 1:length(all_wpts.lat)-1
    % Convert lat/lon from degrees to radians
    pt1.lat = lat_wpts(ind)*pi/180;
    pt1.lon = lon_wpts(ind)*pi/180;
    
    pt2.lat = lat_wpts(ind+1)*pi/180;
    pt2.lon = lon_wpts(ind+1)*pi/180;
    
    % Use the inverse function to calculate distance and course between two waypoints
    [all_wpts_out.dist_to_nxt{ind}, all_wpts_out.crs_to_nxt{ind}, crs21] = inverse(pt1.lat,pt1.lon,pt2.lat,pt2.lon);
end

% For the last waypoint, set the course and distance to next as NaN
ind = length(all_wpts.lat);
all_wpts_out.crs_to_nxt{ind} = NaN;
all_wpts_out.dist_to_nxt{ind} = NaN;

% Initialize empty arrays for latitude and longitude values
lat = [];
lon = [];

% Iterate over all waypoints to calculate flight path segments
for i = 1:length(all_wpts.name)-1
    % Handle the last waypoint separately
    if i == length(all_wpts.name)-1
        fprintf('FINAL:...calculating %s-leg from:%s\n', all_wpts.leg_type{i}, all_wpts.name{i});

        % If lat and lon arrays are not empty, use the last element. Otherwise, use waypoint position
        if isempty(lat) && isempty(lon)
            pt1.lat = lat_wpts(i) * pi/180;
            pt1.lon = lon_wpts(i) * pi/180;
        else
            pt1.lat = lat(end) * pi/180;
            pt1.lon = lon(end) * pi/180;
        end

        % Define position for the next waypoint
        pt2.lat = lat_wpts(i+1)*pi/180;
        pt2.lon = lon_wpts(i+1)*pi/180;

        % Create a straight flight path between two waypoints
        [lat_i, lon_i, dist12] = create_straight(pt1, pt2, 100);
        lat = [lat, lat_i*180/pi];
        lon = [lon, lon_i*180/pi];

    else
        % If lat and lon arrays are not empty, use the last element. Otherwise, use current waypoint position
        if isempty(lat) && isempty(lon)
            pt1.lat = lat_wpts(i) * pi/180;
            pt1.lon = lon_wpts(i) * pi/180;
        else
            pt1.lat = lat(end) * pi/180;
            pt1.lon = lon(end) * pi/180;
        end
        
        % Define the coordinates of the second point (next waypoint)
        pt2.lat = lat_wpts(i+1)*pi/180; 
        pt2.lon = lon_wpts(i+1)*pi/180;

        % Begin processing non-RF-leg cases
        if all_wpts.leg_type{i+1} ~= 'RF'
            % Inform about the leg type and name we are calculating
            fprintf('Non-RF:...calculating %s-leg to: %s\n', all_wpts.leg_type{i+1}, all_wpts.name{i});
        
            % Define the coordinates of the third point (two waypoints ahead)
            pt3.lat = lat_wpts(i+2)*pi/180;
            pt3.lon = lon_wpts(i+2)*pi/180;
            
            % Calculate the distances and course between wp, wp+1 and wp+2
            [dist12, crs12, crs21] = inverse(pt1.lat,pt1.lon,pt2.lat,pt2.lon);
            [dist23, crs23, crs32] = inverse(pt2.lat,pt2.lon,pt3.lat,pt3.lon);
            [dist13, crs13, crs31] = inverse(pt1.lat,pt1.lon,pt3.lat,pt3.lon);
        
            % Check if course change is significant enough for wgs84_tangent_fixed_radius_arc()
            cours_change = abs(crs23-crs12);
            if cours_change > 1e-2 && all_wpts.leg_type{i+2} ~= 'RF'
                
                % Compute the atmospheric conditions
                [rho, p, temp, soundSpeed] = Atmos(5000*FT2M);
                % Calculate true airspeed based on altitude and CAS schedule
                V = CAStoTAS(220,rho,p)*KTS2MPS;
                % Calculate radius using nominal bank angle of 22 degrees
                radius = V^2/(G_CONST*tan(22*DEG2RAD));
            
                % Calculate arc between pt1, pt2, and pt3
                [centerPt, startPt, endPt, dir] = wgs84_tangent_fixed_radius_arc(pt1, crs12, pt3, crs32-pi, radius);
                
                % Calculate coordinates between pt1 and startPt
                [lat_i, lon_i, dist12]=create_straight(pt1, startPt, 50);
                lat = [lat, lat_i*180/pi];
                lon = [lon, lon_i*180/pi];
                    
                % Calculate coordinates in the arc between startPt and endPt
                [lat_i, lon_i, dist12]=create_arc(startPt, endPt, centerPt, 50);
                lat = [lat, lat_i*180/pi];
                lon = [lon, lon_i*180/pi];
            
            % If course change is too small or next leg is an RF-leg
            else 
                % Calculate coordinates between pt1 and pt2
                [lat_i, lon_i, dist12]=create_straight(pt1, pt2, 100);
                lat = [lat, lat_i*180/pi];
                lon = [lon, lon_i*180/pi];
            end
        
        % Begin processing RF-leg cases
        else
            % Inform about the RF leg type and name we are calculating
            fprintf('RF:...calculating %s-leg to: %s\n', all_wpts.leg_type{i+1}, all_wpts.name{i});
            
            % Define coordinates of first point
            pt1.lat = lat_wpts(i) * pi/180;
            pt1.lon = lon_wpts(i) * pi/180;
            
            % Define coordinates of the second point (next waypoint)
            pt2.lat = lat_wpts(i+1)*pi/180; 
            pt2.lon = lon_wpts(i+1)*pi/180;
        
            % Define coordinates of the center point for the arc
            pt3.lat = all_wpts.center_lat{i+1}*pi/180;
            pt3.lon = all_wpts.center_lon{i+1}*pi/180;
        
            % Calculate the coordinates on the arc between pt1, pt2, and pt3
            [lat_i, lon_i, dist12]=create_arc(pt1,pt2,pt3,100);
            lat = [lat, lat_i*180/pi];
            lon = [lon, lon_i*180/pi];
        end
    end % End of loop
end % End of function


