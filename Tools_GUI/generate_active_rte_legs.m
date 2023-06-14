
%
%   generate_active_rte_legs.m   
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%
function [act_rte_legs] = generate_active_rte_legs(all_wpts)

act_rte_legs = {};
ind = 1;
for ii=1:length(all_wpts.name)
    
   if all_wpts.spd_constraint{ii} ~= 0
       spd_str = sprintf('%4.0f',all_wpts.spd_value{ii});
   else
       spd_str = sprintf(' ---');
   end

   if all_wpts.alt_constraint{ii} == 1
       alt_str = sprintf('/%5.0f',all_wpts.alt_top{ii});
   elseif all_wpts.alt_constraint{ii} == 2
       alt_str = sprintf('/%5.0fA',all_wpts.alt_top{ii});
   elseif all_wpts.alt_constraint{ii} == 3
       alt_str = sprintf('/%5.0fB',all_wpts.alt_top{ii});
   elseif all_wpts.alt_constraint{ii} == 4
       alt_str = sprintf('/%5.0fA',all_wpts.alt_bottom{ii});
   else
       alt_str = sprintf('/ ---');
   end
   act_rte_legs{ind}    = sprintf(' %8s\t\t\t%s%s',  all_wpts.name{ii}, spd_str, alt_str);     
   
   crs = all_wpts.crs_to_nxt{ii}*180/pi;
   if crs < 0.0
       crs = crs + 360.0;
   end
   
   if ~isnan(all_wpts.dist_to_nxt{ii})
        act_rte_legs{ind+1}  = sprintf('      %8.0f\xB0      %3.0fNM',  crs, all_wpts.dist_to_nxt{ii}/1852.0);      
   else
        act_rte_legs{ind+1}  = sprintf('   ');  
   end
   ind = ind + 2;
end


