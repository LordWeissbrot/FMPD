
%
%   compute_crossover_altitude.m
%
%   Function:   Compute the corssover altitude given a Mach number and CAS
%
%   Input:      CAS [m/s] - calibrated airspeed
%               M - Mach number
%   
%   Output:     h [m] - crossover altitude
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%

function [h] = compute_crossover_altitude(CAS, M)


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

delta_trans = ((1.0 + temp1*(CAS/a0)^2)^(temp2) - 1.0 )/(( 1.0 + temp1*M^2)^(temp2) - 1.0);

theta_trans = delta_trans^(-beta*R/g0);

h = (T0/beta)*(theta_trans-1);



