%
%   Flight Management and Procedure Design
%
%   [D] = compute_D_climb(ac, V, h, W)
%
%   Compute drag based on BADA assumptions
%
%   Copyright(c) Chair for Flight Guidance and Air Traffic
%   Institute of Aeronautics and Astronautics
%   TU Berlin
%
function [D] = compute_D_climb(ac, V, h, W)

    %   Constants
    G_CONST	= 9.80665;
    M2FT = (1/0.3048);

    %   Compute air denisty, air pressure, temperature and speed of sound
    [rho, p, temp, soundSpeed] = Atmos(h);

    %   Climb configuration according to BADA
    %   TO (take-off) till 400ft
    %   IC (initial climb) till 2000ft
    %   CR (cruise) above 200-ft
    if h*M2FT < 400  
        %   Compute drag
        D = ac.aero.takeoff.Cd0*(0.5*rho*V^2*ac.aero.S) + 2*ac.aero.takeoff.Cd2*(W)^2/(rho*V^2*ac.aero.S);  
    elseif h*M2FT < 2000  
        %   Compute drag
        D = ac.aero.initialclimb.Cd0*(0.5*rho*V^2*ac.aero.S) + 2*ac.aero.initialclimb.Cd2*(W)^2/(rho*V^2*ac.aero.S);  
    else  
        %   Compute drag
        D = ac.aero.cruise.Cd0*(0.5*rho*V^2*ac.aero.S) + 2*ac.aero.cruise.Cd2*(W)^2/(rho*V^2*ac.aero.S);  
    end

return
 