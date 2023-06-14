
%
%   generate_takeoff_rwy_wpt.m   
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%
function [wpt] = generate_takeoff_rwy_wpt(rwy, departure_rwys, rwys_llh)

%   At least return an empty cell array
[wpt] = make_empty_wpts();

wpt.line{1} = 'Takeoff runway';
wpt.leg_type{1} = 'RW';
wpt.name{1} = ['RW' rwy];

ind = find(ismember(departure_rwys,rwy));

wpt.lat{1} = rwys_llh(1,ind);
wpt.lon{1} = rwys_llh(2,ind);
wpt.alt_constraint{1} = 1;
wpt.alt_top{1} = rwys_llh(3,ind);
wpt.alt_bottom{1} = 0;
wpt.spd_constraint{1} = 0;
wpt.spd_value{1} = 0;
wpt.crs{1} = 0;
wpt.center_lat{1} = 0;
wpt.center_lon{1} = 0;

