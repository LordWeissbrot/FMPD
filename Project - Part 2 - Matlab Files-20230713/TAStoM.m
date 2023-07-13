%
%   Flight Management and Procedure Design
%
%   Conversion from TAS to Mach number
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%
function [M] = TAStoM(Vtas, rho, p)

% Constants
gamma = 1.4;

M = Vtas/sqrt(gamma*p/rho);