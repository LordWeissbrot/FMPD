%
%   Flight Management and Procedure Design
%
%   [Vtas] = MtoTAS(M, rho, p)
%
%   Conversion from Mach number to TAS
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%
function [Vtas] = MtoTAS(M, rho, p)

% Constants
gamma = 1.4;

Vtas = M*sqrt(gamma*p/rho);
