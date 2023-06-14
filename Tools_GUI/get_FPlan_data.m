
function [wpt_name,result,course,time,distance] = get_FPlan_data(all_wpts,i)

% Time to next Waypoint
time = '';
% if round(all_wpts.time{i}/60) >= 100 
%     time = ['0' sprintf('%d',round(all_wpts.time{i}/60))];
% elseif round(all_wpts.time{i}/60) >= 10
%     time = ['00' sprintf('%d',round(all_wpts.time{i}/60))];
% else
%     time = ['000' sprintf('%d',round(all_wpts.time{i}/60))];   
% end

% Distance to next Waypoint
if i == 1
    distance = '';
else
    distance = [sprintf('%d',round(all_wpts.dist{i-1}*(1/1852.0))) 'NM'];
end

% Course to next Waypoint
if all_wpts.crs_to_nxt{i}*180/pi < 0
    course = [sprintf('%d',round(all_wpts.crs_to_nxt{i}*180/pi + 360)) '°'];
else
    course = [sprintf('%d',round(all_wpts.crs_to_nxt{i}*180/pi)) '°'];
end

% Show the Name of the Waypoint
if all_wpts.name{i} == '0'
    
% In Case of a CA leg: show ALT as Name & Constraint
wpt_name = num2str(all_wpts.alt_bottom{i});
result = num2str(all_wpts.alt_bottom{i});    
    
else

wpt_name = all_wpts.name{i};

    % Get the SPD and ALT Constraints
    % No ALT Constraint
    if num2str(all_wpts.alt_top{i}) == '0'
        % No SPD Constraint
        if num2str(all_wpts.spd_value{i}) == '0' 
            result = '---/-----' ;
        else
            % SPD Constraint: at
            if num2str(all_wpts.spd_constraint{i}) == '1'
                result = [num2str(all_wpts.spd_value{i}) '/-----'];
            % SPD Constraint: above    
            elseif num2str(all_wpts.spd_constraint{i}) == '2'
                result = ['+' num2str(all_wpts.spd_value{i}) '/-----'];
            % SPD Constraint: below    
            elseif num2str(all_wpts.spd_constraint{i}) == '3'
                result = ['-' num2str(all_wpts.spd_value{i}) '/-----'];
            end    
        end
    % ALT Constraint    
    else
        % ALT Constraint: at
        if num2str(all_wpts.alt_constraint{i}) == '1'
            % No SPD Constraint
            if num2str(all_wpts.spd_value{i}) == '0' 
                result = ['---/ ' num2str(all_wpts.alt_top{i})];
            else
                % SPD Constraint: at
                if num2str(all_wpts.spd_constraint{i}) == '1'
                    result = [num2str(all_wpts.spd_value{i}) '/ ' num2str(all_wpts.alt_top{i})];
                % SPD Constraint: above    
                elseif num2str(all_wpts.spd_constraint{i}) == '2'
                    result = ['+' num2str(all_wpts.spd_value{i}) '/ ' num2str(all_wpts.alt_top{i})];
                % SPD Constraint: below    
                elseif num2str(all_wpts.spd_constraint{i}) == '3'
                    result = ['-' num2str(all_wpts.spd_value{i}) '/ ' num2str(all_wpts.alt_top{i})];
                end
            end
        % ALT Constraint: above    
        elseif num2str(all_wpts.alt_constraint{i}) == '2'
            % No SPD Constraint
            if num2str(all_wpts.spd_value{i}) == '0' 
                result = ['---/ +' num2str(all_wpts.alt_top{i})];
            else
                % SPD Constraint: at
                if num2str(all_wpts.spd_constraint{i}) == '1'
                    result = [num2str(all_wpts.spd_value{i}) '/ +' num2str(all_wpts.alt_top{i})];
                % SPD Constraint: above    
                elseif num2str(all_wpts.spd_constraint{i}) == '2'
                    result = ['+' num2str(all_wpts.spd_value{i}) '/ +' num2str(all_wpts.alt_top{i})];
                % SPD Constraint: below    
                elseif num2str(all_wpts.spd_constraint{i}) == '3'
                    result = ['-' num2str(all_wpts.spd_value{i}) '/ +' num2str(all_wpts.alt_top{i})];
                end
            end
        % ALT Constraint: below    
        elseif num2str(all_wpts.alt_constraint{i}) == '3'
            % No SPD Constraint
            if num2str(all_wpts.spd_value{i}) == '0' 
                result = ['---/ -' num2str(all_wpts.alt_top{i})];
            else
                % SPD Constraint: at
                if num2str(all_wpts.spd_constraint{i}) == '1'
                    result = [num2str(all_wpts.spd_value{i}) '/ -' num2str(all_wpts.alt_top{i})];
                % SPD Constraint: above    
                elseif num2str(all_wpts.spd_constraint{i}) == '2'
                    result = ['+' num2str(all_wpts.spd_value{i}) '/ -' num2str(all_wpts.alt_top{i})];
                % SPD Constraint: below    
                elseif num2str(app.all_wpts.spd_constraint{i}) == '3'
                    result = ['-' num2str(all_wpts.spd_value{i}) '/ -' num2str(all_wpts.alt_top{i})];
                end
            end
        end
    end   
end
