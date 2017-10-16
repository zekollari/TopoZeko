% ----------------------------------------------------------------------- %
% ---------- This script produces video 3 from the manuscript: ---------- %
% ----------------------------------------------------------------------- %
% ------------------------------ 'TopoZeko: ----------------------------- %
% --------- A MATLAB function for 3-D and 4-D topographical ------------- %
% ------------------ visualisation in geosciences' ---------------------- %
% ------------------ (Zekollari, SoftwareX, 2017) ----------------------- %
% ----------------------------------------------------------------------- %
% ------------- All functions, scripts and data related ----------------- %
% ---------------- to TopoZeko are available online: -------------------- %
% ------------------ github.com/zekollari/TopoZeko ---------------------- %
% ----------------------------------------------------------------------- %

close all
clear
clc

load('example_data_Galapagos_100m.mat') % loads BED and SUR

% Create folder (if it does not exist):
mkdir('video_output_Galapagos');

% Details location
Decl=23; % Summer Solstice
Lat=-0.5;
start_time=6+1/15;
end_time=18-1/15;
intervals=178;

% Details for the video:

writerObj             = VideoWriter(['video_output_Galapagos/video3_Galapagos_shadow_decl',num2str(Decl)],'Motion JPEG AVI'); % Archival','Grayscale AVI','Indexed AVI','Motion JPEG 2000','Motion JPEG AVI' (default),'Uncompressed AVI'
writerObj.FrameRate   = 24;    
writerObj.Quality     = 100;
open(writerObj);

counter=0;
time_step=(end_time-start_time)/intervals;
for i=start_time:time_step:end_time
    counter=counter+1;
    LHA(counter)=-180+(i/24)*360; % It is assumed that e=0 (Culmination sun at 12 o'clock local time)
    [h(counter),a(counter)]=SunZeko(Decl,Lat,LHA(counter));
    
    if h(counter)<0 % If sun is under the horizon: no light
        h_plot=-90;
    else
        h_plot=h(counter);
    end
    a_plot=a(counter);
    
    hour=floor(i)
    if hour<10
        hour_plot=strcat('0',num2str(hour));
    else
        hour_plot=num2str(hour);
    end
    minute=round((i-floor(i))*60)
    if minute<10
        minute_plot=strcat('0',int2str(minute));
    else
        minute_plot=int2str(minute);
    end
    
    TopoZeko(BED,SUR...
    ,'light_orientation',[a_plot h_plot] ...
    ,'sur_color',[1 0.35 0.35] ...
    ,'title',[hour_plot,':',minute_plot,' (Declination of sun: ',num2str(Decl),'°)'] ...
    ,'vertical_scaling',0.5 ...
    ,'view_orientation',[0 70] ...
    );

    
    set(gcf,'PaperPositionMode','auto')  % Need this to have correct aspect ratio in saved figure
    print(gcf,'-r300',strcat('./video_output_Galapagos/','/sun_decl',num2str(Decl),'_',hour_plot,minute_plot,'.png'),'-dpng');
    frame=getframe(gcf);
    writeVideo(writerObj,frame);
    close
end
close(writerObj)


figure;
plot(LHA,h,'LineWidth',2,'LineStyle','--'); hold on;
plot(LHA,a,'LineWidth',2,'LineStyle','--'); hold on;