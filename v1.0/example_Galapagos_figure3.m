% ----------------------------------------------------------------------- %
% ---------- This script produces Figure 3 from the manuscript: --------- %
% ----------------------------------------------------------------------- %
% ---------------------------------'TopoZeko: --------------------------- %
% ---------- A MATLAB function for 3-D and 4-D topographical ------------ %
% ------------------- visualisation in geosciences' --------------------  %
% -------------------- (Zekollari, Journal, Year) ----------------------- %
% ----------------------------------------------------------------------- %
% ------------- All functions, scripts and data related ----------------- %
% ---------------- to TopoZeko are available online: -------------------- %
% ------------------ github.com/zekollari/TopoZeko ---------------------- %
% ----------------------------------------------------------------------- %

close all
clear
clc

tic
load('example_data_Galapagos_100m.mat') % loads BED and SUR
disp(strcat('Time needed to load data:',num2str(toc),' seconds'))

tic
% ----------------------------------------------------------------------- %
% ------------------------ 3-D+ plots (Figure 3) ------------------------ %
% ----------------------------------------------------------------------- %

TopoZeko(BED,SUR...
    ,'bed_colormap','gray' ...
    ,'sur_color',[1 0 0] ...
    ,'vertical_scaling',0.7 ...
    ,'view_orientation',[0 80] ...
    ,'xlim',[0 1400] ...
    ,'ylim',[0 1400] ...
    );

disp(strcat('Time needed to produce the figure:',num2str(toc),' seconds'))