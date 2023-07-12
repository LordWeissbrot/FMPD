

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
lat = [];
lon = [];

%disp(all_wpts.name);
%disp(all_wpts.leg_type);


%   Iterate over all generated waypoints
for i = 1:length(all_wpts.name)-1
    %wp = all_wpts.name{i};
    %leg = all_wpts.leg_type{i};
    %disp(wp);
    %disp(leg);
    

%% last waypoint
    if i == length(all_wpts.name)-1
        fprintf("FINAL:...calculating ");
        fprintf(all_wpts.leg_type{i});
        fprintf("-leg from:");
        fprintf(all_wpts.name{i});
        fprintf("\n");

        % Check if lat and lon vectors are not empty
        if isempty(lat) && isempty(lon)
            % Save the last element of lat and lon in pt1.lat and pt1.lon
            pt1.lat = lat_wpts(i) * pi/180;
            pt1.lon = lon_wpts(i) * pi/180;
        else
            % Use lat_wpts(i) and lon_wpts(i) if the vectors are empty
            pt1.lat = lat(end) * pi/180;
            pt1.lon = lon(end) * pi/180;
        end
        
        pt2.lat = lat_wpts(i+1)*pi/180;
        pt2.lon = lon_wpts(i+1)*pi/180;

        [lat_i, lon_i, dist12]=create_straight(pt1, pt2, 100);
        lat = [lat, lat_i*180/pi];
        lon = [lon, lon_i*180/pi];

    else
        % Check if lat and lon vectors are not empty
        if isempty(lat) && isempty(lon)
            % use position of current wp
            pt1.lat = lat_wpts(i) * pi/180;
            pt1.lon = lon_wpts(i) * pi/180;
        else
            % Use last calculated position of aircraft
            pt1.lat = lat(end) * pi/180;
            pt1.lon = lon(end) * pi/180;
        end

        %assumption: all wp are fly-over, beside end of RF-leg
        pt2.lat = lat_wpts(i+1)*pi/180; 
        pt2.lon = lon_wpts(i+1)*pi/180;

 %% Non-RF-leg cases
        if all_wpts.leg_type{i+1} ~= "RF"
            fprintf("Non-RF:...calculating ");
            fprintf(all_wpts.leg_type{i+1});
            fprintf("-leg to:");
            fprintf(all_wpts.name{i});
            fprintf("\n");

            pt3.lat = lat_wpts(i+2)*pi/180;
            pt3.lon = lon_wpts(i+2)*pi/180;
    
            %calc arc between wp-1, wp and wp+1
            [dist12, crs12, crs21] = inverse(pt1.lat,pt1.lon,pt2.lat,pt2.lon);
            [dist23, crs23, crs32] = inverse(pt2.lat,pt2.lon,pt3.lat,pt3.lon);
            [dist13, crs13, crs31] = inverse(pt1.lat,pt1.lon,pt3.lat,pt3.lon);

            %check if course change is big enough for
            %wgs84_tangent_fixed_radius_arc()
            cours_change = abs(crs23-crs12);
            if cours_change > 1e-2 && all_wpts.leg_type{i+2} ~= "RF"
        
                % Calculate arc
                % Compute air density, air pressure, temperature and speed of sound
                [rho, p, temp, soundSpeed] = Atmos(5000*FT2M);
                % Compute the true airspeed based on height and CAS schedule
                V = CAStoTAS(220,rho,p)*KTS2MPS;
                % Nominal bank angle of 22 degrees
                radius = V^2/(G_CONST*tan(22*DEG2RAD));
    
                [centerPt, startPt, endPt, dir] = wgs84_tangent_fixed_radius_arc(pt1, crs12, pt3, crs32-pi, radius);
        
                %calc dots between pt1 and startPt
                [lat_i, lon_i, dist12]=create_straight(pt1, startPt, 50);
                lat = [lat, lat_i*180/pi];
                lon = [lon, lon_i*180/pi];
            
                %calc dots in arc between startPt and endPt
                [lat_i, lon_i, dist12]=create_arc(startPt, endPt, centerPt, 50);
                lat = [lat, lat_i*180/pi];
                lon = [lon, lon_i*180/pi];
        
            
            else %course change too small or next leg == RF-leg
                %calc dots between p1 and pt2
                [lat_i, lon_i, dist12]=create_straight(pt1, pt2, 100);
                lat = [lat, lat_i*180/pi];
                lon = [lon, lon_i*180/pi];
            end
%% RF-leg case
        else
            fprintf("RF:...calculating ");
            fprintf(all_wpts.leg_type{i+1});
            fprintf("-leg to:");
            fprintf(all_wpts.name{i});
            fprintf("\n");

                
            pt1.lat = lat_wpts(i) * pi/180;
            pt1.lon = lon_wpts(i) * pi/180;
    
            pt2.lat = lat_wpts(i+1)*pi/180; 
            pt2.lon = lon_wpts(i+1)*pi/180;

            pt3.lat = all_wpts.center_lat{i+1}*pi/180; %center
            pt3.lon = all_wpts.center_lon{i+1}*pi/180;

            [lat_i, lon_i, dist12]=create_arc(pt1,pt2,pt3,100);
            lat = [lat, lat_i*180/pi];
            lon = [lon, lon_i*180/pi];
        end
    end
end % end of loop; 
end % end of function:



