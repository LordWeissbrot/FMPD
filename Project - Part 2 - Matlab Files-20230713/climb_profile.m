
%
%   Flight Management and Procedure Design
%
%   dxdt = climb_profile(t,x)
%
%   Climb at Tratio*maximum thrust
%
%   State vector x = [V; h; r; W] 
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%
function dxdt = climb_profile(t,x)

% Global variables
global ac Tratio accel

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

%   Extract the height from the state vector
V    = x(1);
h    = x(2);
r    = x(3);
W    = x(4);

%   Compute air density, air pressure, temperature and speed of sound
[rho, p, temp, soundSpeed] = Atmos(h);

%   Compute Mach number
M = TAStoM(V, rho, p);

%   Compute the thrust based on aircraft model
T = compute_T_climb(ac, h, Tratio);

%   Compute the drag based on aircraft model, true airspeed and BADA
%   assumptions
D = compute_D_climb(ac, V, h, W);

%   Compute fuel rate factor
eta = ac.fuel.Cf1*(1 + V/ac.fuel.Cf2)/(60*1000.0); % min.kN --> s.N   

%   Compute Energy Share Factor
if accel == 0
    %   Constant CAS
    fM = constant_CAS_ESF(M,h);
elseif accel == 1
    %   Accelerating climb - BADA factor of 0.3
    fM = 0.3;
elseif accel == 2
    %   Constant Mach
    fM = constant_M_ESF(M,h);
end

%   Compute the velocity change as a function of height change
dVdh = (G_CONST/V)*(1/fM - 1);

%   Vertical speed
hdot = fM*(T-D)*V/W;

%   Flight path angle
gamma = asin(hdot/V);

%   Compute Vdot
Vdot = (G_CONST/W)*(T-D-W*sin(gamma));

% Equation for dx/dt vector
dxdt = [    Vdot; ...
            hdot; ...
            V*cos(gamma); ...
            -eta*T];

return

