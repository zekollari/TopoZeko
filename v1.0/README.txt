This folder contains the MATLAB function TopoZeko and necessary data and scripts to create
all figures and animations such as described in:
% -------------------------------------------------------------------------------------- %
% -----------------------------------------'TopoZeko: ---------------------------------- %
% ----------------- A MATLAB function for 3-D and 4-D topographical -------------------- %
% -------------------------- visualisation in geosciences' ----------------------------- %
% --------------------------- (Zekollari, Journal, Year) ------------------------------- %
% -------------------------------------------------------------------------------------- %


Folder content:

- 2 MATLAB functions: TopoZeko.m and SunZeko.m
- 5 MATLAB scripts to reproduce figures from paper:
    o example_Morteratsch_figure1.m (uses TopoZeko.m)
    o example_Galapagos_figure2.m (uses TopoZeko.m)
    o example_Morteratsch_figure3.m (uses TopoZeko.m)
    o example_Morteratsch_video.m (uses TopoZeko.m)
    o example_Galapagos_video.m (uses TopoZeko.m and SunZeko.m)
- Data needed to reproduce figures (DEM of surface and bedrock elevation):
	o example_data_Morteratsch_25m.mat
	o example_data_Galapagos_100m.mat
- 2 animations (videos) that are created with scripts:
	o video1_glacier_retreat_4d.avi
	o video2_Galapagos_shadow_decl23.avi