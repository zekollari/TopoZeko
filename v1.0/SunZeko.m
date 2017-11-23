function [h,a] = SunZeko(Decl,Lat,LHA)
% sun_zeko is a MATLAB function that calculates the position of the
% sun (height and azimuth) for a given declination of the sun (Decl),
% geographic latitude (LAT) and Local Hour Angle (LHA). It is strongly 
% encouraged to use this code for your scientific publications,
% presentations,teaching material,...etc.
% Additional information, examples and reference:
% ----------------------------------------------------------------------- %
% ------------------------------ 'TopoZeko: ----------------------------- %
% --------- A MATLAB function for 3-D and 4-D topographical ------------- %
% ------------------ visualisation in geosciences' ---------------------- %
% ------------- (Zekollari, SoftwareX 6 (2017) 285-292) ----------------- %
% ----------------------------------------------------------------------- %
% ------------- All functions, scripts and data related ----------------- %
% ---------------- to TopoZeko are available online: -------------------- %
% ------------------ github.com/zekollari/TopoZeko ---------------------- %
% ----------------------------------------------------------------------- %

% Calculation of the elevation of the sun (h)
h=asind(sind(Lat)*sind(Decl)+cosd(Lat)*cosd(Decl)*cosd(LHA));

% Calculation of the azimuth of the sun:

%  First method (Cosine-formula):
numerator=sind(Lat)*sind(h)-sind(Decl);
denominator=cosd(Lat)*cosd(h);
a11=acosd(numerator/denominator);
a12=-a11;
if a11>180
    a11=a11-360;
end
if a12>180
    a12=a12-360;
end

% Second method (Sine-formula):
a21=asind((sind(LHA)*cosd(Decl))/cosd(h));
a22=180-a21;
if a21>180
    a21=a21-360;
end
if a22>180
    a22=a22-360;
end

% Find which answer is recurrent: this is the correct answer
if round(a11)==round(a21) || round(a11)==round(a22)
    a=a11;
elseif round(a12)==round(a21) || round(a12)==round(a22)
    a=a12;
end

a=-a; % In order to agree with the azimuth as defined by MATLAB

end

