
%
%   Flight Management and Procedure Design
%
%   [T] = compute_T_climb(ac, h, perc)
%
%   Compute thrust based on BADA assumptions
%
%   Input:  perc    -   percentage of maximum thrust
%           h       -   height [m]
%           ac      -   BADA aircraft model
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%
function [T] = compute_T_climb(ac, h, perc)

%   Constants
FT2M = 0.3048;

%   Compute the thrust
Ctc1 = ac.enginethrust.Ctc1;
Ctc2 = ac.enginethrust.Ctc2*FT2M;
Ctc3 = ac.enginethrust.Ctc3/(FT2M^2);
T_max_climb_isa =  Ctc1*(1.0 - h/Ctc2 + Ctc3*h^2);

%   Compensate for non-standard atmospere
T_max_climb = T_max_climb_isa; % for now

%   Compute thrust
T = T_max_climb*perc;

return