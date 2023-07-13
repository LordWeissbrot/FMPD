%
%   Flight Management and Procedure Design
%
%   [value,isterminal,direction] = cas_event(t,x)
%
%   Stopping event based on a CAS target
%   If CAS > CAS_target, the ODE will stop
%   CAS is calculated based on V and h (ISA conditions)
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%
function [value,isterminal,direction] = cas_event(t,x)

global CAS_target

V = x(1);
h = x(2);

%   Compute air density, air pressure, temperature and speed of sound
[rho, p, temp, soundSpeed] = Atmos(h);

%   Compute CAS
Vcas = TAStoCAS(V, rho, p);

value =  CAS_target - Vcas;
isterminal = 1;
direction = 0;