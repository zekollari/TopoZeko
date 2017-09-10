% ----------------------------------------------------------------------- %
% ---------- This script produces Figure 1 from the manuscript: --------- %
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
load('example_data_Morteratsch_25m.mat'); % loads BED, SUR, SUR_LAKE and VEL
disp(strcat('Time needed to load data:',num2str(toc),' seconds'))

% Define glacier mask:
mask=zeros(size(SUR));
i=find(SUR~=BED);mask(i)=1;

% Figure 1 (2-D view):
figure;
set(gcf,'Units','centimeters');
set(gcf,'Position',[0 1 20 20]);
contourf(789:0.025:796,137.025:0.025:149,SUR,'LineColor',[.5 .5 .5]); hold on;
contour(789:0.025:796,137.025:0.025:149,mask,'LineColor','k','LineWidth',3)
contour(789:0.025:796,137.025:0.025:149,SUR-BED,0:50:350,'LineColor','k','ShowText','on'); hold on;
xlabel('CH1903 x-coordinate (km)','Fontweight','Bold','FontSize',14);
ylabel('CH1903 y-coordinate (km)','Fontweight','Bold','FontSize',14);
caxis([min(min(SUR)) max(max(SUR))])
colorbar
shading flat;
set(gca,'FontSize',16)
