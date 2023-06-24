
%
%   Flight Management and Procedure Design
%
%   XTE Example
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%

% Clean up workspace
clear all
close all
clc

%%

%   Compute the distance between DODAT and NAKIP waypoints

lat_dodat = 52.261108*pi/180.0;
lon_dodat = 13.412950*pi/180.0;

lat_nakip = 52.416208*pi/180.0;
lon_nakip = 13.313942*pi/180.0;

lat_user = 52.326208*pi/180.0;
lon_user = 13.403942*pi/180.0;

% Use inverse method to determin the distancxe between the two waypoints
% and the course between them
[dist12, crs12, crs21] = inverse(lat_dodat,lon_dodat,lat_nakip,lon_nakip);

pt1.lat = lat_dodat;
pt1.lon = lon_dodat;

pt3.lat = lat_user;
pt3.lon = lon_user;

%   COmpute distance to geodesic and the projection (pt2) on the geodesic
[pt2, crsFromPoint, distFromPoint] = wgs84_perp_intercept(pt1, crs12, pt3, 1e-9);

fprintf('XTE: %f NM\n', distFromPoint/1852.0);

figure(1)
plot(lon_dodat*180/pi,lat_dodat*180/pi,'y*','LineWidth',2); hold on
plot(lon_nakip*180/pi,lat_nakip*180/pi,'y*','LineWidth',2); hold on
plot(lon_user*180/pi,lat_user*180/pi,'g*','LineWidth',2); hold on
plot(pt2.lon*180/pi,pt2.lat*180/pi,'w*','LineWidth',2); hold on
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Longitude [deg]','FontSize',12,'FontWeight','bold');
ylabel('Latitude [deg]','FontSize',12,'FontWeight','bold');
grid on
%plot_google_map('Axis',gca,'MapType','satellite','APIKey','');
