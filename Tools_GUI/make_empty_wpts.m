%
%   make_empty_wpts.m   
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%
function [wpt] = make_empty_wpts()

wpt.line = {};
wpt.leg_type = {};
wpt.name = {};
wpt.lat = {};
wpt.lon = {};
wpt.alt_constraint = {};
wpt.alt_top = {};
wpt.alt_bottom = {};
wpt.spd_constraint = {};
wpt.spd_value = {};
wpt.crs = {};
wpt.center_lat = {};
wpt.center_lon = {};