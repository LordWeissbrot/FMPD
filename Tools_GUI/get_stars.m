

function [stars] = get_stars(airport_filename)

%   Open the file for the airport of interest
fid = fopen(airport_filename,'r');

% Go though the file and find the type and arrival
index = 2;
stars.name{1} = '---';
stars.rwys{1} = '---';
while ~feof(fid) 
    
    % Get line of text
    a = fgetl(fid);
    
    % Break the line into two parts: part before and after the ':'
    b = split(a,',');
    
    if length(b) >= 4
        if strcmp(b{1},'STAR')
            
            stars.name{index} = b{2};
            stars.rwys{index} = b{3};
            index = index + 1;
   
        end
    end
end

% %   Go through all the STARS and combine
% stars = [];
% index = 1;
% select = ones(length(strs),1);
% for ii=1:length(strs)
% 
%     %   Find all duplicates
%     ind = find(contains(strs,strs{ii}));
%     
%     if select(ii) == 1
%         stars{index}.name = strs{ii};
%         for jj=1:length(ind)
%             stars{index}.rwys{jj} = rwys{ind(jj)};
%         end
%         select(ind) = 0;
%         
%         index = index + 1;
%     end
% 
% end


%   Close the file for the airport of interest
fclose(fid);