
%
%   Flight Management and Procedure Design
%
%   [fM] = constant_M_ESF(M, h)
%
%   Calculates Energy Share Factor (See BASA 3.10) 
%   for constant Mach vertical profile
%
%   Input:  M   -  Mach number
%           h   -  Height [m] - to check for Tropopause
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%
function [fM] = constant_M_ESF(M, h)

T0 = 288.15;    % [K]
p0 = 101325;    % [Pa]
rho0 = 1.225;   % [kg/m3]
a0 = 340.294;   % [m/s]

kappa   = 1.4;
R = 287.05287;
g0 = 9.80665;
beta = -0.0065;

temp1 = (kappa - 1.0)/2.0;
temp2 = kappa/(kappa - 1.0);
temp3 = (1+temp1*M^2);
temp4 = temp3^(temp2) - 1;
temp5 = temp3^(-1/(kappa-1));

if h < 11000
    temp6 = 1 + M^2*(kappa*R*beta)/(2.0*g0);
else
    temp6 = 1;
end

fM = temp6^(-1);

