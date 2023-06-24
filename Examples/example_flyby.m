
%
%   Flight Management and Procedure Design
%
%   geodesics example to compute the circular path of a fly-by waypoint
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%

% Clean up workspace
clear all
close all
clc

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

%%

% APPTR,I08R,08R,KL08R
% IF,KLF,52.019353,13.563414, ,0.0,0.0,3,11000,0,0,0,0,1,0
% TF,DODAT,52.261108,13.412950,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,NAKIP,52.416208,13.313942,0, ,0.0,0.0,0.0,0.0,0,0,0,1,220,0,0,0
% TF,DT540,52.462431,13.155786,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,DT541,52.451686,13.048169,0, ,0.0,0.0,0.0,0.0,1,5000,0,0,0,0,0,0
% TF,DT542,52.440844,12.940608,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,DT543,52.429906,12.833100,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,DT544,52.418869,12.725644,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,DT545,52.407736,12.618242,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,DT546,52.396506,12.510894,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,DT556,52.478600,12.487794,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,DT555,52.489844,12.595336,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,DT554,52.500989,12.702933,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,DT553,52.512042,12.810583,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% TF,DT552,52.522997,12.918289,0, ,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0
% CF,REGBA,52.532969,13.035939,0,ITGE,258.9,10.3,80.0,4.4,2,3000,0,0,0,0,0,0


% Perform a fly-by to waypoint DT546 and DT556

%   Compute the distance between DODAT and NAKIP waypoints
pt1.lat = 52.407736*pi/180;  % DT545
pt1.lon = 12.618242*pi/180.0;

pt2.lat = 52.396506*pi/180;  % DT546
pt2.lon = 12.510894*pi/180.0;

pt3.lat = 52.478600*pi/180;  % DT556
pt3.lon = 12.487794*pi/180.0;

pt4.lat = 52.489844*pi/180;  % DT555
pt4.lon = 12.595336*pi/180.0;

% ---------------------------------------------------------------------
%   Bank dynamics
% ---------------------------------------------------------------------

%   Compute air denisty, air pressure, temperature and speed of sound
[rho, p, temp, soundSpeed] = Atmos(5000*FT2M);

%   Compute the true airspeed based on height and CAS schedule
V = CAStoTAS(220,rho,p)*KTS2MPS;

%   Nominal bank angle of 22 degrees
radius = V^2/(G_CONST*tan(22*DEG2RAD));

% ---------------------------------------------------------------------
%   First ARC
% ---------------------------------------------------------------------
[dist12, crs12, crs21] = inverse(pt1.lat,pt1.lon,pt2.lat,pt2.lon);
[dist23, crs23, crs32] = inverse(pt2.lat,pt2.lon,pt3.lat,pt3.lon);

% Compute the angle between these two TF legs
dangle = signed_azimuth_difference(crs23, crs21+pi);

%   Compute the first ARC
[centerPt, startPt, endPt, dir] = wgs84_tangent_fixed_radius_arc(pt1, crs12, pt3, crs32-pi, radius);

[lat1, lon1] = create_RF_path(startPt, endPt, centerPt, 100);

% ---------------------------------------------------------------------
%   Second ARC
% ---------------------------------------------------------------------
[dist23, crs23, crs32] = inverse(pt2.lat,pt2.lon,pt3.lat,pt3.lon);
[dist34, crs34, crs43] = inverse(pt3.lat,pt3.lon,pt4.lat,pt4.lon);

% Compute the angle between these two TF legs
dangle = signed_azimuth_difference(crs34, crs32+pi);

%   Compute the second ARC
[centerPt, startPt, endPt, dir] = wgs84_tangent_fixed_radius_arc(pt2, crs23, pt4, crs43-pi, radius);

[lat2, lon2] = create_RF_path(startPt, endPt, centerPt, 100);



%%

close all
figure
plot(pt1.lon*180/pi,pt1.lat*180/pi,'y*','LineWidth',2); hold on
plot(pt2.lon*180/pi,pt2.lat*180/pi,'y*','LineWidth',2); hold on
plot(pt3.lon*180/pi,pt3.lat*180/pi,'y*','LineWidth',2); hold on
plot(pt4.lon*180/pi,pt4.lat*180/pi,'y*','LineWidth',2); hold on


set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Longitude [deg]','FontSize',12,'FontWeight','bold');
ylabel('Latitude [deg]','FontSize',12,'FontWeight','bold');
grid on

plot(centerPt.lon*180/pi,centerPt.lat*180/pi,'r*','LineWidth',2); hold on
plot(startPt.lon*180/pi,startPt.lat*180/pi,'g*','LineWidth',2); hold on
plot(endPt.lon*180/pi,endPt.lat*180/pi,'g*','LineWidth',2); hold on
plot(lon1*180/pi,lat1*180/pi,'k.','LineWidth',2); hold on


plot(lon2*180/pi,lat2*180/pi,'k.','LineWidth',2); hold on
% 
fprintf('%f [deg], %f [NM], %f [NM], %f [kts], %f [NM]\n', dangle*RAD2DEG,dist12*M2NM, dist23*M2NM, V, radius*M2NM);


