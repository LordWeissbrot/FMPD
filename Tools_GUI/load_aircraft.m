%
%   parse_waypoints.m   
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%
function [aircraft] = load_aicraft(directory_name)

%   Load all aircraft file names from the directory 
a = dir('Aircraft');

%   Find
aircraft = {};
index = 1;
for ii=3:length(a)
    if strcmp(a(ii).name(8:10),'OPF')
        aircraft{index} = a(ii).name(1:4);
        index = index + 1;
    end
end