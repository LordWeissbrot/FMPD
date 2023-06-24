
%
%   Flight Management and Procedure Design
%
%   geodesics example to compute the circular path of an RF leg
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

% SID,ANEK1X,07C,4
% CF,DF967,50.071142,8.696125,0,RID,17.0,18.4,68.0,4.5,0,0,0,0,0,0,0,0
% RF,DF966,50.010828,8.762556,2,DF965,205.5,2.3,0,0,0,1,220,0,0,0
% RF,DF964,49.984486,8.742167,1,DF963,192.1,3.9,0,0,0,1,250,0,0,0
% TF,DF157,49.791100,8.672294,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,ANEKI,49.317272,8.480428,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0

%   Compute the distance between DODAT and NAKIP waypoints
pt1.lat = 50.071142*pi/180;  % DF967
pt1.lon = 8.696125*pi/180.0;

pt2.lat = 50.010828*pi/180;  % DF966
pt2.lon = 8.762556*pi/180.0;

pt3.lat = 50.035217*pi/180;  % DF965
pt3.lon = 8.716728*pi/180.0;

[dist13, crs13, crs31] = inverse(pt1.lat,pt1.lon,pt3.lat,pt3.lon);
[dist23, crs23, crs32] = inverse(pt2.lat,pt2.lon,pt3.lat,pt3.lon);

radius = dist13;

fprintf('%f, %f\n', dist13/1852.0, dist23/1852.0);

N = 200;
d_angle = -(crs32 - crs31)/N;

d_angle = signed_azimuth_difference(crs32, crs31)/N;

signed_azimuth_difference(crs32, crs31)*180/pi-360

lat = [];
lon = [];
for ii=1:(N-1)

    [lat(ii), lon(ii), crs21] = direct(pt3.lat,pt3.lon, radius, crs31+ii*d_angle);

end

figure(1)
plot(pt1.lon*180/pi,pt1.lat*180/pi,'y*','LineWidth',2); hold on
plot(pt2.lon*180/pi,pt2.lat*180/pi,'y*','LineWidth',2); hold on
plot(pt3.lon*180/pi,pt3.lat*180/pi,'g*','LineWidth',2); hold on
plot(lon*180/pi,lat*180/pi,'g.','LineWidth',2); hold on
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Longitude [deg]','FontSize',12,'FontWeight','bold');
ylabel('Latitude [deg]','FontSize',12,'FontWeight','bold');
grid on
plot_google_map('Axis',gca,'MapType','satellite','APIKey','AIzaSyCrPyjGpSDyzB3qHoCH_0e0Nz-iA46tMzk');

