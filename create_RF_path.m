

function [lat, lon] = create_RF_path(pt1, pt2, pt3, N)


[dist13, crs13, crs31] = inverse(pt1.lat,pt1.lon,pt3.lat,pt3.lon);
[dist23, crs23, crs32] = inverse(pt2.lat,pt2.lon,pt3.lat,pt3.lon);

radius = dist13;

d_angle = signed_azimuth_difference(crs32, crs31)/N;

signed_azimuth_difference(crs32, crs31)*180/pi-360;

lat = [];
lon = [];
for ii=1:(N-1)

    [lat(ii), lon(ii), crs21] = direct(pt3.lat,pt3.lon, radius, crs31+ii*d_angle);

end
