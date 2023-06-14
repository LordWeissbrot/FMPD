

function [lat, lon, dist] = create_arc(pt1, pt2, pt3, N)


[dist13, crs13, crs31] = inverse(pt1.lat,pt1.lon,pt3.lat,pt3.lon);
[dist23, crs23, crs32] = inverse(pt2.lat,pt2.lon,pt3.lat,pt3.lon);

radius = dist13;

d_angle = signed_azimuth_difference(crs32, crs31)/N;

signed_azimuth_difference(crs32, crs31)*180/pi-360;

lat = [];
lon = [];
dist = 0.0;
for ii=1:(N-1)

    [lat(ii), lon(ii), crs21] = direct(pt3.lat,pt3.lon, radius, crs31+(ii-1)*d_angle);

    if ii > 1
        [dist_temp, temp1, temp2] = inverse(lat(ii-1),lon(ii-1),lat(ii),lon(ii));
        
        dist = dist + dist_temp;
    end
end

[dist_temp, temp1, temp2] = inverse(lat(end),lon(end),pt2.lat,pt2.lon);
        
dist = dist + dist_temp;


