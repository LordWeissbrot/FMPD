function [lat, lon, dist12] = create_straight(pt1, pt2, N)

[dist12, crs12, crs21] = inverse(pt1.lat,pt1.lon,pt2.lat,pt2.lon);

if crs12 < 0.0
    crs12 = crs12 + 2*pi;
end

% Put 100 points between DODAT and NAKIP using the direct method

lat = [];
lon = [];
for ii=1:N

    [lat(ii), lon(ii), crs21] = direct(pt1.lat,pt1.lon, (ii-1)*dist12/N, crs12);

end