
function [departure_rwys, sids_rwys, sids, rwys_llh] = load_departures(origin_filename)

%   Get all the runways 
[departure_rwys] = get_departure_rwys(origin_filename);

%   Get the cooridinates for all runways 
[rwys_llh] = get_rwy_coordinates(origin_filename, departure_rwys);

%   get all the SIDs
[sids_rwys, sids] = get_sids(origin_filename);

