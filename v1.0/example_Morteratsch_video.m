% ----------------------------------------------------------------------- %
% -------- This script produces video 1 & 2 from the manuscript: -------- %
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

close all
clear
clc

load('example_data_Morteratsch_25m.mat'); % loads BED, SUR and VEL
size_matrix=size(BED);
THI=SUR-BED;

% Create folder (if it does not exist):
mkdir('video_output_Morteratsch');

% Details for the video:
    
% 3-D video:
writerObj3d             = VideoWriter('video_output_Morteratsch/video1_glacier_retreat_3d+','Motion JPEG AVI'); % Archival','Grayscale AVI','Indexed AVI','Motion JPEG 2000','Motion JPEG AVI' (default),'Uncompressed AVI'
writerObj3d.FrameRate   = 10; 
writerObj3d.Quality     = 100;
open(writerObj3d);

% 4-D video:
writerObj4d             = VideoWriter('video_output_Morteratsch/video2_glacier_retreat_4d','Motion JPEG AVI'); % Archival','Grayscale AVI','Indexed AVI','Motion JPEG 2000','Motion JPEG AVI' (default),'Uncompressed AVI'
writerObj4d.FrameRate   = 10; 
writerObj4d.Quality     = 100;
open(writerObj4d);


t_begin=0;
t_end=99;

for t=t_begin:t_end
    year=2001+t
    DHDT=nan(size(BED)); % DHDT= ice thickness change
    ELA=3000+t*6;        % ELA increases with 6 m/a (ca. +4°C over 100 years, asuming an annual lapse rate of 0.007°C/km)

    for i=1:size_matrix(1)
        for j=1:size_matrix(2)
            if THI(i,j)>0
                if SUR(i,j)<ELA
                    DHDT(i,j)=(SUR(i,j)-ELA)*0.005-0.1;
                else
                    DHDT(i,j)=-0.1;
                end
                THI(i,j)=THI(i,j)+DHDT(i,j);
                if THI(i,j)<0
                    THI(i,j)=0;
                end
                SUR=BED+THI;
            end
        end
    end

    % 3D+:
    TopoZeko(BED,SUR ...
        ,'D4_colormap_flipud','on' ...
        ,'title',['Glacier geometry in ',num2str(year)] ...
        ,'view_orientation',[-159.5 40] ...
        );
    % Picture is also saved (can make simulation by time-lapsing):
    set(gcf,'PaperPositionMode','auto')  % Need this to have correct aspect ratio in saved figure
    print(gcf,'-r300',strcat('./video_output_Morteratsch/','/3D+_year',num2str(year),'.png'),'-dpng');
    frame=getframe(gcf);
    writeVideo(writerObj3d,frame);
    close;
    
    
    % 4D:
    TopoZeko(BED,SUR ...
        ,'caxis',[-6 0] ...
        ,'D4_colormap_flipud','on' ...
        ,'extra_dimension',DHDT ...
        ,'title',['Ice thickness change (m a^{-1}) in ',num2str(year)] ...
        ,'view_orientation',[-159.5 40] ...
        );
    % Picture is also saved (can make simulation by time-lapsing):
    set(gcf,'PaperPositionMode','auto')  % Need this to have correct aspect ratio in saved figure
    print(gcf,'-r300',strcat('./video_output_Morteratsch/','/4D_year',num2str(year),'.png'),'-dpng');
    frame=getframe(gcf);
    writeVideo(writerObj4d,frame);
    close;
end

close(writerObj3d)
close(writerObj4d)