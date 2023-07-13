%
%   Flight Management and Procedure Design
%
%   [value,isterminal,direction] = altitude_event(t,x)
%
%   Stopping event based on a height target
%   If h > h_target, the ODE will stop
%   
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%
function [value,isterminal,direction] = altitude_event(t,x)

global h_target

value =  h_target - x(2);
isterminal = 1;
direction = 0;