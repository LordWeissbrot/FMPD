%
%   Flight Management and Procedure Design
%
%   Climbing Example
%
%   1) Climb from the airport to 10000 ft (FL100) at a constant CAS = 250kts
%   2) Then, an accelerated climb to CAS = 300kt
%   3) Then, climb at constant CAS = 300kts till the crossover altitude 
%   4) Then, climb at constant mach (M = 0.78) till cruising altitude
%   (FL350)
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%

% Clean up workspace
clear all
close all
clc

% Constants
KTS2MPS	= (1.852/3.6);
MPS2KTS = (3.6/1.852);
FT2M = 0.3048;
M2FT = (1/0.3048);
NM2M = 1852.0;
M2NM = (1/1852.0);
G_CONST	= 9.80665;
DEG2RAD = (pi/180.0);
RAD2DEG = (180.0/pi);

%   Global variables
global ac Tratio  accel h_target CAS_target

%   Load the aircraft model for a B777-300
[ac] = load_aircraft_bada('B773__.OPF');

altitude_options = odeset('Events', @altitude_event);
cas_options = odeset('Events', @cas_event);

%   Set up initial conditions
[rho, p, temp, soundSpeed] = Atmos(0);
CAS  = 250*KTS2MPS; % V2 + 10
t(1) = 0;
V(1) = CAStoTAS(CAS,rho,p);
h(1) = 0;
r(1) = 0;
w(1) = ac.mass.m_ref*G_CONST;

% -------------------------------------------------------
% Stage 1
% -------------------------------------------------------
Tratio      = 1.0;
h_target    = 10000.0*FT2M; % set stopping event
accel       = 0; % constant CAS profile

% Find solution to the differential equation
[tx,x] = ode45(@climb_profile, [0 300], [V(end), h(end), r(end), w(end)], altitude_options);

%   Extract height profile
t = [t; tx];
V = [V; x(:,1)];
h = [h; x(:,2)];
r = [r; x(:,3)];
w = [w; x(:,4)];

% -------------------------------------------------------
% Stage 2
% -------------------------------------------------------
Tratio      = 1.0;
CAS_target  = 300*KTS2MPS;
accel       = 1; % accelerated climb

% Find solution to the differential equation
[tx,x] = ode45(@climb_profile, [0 300], [V(end), h(end), r(end), w(end)], cas_options);

t = [t; tx+t(end)];
V = [V; x(:,1)];
h = [h; x(:,2)];
r = [r; x(:,3)];
w = [w; x(:,4)];

% -------------------------------------------------------
% Stage 3
% -------------------------------------------------------

%   Compute the crossover altitude
[h_crossover] = compute_crossover_altitude(300*KTS2MPS, 0.78);

Tratio      = 1.0;
h_target    = h_crossover; % set stopping event
accel       = 0; % constant CAS profile

% Find solution to the differential equation
[tx,x] = ode45(@climb_profile, [0 1000], [V(end), h(end), r(end), w(end)], altitude_options);

t = [t; tx+t(end)];
V = [V; x(:,1)];
h = [h; x(:,2)];
r = [r; x(:,3)];
w = [w; x(:,4)];

% -------------------------------------------------------
% Stage 4
% -------------------------------------------------------
Tratio      = 1.0;
h_target    = 35000.0*FT2M; % set stopping event
accel       = 2;  % constant Mach profile

% Find solution to the differential equation
[tx,x] = ode45(@climb_profile, [0 1000], [V(end), h(end), r(end), w(end)], altitude_options);

t = [t; tx+t(end)];
V = [V; x(:,1)];
h = [h; x(:,2)];
r = [r; x(:,3)];
w = [w; x(:,4)];


%% --------------- VISUALIZATION PART ----------------------

Vcas = [NaN];
M = [NaN];
for ii=1:length(V)
    %   Obtain pressure and density profile for the height profile
    [rho, p, temp, soundSpeed] = Atmos(h(ii));
    Vcas(ii) = TAStoCAS(V(ii), rho, p);
    M(ii) = TAStoM(V(ii), rho, p);
end

% Show results
figure(1)
plot(r*M2NM,h*M2FT/100,'LineWidth',2);
grid on
set(gca,'FontSize',16,'FontWeight','bold');
set(gca,'GridAlpha',0.4);
xlabel('Range [NM]', 'FontSize', 16, 'FontWeight', 'bold')
ylabel('Flight Level', 'FontSize', 16, 'FontWeight', 'bold');
title('Climb vs Range', 'FontSize', 16, 'FontWeight', 'bold');

figure(2)
plot(r*M2NM,V*MPS2KTS,'LineWidth',2); grid on; hold on
plot(r*M2NM,Vcas*MPS2KTS,'LineWidth',2); grid on; hold on
set(gca,'FontSize',16,'FontWeight','bold');
set(gca,'GridAlpha',0.4);
xlabel('Range [NM]', 'FontSize', 16, 'FontWeight', 'bold')
ylabel('True Airspeed [kts]', 'FontSize', 16, 'FontWeight', 'bold');
title('Airspeed vs Range', 'FontSize', 16, 'FontWeight', 'bold');

figure(3)
plot(r*M2NM,M,'LineWidth',2); grid on; hold on
set(gca,'FontSize',16,'FontWeight','bold');
set(gca,'GridAlpha',0.4);
xlabel('Range [NM]', 'FontSize', 16, 'FontWeight', 'bold')
ylabel('Mach number', 'FontSize', 16, 'FontWeight', 'bold');
title('Airspeed vs Range', 'FontSize', 16, 'FontWeight', 'bold');
