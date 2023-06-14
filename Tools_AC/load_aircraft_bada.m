%
%   [ac] = LoadAircraftBADA(filename)
%
%   Load BADA 3.6 aircraft parameters
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%
function [ac] = load_aircraft_bada(filename)

    fttom = 0.3048;
    kttoms = 0.514444;
    degtok = 273.15;
    
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
    DEG2K = 273.15;
    
    % Open the aircraft performance data input file
    fid = fopen(filename);
    
    % Go through all parameters and fill in the structure
    tline = fgetl(fid);
    while ischar(tline)
        if(size(strfind(tline, 'engines')) > 0)
            tokk = sscanf(tline, '%*s %d %*s');
            %ac.engines.N = tokk(1);
        % ---------------------------------------------------------------    
        % Mass-related parameters   
        % ---------------------------------------------------------------
        elseif(size(strfind(tline, 'Mass (t)')) > 0)
            tline = fgetl(fid);
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %f %f %f %f %*s');
            ac.mass.m_ref = tokk(1)*1000;   % Reference Mass
            ac.mass.m_min = tokk(2)*1000; 
            ac.mass.m_max = tokk(3)*1000; 
            ac.mass.m_max_payload = tokk(4)*1000; 
            ac.mass.m_max_grad = tokk(5)*1000; 
            
        % ---------------------------------------------------------------    
        % Flight envelope-related parameters   
        % ---------------------------------------------------------------
        elseif(size(strfind(tline, 'Flight envelope')) > 0)
            tline = fgetl(fid);
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %f %f %f %f %*s');
            ac.envelope.Vmo = tokk(1);   
            ac.envelope.Mmo = tokk(2);
            ac.envelope.alt_max = tokk(3);
            ac.envelope.h_max = tokk(4);
            ac.envelope.T_grad = tokk(5);
  
        % ---------------------------------------------------------------    
        % Aerodynamics   
        % ---------------------------------------------------------------
        elseif(size(strfind(tline, 'Aerodynamics')) > 0)
            tline = fgetl(fid);
            tline = fgetl(fid);
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %d %f %f %f %f %*s');
            ac.aero.S = tokk(2);    % Surface
            tline = fgetl(fid);
            tline = fgetl(fid);
            
            % For CRuise
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %s %s %f %f %f %f %*s');
            ac.aero.cruise.flaps = 0.0;
            ac.aero.cruise.Vstall =  tokk(numel(tokk) - 3);
            ac.aero.cruise.Cd0 = tokk(numel(tokk) - 2);    % Aerodynamics Coefficient
            ac.aero.cruise.Cd2 = tokk(numel(tokk) - 1);    % Aerodynamics Coefficient
            
            % For Initial Climb (IC)
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %s %s %f %f %f %f %*s');
            ac.aero.initialclimb.flaps = 1.0;
            ac.aero.initialclimb.Vstall =  tokk(numel(tokk) - 3);
            ac.aero.initialclimb.Cd0 = tokk(numel(tokk) - 2);    % Aerodynamics Coefficient
            ac.aero.initialclimb.Cd2 = tokk(numel(tokk) - 1);    % Aerodynamics Coefficient
            
            % For Take-Off (TO)
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %s %s %f %f %f %f %*s');
            ac.aero.takeoff.flaps = 5.0;
            ac.aero.takeoff.Vstall =  tokk(numel(tokk) - 3);
            ac.aero.takeoff.Cd0 = tokk(numel(tokk) - 2);    % Aerodynamics Coefficient
            ac.aero.takeoff.Cd2 = tokk(numel(tokk) - 1);    % Aerodynamics Coefficient
            
            % For Approach (AP)
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %s %s %f %f %f %f %*s');
            ac.aero.approach.flaps = 15.0;
            ac.aero.approach.Vstall =  tokk(numel(tokk) - 3);
            ac.aero.approach.Cd0 = tokk(numel(tokk) - 2);    % Aerodynamics Coefficient
            ac.aero.approach.Cd2 = tokk(numel(tokk) - 1);    % Aerodynamics Coefficient
            
            % For Landing (LD)
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %s %s %f %f %f %f %*s');
            ac.aero.landing.flaps = 30.0;
            ac.aero.landing.Vstall =  tokk(numel(tokk) - 3);
            ac.aero.landing.Cd0 = tokk(numel(tokk) - 2);    % Aerodynamics Coefficient
            ac.aero.landing.Cd2 = tokk(numel(tokk) - 1);    % Aerodynamics Coefficient

        % ---------------------------------------------------------------    
        % Engine thrust  
        % ---------------------------------------------------------------
        elseif(size(strfind(tline, 'Engine Thrust')) > 0)
            tline = fgetl(fid);
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %f %f %f %f %*s');
            ac.enginethrust.Ctc1 = tokk(1);                 % 1st max. climb thrust coefficient
            ac.enginethrust.Ctc2 = tokk(2);                 % 2nd max. climb thrust coefficient
            ac.enginethrust.Ctc3 = tokk(3);                 % 3rd max. climb thrust coefficient
            ac.enginethrust.Ctc4 = tokk(4);                 % 1st thrust temperature coefficient
            ac.enginethrust.Ctc5 = tokk(5);                 % 2nd thrust temperature coefficient
            tline = fgetl(fid);
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %f %f %f %f %*s');
            ac.enginethrust.Ctcdeslow = tokk(1);            % low altitude descent thrust coefficient
            ac.enginethrust.Ctcdeshigh = tokk(2);           % high altitude descent thrust coefficient
            ac.enginethrust.h_des   = tokk(3);         % transition altitude for calculation of descent thrust          
            ac.enginethrust.Ctcdesapp = tokk(4);            % approach thrust coefficient
            ac.enginethrust.Ctcdesld = tokk(5);             % landing thrust coefficient
            tline = fgetl(fid);
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %f %f %f %f %*s');
            ac.enginethrust.Vdes_ref = tokk(1);     % reference descent speed (CAS)
            ac.enginethrust.Mdes_ref = tokk(2);             % reference descent Mach number
            
        % ---------------------------------------------------------------    
        % Fuel Consumption 
        % ---------------------------------------------------------------    
        elseif(size(strfind(tline, 'Fuel Consumption')) > 0)
            tline = fgetl(fid);
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %f %*s');
            ac.fuel.Cf1 = tokk(1);      % 1st thrust specific fuel consumption coefficient
            ac.fuel.Cf2 = tokk(2);      % 2nd thrust specific fuel consumption coefficient
            tline = fgetl(fid);
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %f %*s');
            ac.fuel.Cf3 = tokk(1);      % 1st descent fuel flow coefficient
            ac.fuel.Cf4 = tokk(2);      % 2nd descent fuel flow coefficient
            tline = fgetl(fid);
            tline = fgetl(fid);
            tokk = sscanf(tline, '%*s %f %f %*s');
            ac.fuel.Cfcr = tokk(1);     % Cruise fuel flow correction coefficient
        end
        tline = fgetl(fid);
    end

    %fprintf('Ctc1 %f Ctc2 %f Ctc3 %f Ctc4 %f Ctc5 %f Ctcdeslow %f Ctcdeshigh %f Ctcdeslvl %f Ctcdesapp %f Ctcdesld %f\n', Ctc1, Ctc2, Ctc3, Ctc4, Ctc5, Ctcdeslow, Ctcdeshigh, Ctcdeslvl, Ctcdesapp, Ctcdesld);


    fclose(fid);

return
