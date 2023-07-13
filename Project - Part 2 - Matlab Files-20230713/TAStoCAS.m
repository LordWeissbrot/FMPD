
%
%   Flight Management and Procedure Design
%
%   [Vcas] = TAStoCAS(Vtas, rho, p)
%
%   Conversion from CAS to TAS
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%
function [Vcas] = TAStoCAS(Vtas, rho, p)

% Constants
R = 287.05287;
gamma = 1.4;
mu = (gamma-1)/gamma;

% Sea-level
[rho0, p0, temp0, soundSpeed0] = Atmos(0.0);

% Compute CAS from TAS
temp1 = (1+(mu/2)*(rho./p).*Vtas.^2);
temp2 = temp1.^(1/mu) - 1;
temp3 = (p/p0).*temp2 + 1;
temp4 = temp3.^mu - 1;
temp5 = (2/mu)*(p0/rho0)*temp4;

% Compute airspeed
Vcas = sqrt(temp5);
