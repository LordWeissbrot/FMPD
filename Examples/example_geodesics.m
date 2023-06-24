
%
%   Flight Management and Procedure Design
%
%   geodesics example if direct and indirect methods
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

[dist12, crs12, crs21] = inverse(lat_dodat,lon_dodat,lat_nakip,lon_nakip);

if crs12 < 0.0
    crs12 = crs12 + 2*pi;
end

fprintf('Distance between waypoints: %f NM\n', dist12/1852.0);
fprintf('Course from DODAT top NAKIP: %f deg\n', crs12*180.0/pi);

%%

% Put a point halfway between DODAT and NAKIP using the direct method

[lat2, lon2, crs21] = direct(lat_dodat,lon_dodat, dist12/2.0, crs12);

figure(1)
plot(lon_dodat*180/pi,lat_dodat*180/pi,'y*','LineWidth',2); hold on
plot(lon_nakip*180/pi,lat_nakip*180/pi,'y*','LineWidth',2); hold on
plot(lon2*180/pi,lat2*180/pi,'g*','LineWidth',2); hold on
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Longitude [deg]','FontSize',12,'FontWeight','bold');
ylabel('Latitude [deg]','FontSize',12,'FontWeight','bold');
grid on
%plot_google_map('Axis',gca,'MapType','satellite','APIKey','');

%%

% Put 19 points between DODAT and NAKIP using the direct method

lat = [];
lon = [];
for ii=1:19

    [lat(ii), lon(ii), crs21] = direct(lat_dodat,lon_dodat, ii*dist12/20.0, crs12);

end

figure(2)
plot(lon_dodat*180/pi,lat_dodat*180/pi,'y*','LineWidth',2); hold on
plot(lon_nakip*180/pi,lat_nakip*180/pi,'y*','LineWidth',2); hold on
plot(lon*180/pi,lat*180/pi,'go','LineWidth',2); hold on
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Longitude [deg]','FontSize',12,'FontWeight','bold');
ylabel('Latitude [deg]','FontSize',12,'FontWeight','bold');
grid on
%plot_google_map('Axis',gca,'MapType','satellite','APIKey','');