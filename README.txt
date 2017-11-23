% -------------------------------------------------------------------------------------- %
% ------------------------------------- Description ------------------------------------ %
% -------------------------------------------------------------------------------------- %
TopoZeko is a MATLAB function developed to make 3-D and 4-D plots of surfaces with a 
pronounced topographical setting such as glaciers, volcanoes and lakes in mountaineous 
regions. It is strongly encouraged to use this code for your scientific publications, 
presentations, teaching material,...etc.

% -------------------------------------------------------------------------------------- %
% -------------------------------------- Reference ------------------------------------- %
% -------------------------------------------------------------------------------------- %
Zekollari, H. (2017), A MATLAB function for 3-D and 4-D topographical visualisation 
in geosciences, SoftwareX, 6, 285-292.

Consult this manuscript for various examples, applications and documentation of the 
TopoZeko function.

% -------------------------------------------------------------------------------------- %
% --------------------------------- Usage and examples --------------------------------- %
% -------------------------------------------------------------------------------------- %
All files (function, scripts and data) are available in the folders with the respective 
version numbers. Launch the scripts (e.g. example_Morteratsch_figure2.m) to reproduce the 
figures from the manuscript. For your own visualizations use the TopoZeko.m function and 
adapt to specific needs.

Examples of function calls:

--> Example 1: TopoZeko(BED,ELEV): generates a 3-D surface plot of the matrix
'ELEV'. Where 'BED' and 'ELEV' differ the surface elevation is displayed
in a given color (standard: white)

--> Example 2: TopoZeko(BED,ELEV,'extra_dimension','on'): generates a 3-D
surface plot of the matrix 'ELEV'. Where 'BED' and 'ELEV' differ the
local difference is displayed using a colorbar (standard: colormap 'jet')

--> Example 3: TopoZeko(BED,ELEV,'extra_dimension',VEL): generates a 3-D
surface plot of the matrix 'ELEV'. The colorbar is used to display the
matrix 'VEL' (4th dimension)

The visualization can be modified with up to 40 additional parameters
when calling the function (see manuscript for more info).

% -------------------------------------------------------------------------------------- %
% -------------------------------------- Version --------------------------------------- %
% -------------------------------------------------------------------------------------- %
---> v1.0: first version, as described in the manuscript