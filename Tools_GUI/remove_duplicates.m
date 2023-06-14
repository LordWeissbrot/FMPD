
%
%   remove_duplicates.m   
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%
function [new_all_wpts] = remove_duplicates(all_wpts)


index = 1;
for ii=1:length(all_wpts.name)

    
    if (ii == 1) 
        new_all_wpts.line{index} = all_wpts.line{ii};
        new_all_wpts.leg_type{index} = all_wpts.leg_type{ii};
        new_all_wpts.name{index} = all_wpts.name{ii};
        new_all_wpts.lat{index} = all_wpts.lat{ii};
        new_all_wpts.lon{index} = all_wpts.lon{ii};
        new_all_wpts.alt_constraint{index} = all_wpts.alt_constraint{ii};
        new_all_wpts.alt_top{index} = all_wpts.alt_top{ii};
        new_all_wpts.alt_bottom{index} = all_wpts.alt_bottom{ii};
        new_all_wpts.spd_constraint{index} = all_wpts.spd_constraint{ii};
        new_all_wpts.spd_value{index} = all_wpts.spd_value{ii};
        new_all_wpts.crs{index} = all_wpts.crs{ii};
        new_all_wpts.center_lat{index} = all_wpts.center_lat{ii};
        new_all_wpts.center_lon{index} = all_wpts.center_lon{ii};
        index = index + 1;
    elseif ~strcmp(all_wpts.name{ii}, all_wpts.name{ii-1})
        new_all_wpts.line{index} = all_wpts.line{ii};
        new_all_wpts.leg_type{index} = all_wpts.leg_type{ii};
        new_all_wpts.name{index} = all_wpts.name{ii};
        new_all_wpts.lat{index} = all_wpts.lat{ii};
        new_all_wpts.lon{index} = all_wpts.lon{ii};
        new_all_wpts.alt_constraint{index} = all_wpts.alt_constraint{ii};
        new_all_wpts.alt_top{index} = all_wpts.alt_top{ii};
        new_all_wpts.alt_bottom{index} = all_wpts.alt_bottom{ii};
        new_all_wpts.spd_constraint{index} = all_wpts.spd_constraint{ii};
        new_all_wpts.spd_value{index} = all_wpts.spd_value{ii};
        new_all_wpts.crs{index} = all_wpts.crs{ii};
        new_all_wpts.center_lat{index} = all_wpts.center_lat{ii};
        new_all_wpts.center_lon{index} = all_wpts.center_lon{ii};
        index = index + 1;
    end
    
    
end



