
%
%   combine_wpt_structs.m   
%
%   Flight Management and Procedure Design
%
%   Copyright (c) 2020 TU Berlin FF
%
function [wpt_struct] = combine_wpt_structs(wpt_struct1, wpt_struct2)

fields = fieldnames(wpt_struct1);

for i=1:numel(fields)
  fields(i);
  a = {wpt_struct1.(fields{i}), wpt_struct2.(fields{i})};
  wpt_struct.(fields{i}) = cat(2,a{:});
end