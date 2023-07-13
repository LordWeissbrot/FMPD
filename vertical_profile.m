%
%   Flight Management and Procedure Design
%
%    Project Part 2
%
%     1. Climb from the airport to 1500 ft at a constant CAS = 176kts (V2+10)
%     2. Then, climb at 85% thrust from 1500 ft to 3000ft at constant CAS = 176kts
%     3. Then, accelerated climb at 100% thrust till CAS = 250kts
%     4. Then, climb to 10000 ft (FL100) at a constant CAS = 250kts
%     5. Then, an accelerated climb to CAS = 300kt
%     6. Then, climb at constant CAS = 300kts till the crossover altitude
%     7. Then, climb at constant Mach (M = 0.78) till cruising altitude (FL350)
% 

clear all
close all
clc

% Constants
KTS2MPS	= (1.852/3.6);
FT2M = 0.3048;
M2FT = (1/0.3048);
G_CONST	= 9.80665;
M2NM = (1/1852.0);
MPS2KTS = (3.6/1.852);

%   Global variables
global ac Tratio  accel h_target CAS_target

%   Load the aircraft model for a A320
[ac] = load_aircraft_bada('B773__.OPF');

altitude_options = odeset('Events', @altitude_event);
cas_options = odeset('Events', @cas_event);

%   Set up initial conditions
[rho, p, temp, soundSpeed] = Atmos(0);
CAS  = 176*KTS2MPS; % V2 + 10
t(1) = 0;
V(1) = CAStoTAS(CAS,rho,p);
h(1) = 0;
r(1) = 0;
w(1) = ac.mass.m_ref*G_CONST;

% -------------------------------------------------------
% Stage 1 - First constant climb to 1500ft
% -------------------------------------------------------
Tratio      = 1.0;
h_target    = 1500*FT2M; % set stopping event
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
% Stage 2 - Second constant climb to 3000ft
% -------------------------------------------------------
Tratio      = 0.85;
h_target    = 3000*FT2M; % set stopping event
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
% Stage 3 - First accelerated climb till 250kts
% -------------------------------------------------------
Tratio      = 1;
CAS_target  = 250*KTS2MPS; % set stopping event
accel       = 1; % accelerated CAS profile

% Find solution to the differential equation
[tx,x] = ode45(@climb_profile, [0 300], [V(end), h(end), r(end), w(end)], cas_options);

%   Extract height profile
t = [t; tx];
V = [V; x(:,1)];
h = [h; x(:,2)];
r = [r; x(:,3)];
w = [w; x(:,4)];

% -------------------------------------------------------
% Stage 4 - Third constant climb to 10000ft
% -------------------------------------------------------
Tratio      = 0.85;
h_target    = 10000*FT2M; % set stopping event
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
% Stage 5 - Second accelerated climb till 300kts
% -------------------------------------------------------
Tratio      = 0.85;
CAS_target  = 300*KTS2MPS; % set stopping event
accel       = 1; % accelerated CAS profile

% Find solution to the differential equation
[tx,x] = ode45(@climb_profile, [0 1000], [V(end), h(end), r(end), w(end)], cas_options);

%   Extract height profile
t = [t; tx];
V = [V; x(:,1)];
h = [h; x(:,2)];
r = [r; x(:,3)];
w = [w; x(:,4)];

% -------------------------------------------------------
% Stage 6 - Third constant climb to crossover altitude
% -------------------------------------------------------

%   Compute the crossover altitude
[h_crossover] = compute_crossover_altitude(300*KTS2MPS, 0.78);

Tratio      = 0.85;
h_target    = h_crossover; % set stopping event
accel       = 0; % constant CAS profile

% Find solution to the differential equation
[tx,x] = ode45(@climb_profile, [0 1000], [V(end), h(end), r(end), w(end)], altitude_options);

%   Extract height profile
t = [t; tx];
V = [V; x(:,1)];
h = [h; x(:,2)];
r = [r; x(:,3)];
w = [w; x(:,4)];

% -------------------------------------------------------
% Stage 7 - Third constant climb to crossover altitude
% -------------------------------------------------------
Tratio      = 0.85;
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

x = 32;
y = 18;
options.units = 'centimeters';
options.FontMode = 'Fixed'; %This line and next are the important bit
options.format = 'eps'; %or whatever options you'd like
options.FontName = 'arial';
options.FixedFontSize = 20;
options.Renderer = 'painters';
options.Width = x;
options.Height = y;
set(gcf,'PaperOrientation','portrait','units','centimeters','PaperSize',[x y],'PaperPosition',[0 0 x y])

plot(r*M2NM,h*M2FT/100,'LineWidth',2);
grid on
set(gca,'FontSize',16,'FontWeight','bold');
set(gca,'GridAlpha',0.4);
xlabel('Range [NM]', 'FontSize', 16, 'FontWeight', 'bold')
ylabel('Flight Level', 'FontSize', 16, 'FontWeight', 'bold');
% title('Climb vs Range', 'FontSize', 16, 'FontWeight', 'bold');

ax = gca;
ax.FontSize = 15;  

hgexport(gcf,'H_r.eps',options);
saveas( gcf , 'H_r.png' );

figure(2)

x = 32;
y = 18;
options.units = 'centimeters';
options.FontMode = 'Fixed'; %This line and next are the important bit
options.format = 'eps'; %or whatever options you'd like
options.FontName = 'arial';
options.FixedFontSize = 20;
options.Renderer = 'painters';
options.Width = x;
options.Height = y;
set(gcf,'PaperOrientation','portrait','units','centimeters','PaperSize',[x y],'PaperPosition',[0 0 x y])

plot(r*M2NM,V*MPS2KTS,'LineWidth',2); grid on; hold on
plot(r*M2NM,Vcas*MPS2KTS,'LineWidth',2); grid on; hold on
set(gca,'FontSize',16,'FontWeight','bold');
set(gca,'GridAlpha',0.4);
xlabel('Range [NM]', 'FontSize', 16, 'FontWeight', 'bold')
ylabel('Airspeed [kts]', 'FontSize', 16, 'FontWeight', 'bold');
% title('Airspeed vs Range', 'FontSize', 16, 'FontWeight', 'bold');
legend('TAS', 'CAS', 'FontSize', 16, 'Location','southeast')

ax = gca;
ax.FontSize = 15;  

hgexport(gcf,'V_r.eps',options);
saveas( gcf , 'V_r.png' );

figure(3)

x = 32;
y = 18;
options.units = 'centimeters';
options.FontMode = 'Fixed'; %This line and next are the important bit
options.format = 'eps'; %or whatever options you'd like
options.FixedFontSize = 20;
options.FontName = 'arial';
options.Renderer = 'painters';
options.Width = x;
options.Height = y;
set(gcf,'PaperOrientation','portrait','units','centimeters','PaperSize',[x y],'PaperPosition',[0 0 x y])

plot(r*M2NM,M,'LineWidth',2); grid on; hold on
set(gca,'FontSize',16,'FontWeight','bold');
set(gca,'GridAlpha',0.4);
xlabel('Range [NM]', 'FontSize', 16, 'FontWeight', 'bold')
ylabel('Mach number', 'FontSize', 16, 'FontWeight', 'bold');
% title('Airspeed vs Range', 'FontSize', 16, 'FontWeight', 'bold');

ax = gca;
ax.FontSize = 15;  

hgexport(gcf,'M_r.eps',options);
saveas( gcf , 'M_r.png' );
