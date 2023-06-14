

function [approaches, transitions, stars] = load_arrivals(destination_filename)

%   Get all the STARs if available
[stars] = get_stars(destination_filename);

%   Get all the runways 
[approaches] = get_approach_rwys(destination_filename);

%   Get all the approach transitions 
[transitions] = get_transitions(destination_filename);

