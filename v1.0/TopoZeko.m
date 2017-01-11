function TopoZeko(BED,SUR,varargin)
% TopoZeko is a matlab function developed to make 3-D and 4-D plots of
% surfaces with a pronounced topographical setting such as glaciers,
% volcanoes and lakes in mountaineous regions. It is strongly encouraged to
% use this code for your scientific publications, presentations, teaching
% material,...etc.
%
% --> Example 1: TopoZeko(BED,ELEV): generates a 3-D surface plot of the matrix
% 'ELEV'. Where 'BED' and 'ELEV' differ the surface elevation is displayed
% in a given color (standard: white)
%
% --> Example 2: TopoZeko(BED,ELEV,'extra_dimension','on'): generates a 3-D
% surface plot of the matrix 'ELEV'. Where 'BED' and 'ELEV' differ the
% local difference is displayed using a colorbar (standard: colormap 'jet')
%
% --> Example 3: TopoZeko(BED,ELEV,'extra_dimension',VEL): generates a 3-D
% surface plot of the matrix 'ELEV'. The colorbar is used to display the
% matrix 'VEL' (4th dimension)
%
% The visualization can be modified with up to 40 additional parameters
% when calling the function.
% For additional information, examples and reference consult:
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

p = inputParser;

% Function always need a 2-D field for BED (bedrock elevation) and SUR (surface elevation)

% List of optional parameters and default values:
% addParamValue --> addParameter (works from R2013b, recommened to use this if run with version after R2013b)
addParamValue(p,'axes','off');                   % Show the axes. Two options: 'on' and 'off'
addParamValue(p,'bed_colors',128);               % Number of colours for bedrock (integer, should at least be 1)
addParamValue(p,'bed_colormap','copper')         % MATLAB colormap (colour scheme) for the bedrock
addParamValue(p,'bed_colormap_flipud','on')      % Inverse the colormap (colour scheme) for the bedrock. Two options: 'on' and 'off'
addParamValue(p,'bed_trans',1);                  % Transparency of the bedrock. 0: fully transparent, 1: non-transparent
addParamValue(p,'caxis','');                     % Range of the colour bar.  Works only for 4-D plots: Will not have any effect for 3-D plot.
addParamValue(p,'cbar_colors',128);              % Number of colours for the 4th dimension. Works only for 4-D plots: Will not have any effect for 3-D plot
addParamValue(p,'cbar_position','northoutside'); % Position of the colorbar. Works only for 4-D plots: Will not have any effect for 3-D plot
addParamValue(p,'cbar_tick_format','');          % Format for the ticks on the colour bar.  Works only for 4-D plots: Will not have any effect for 3-D plot
addParamValue(p,'D2','off')                      % Make an additional 2-D plot of the 4th dimension (thickness/depth, extra variable)
addParamValue(p,'D4_colormap','jet')             % MATLAB colormap (colour scheme) for the 4th dimension. Works only for 4-D plots: Will not have any effect for 3-D plot
addParamValue(p,'D4_colormap_flipud','off')      % Inverse the colormap (colour scheme) for the 4th dimension. Works only for 4-D plots: Will not have any effect for 3-D plot
addParamValue(p,'extra_dimension','');           % Whether or not to plot a 4th dimension. When empty: 3-D plot; if 'on': 4-D plot of the thickness/depth field; if a variable is given: this one will be plotted as 4th dimension
addParamValue(p,'label_size','');                % Font size of all labels (on axes, colour bars, for x,y,z-labels and for title). When defined, all other optional label size parameters are neglected
addParamValue(p,'light_orientation',[-90 45]);   % Orientation of light source. First value is the azimuth (0=pointing at first row; 90=pointing at last column; 180=pointing at last row; 270=pointing at first column), second one is the height (given as an angle, as seen from the middle of the image)
addParamValue(p,'size_cm',[20 20]);              % Image size of the plot (in cm)
addParamValue(p,'size_pix','');                  % Image size of the plot (in pixels)
addParamValue(p,'sur_color',[1 1 1]);            % Colour of the ice/lava/lake/.. surface in 3-D plot
addParamValue(p,'sur_material','dull');          % Appearance of surface material. Three valid options 'dull', 'metal' and 'shiny'
addParamValue(p,'sur_trans',1);                  % Transparency of the surface. 0: fully transparent, 1: non-transparent
addParamValue(p,'tick','on');                    % Show ticks on the axes. Two options: 'on' and 'off'
addParamValue(p,'tick_size',18);                 % Font size of all axes and colour bars ticks
addParamValue(p,'title','');                     % Title of the figure
addParamValue(p,'title_size',22);                % Font size of the title
addParamValue(p,'vertical_scaling',1);           % Fraction of the z-axis that is used to depict the topography. Should be between 0 and 1
addParamValue(p,'view_orientation',[0 45]);      % Orientation of camera view point. First value is the azimuth (0=pointing at first row; 90=pointing at last column; 180=pointing at last row; 270=pointing at first column), second one is the height (given as an angle, as seen from the middle of the image)
addParamValue(p,'xlabel','');                    % Label on the x-axis
addParamValue(p,'xlabel_rotation',0);            % Rotation of the x-label
addParamValue(p,'xlabel_size',18);               % Font size of the x-label
addParamValue(p,'xlim','');                      % Range of the x-axis
addParamValue(p,'xvalues','');                   % First and last column x-values
addParamValue(p,'ylabel','');                    % Label on the y-axis
addParamValue(p,'ylabel_rotation',0);            % Rotation of the y-label
addParamValue(p,'ylabel_size',18);               % Font size of the y-label
addParamValue(p,'ylim','');                      % Range of the y-axis
addParamValue(p,'yvalues','');                   % First and last row y-values
addParamValue(p,'zlabel','');                    % Label on the z-axis
addParamValue(p,'zlabel_rotation',90);           % Rotation of the z-label
addParamValue(p,'zlabel_size',18);               % Font size of the z-label
addParamValue(p,'zlim','');                      % Range of the z-axis

parse(p,varargin{:});

% BED and SUR should have same size:
if size(BED)~=size(SUR)
    error('Error: dimensions of bedrock elevation matrix and surface elevation matrix do not agree')
end

if strcmp(p.Results.extra_dimension,'')==1 || strcmp(p.Results.extra_dimension,'on')==1 % The extra dimension results from the difference between the bedrock and the surface elevation
    THI=SUR-BED; % Thickness (ice thickness / lake depth /...) is obtained by subtracting the bedrock elevation from the surface elevation
else % The extra dimension is given when calling the function (e.g. surface velocity, thickness change,...)
    THI=p.Results.extra_dimension;
end

% If thickness is everywhere equal to NaN --> put it to zero everywhere:
i=find(isnan(THI)==0);
if length(i)==0
    THI(:,:)=0;
end

% Specify the 'Larger than' and 'Smaller than' flags (used for the 4-D plots)
larger_than_flag=0;
smaller_than_flag=0;

if strcmp(p.Results.extra_dimension,'')==1 || strcmp(p.Results.caxis,'')==1 || strcmp(p.Results.caxis,'off')==1 % if 3-D plot or no limits are given for the fourth dimension
    THI_MIN=min(min(THI));
    THI_MAX=max(max(THI));
elseif strcmp(p.Results.caxis,'')==0 % In case limits are given for the 4th dimension
    THI_MIN=p.Results.caxis(1);
    THI_MAX=p.Results.caxis(2);
    i=find(THI>THI_MAX);THI(i)=THI_MAX;
    if length(i)>0
        larger_than_flag=1; % Important for labelling later on
    end
    i=find(THI<THI_MIN);THI(i)=THI_MIN;
    if length(i)>0
        smaller_than_flag=1; % Important for labelling later on
    end
end

% Values used later on in calculations:
THI_DIF=THI_MAX-THI_MIN;
BED_MIN=min(min(BED));
BED_MAX=max(max(BED));

if strcmp(p.Results.extra_dimension,'')==1 || strcmp(p.Results.extra_dimension,'on')==1 % In the case of a 3-D plot: 3rd dimension (thickness/depth) cannot be smaller than 0 (bedrock cannot be higher than surface elevation)
    i=find(THI<0);
    if isempty(i)==0
        error('Error: bedrock elevation exceeds surface elevation')
    end
end
i=find(THI==0);THI(i)=NaN;
mask=nan(size(THI));i=find(THI>0);mask(i)=-Inf;

% Determine which rows/values have to be plotted:
a=size(BED);
if strcmp(p.Results.xvalues,'')==1
    x1=1;
    x2=a(2);
else
    x1=p.Results.xvalues(1);
    x2=p.Results.xvalues(2);
end
if strcmp(p.Results.yvalues,'')==1
    y1=1;
    y2=a(1);
else
    y1=p.Results.yvalues(1);
    y2=p.Results.yvalues(2);
end

% ----------------------------------------------------------------------- %
%  2-D plot of the 4th dimension (thickness/depth, additional variable)   %
% ----------------------------------------------------------------------- %
if strcmp(p.Results.D2,'on')==1
    figure;
    set(gcf,'Units','centimeters');
    set(gcf,'Position',[0 1 p.Results.size_cm]);
    if strcmp(p.Results.size_pix,'')==0
        set(gcf,'Units','pixels');
        set(gcf,'Position',[0 1 p.Results.size_pix]);
    end
    pcolor(THI(:,:)); shading flat; hold on;
    cb1=colorbar;
    caxis([THI_MIN THI_MAX]);
    set(get(cb1,'title'),'string',{'m'},'Fontsize',14,'FontWeight','Bold');
    [A3,ha3]=contour(THI(:,:),THI_MIN:round(THI_DIF/10):THI_MAX);
    set(ha3,'ShowText','on');
    set(ha3,'LineColor',[0 0 0],'LineWidth',0.8);
    hold off;
    set(gca,'FontSize',14)
    set(gcf,'Renderer','painters');
    title(p.Results.title,'Fontweight','Bold','FontSize',16);
    xlabel(p.Results.xlabel,'Fontweight','Bold','FontSize',14);
    ylabel(p.Results.ylabel,'Fontweight','Bold','FontSize',14);
end

figure1=figure;
axes1 = axes('Parent',figure1);
view(axes1,[p.Results.view_orientation]);
grid(axes1,'on');
hold(axes1,'all');
set(gcf,'Units','centimeters');
set(gcf,'Position',[0 1 p.Results.size_cm]);
if strcmp(p.Results.size_pix,'')==0
    set(gcf,'Units','pixels');
    set(gcf,'Position',[0 1 p.Results.size_pix]);
end

% ----------------------------------------------------------------------- %
% ---- 3-D plot (one color where surface and bedrock elevation differ)--- %
% ----------------------------------------------------------------------- %
if strcmp(p.Results.extra_dimension,'')==1
    h1=surf(x1:(x2-x1)/(a(2)-1):x2,y1:(y2-y1)/(a(1)-1):y2,BED); hold on; % Bedrock topography is plotted
    alpha(h1,p.Results.bed_trans); % Adapt bedrock transparency
    % Make artificial (concatenated) colormap:
    if strcmp(p.Results.bed_colormap_flipud,'off')==1
        colormap([p.Results.sur_color;eval(strcat(p.Results.bed_colormap,'(',num2str(p.Results.bed_colors),')'))]);
    elseif strcmp(p.Results.bed_colormap_flipud,'on')==1
        colormap([p.Results.sur_color;flipud(eval(strcat(p.Results.bed_colormap,'(',num2str(p.Results.bed_colors),')')))]);
    end
    caxis([BED_MIN-(1/p.Results.bed_colors)*(BED_MAX-BED_MIN) BED_MAX]);
    h2=surf(x1:(x2-x1)/(a(2)-1):x2,y1:(y2-y1)/(a(1)-1):y2,SUR,mask); hold on; % Plot surface topography (with colors as chosen with 'sur_color')
    alpha(h2,p.Results.sur_trans); % Adapt surface transparency 

    % z-lim:
    if strcmp(p.Results.zlim,'')==0 % zlim is given
        zlim([p.Results.zlim]);
    else % zlim not given
        if p.Results.vertical_scaling>0 && p.Results.vertical_scaling<=1
            zlim([BED_MIN BED_MIN+(max(max(SUR))-BED_MIN)/p.Results.vertical_scaling]);
        else
            error('Vertical scaling should be between 0 and 1')
        end
    end % end of 3-D plot

% ----------------------------------------------------------------------- %
% ---- 4-D plot (spatial variation in thickness/depth/4th dimension) ---- %
% ----------------------------------------------------------------------- %
elseif strcmp(p.Results.extra_dimension,'')==0
    h1=surf(x1:(x2-x1)/(a(2)-1):x2,y1:(y2-y1)/(a(1)-1):y2,p.Results.cbar_colors+((BED-BED_MIN)/(BED_MAX-BED_MIN))*p.Results.bed_colors); hold on; % Bedrock topography is plotted
    alpha(h1,p.Results.bed_trans); % Adapt bedrock transparency
    % Make artificial (concatenated) colormap:
    if strcmp(p.Results.D4_colormap_flipud,'off')==1 && strcmp(p.Results.bed_colormap_flipud,'off')==1
        colormap([eval(strcat(p.Results.D4_colormap,'(round(p.Results.cbar_colors))'));eval(strcat(p.Results.bed_colormap,'(',num2str(p.Results.bed_colors),')'))]);
    elseif strcmp(p.Results.D4_colormap_flipud,'on')==1 && strcmp(p.Results.bed_colormap_flipud,'off')==1
         colormap([flipud(eval(strcat(p.Results.D4_colormap,'(round(p.Results.cbar_colors))')));eval(strcat(p.Results.bed_colormap,'(',numstr(p.Results.bed_colors),')'))]);
    elseif strcmp(p.Results.D4_colormap_flipud,'off')==1 && strcmp(p.Results.bed_colormap_flipud,'on')==1
        colormap([eval(strcat(p.Results.D4_colormap,'(round(p.Results.cbar_colors))'));flipud(eval(strcat(p.Results.bed_colormap,'(',num2str(p.Results.bed_colors),')')))]);
    elseif strcmp(p.Results.D4_colormap_flipud,'on')==1 && strcmp(p.Results.bed_colormap_flipud,'on')==1
        colormap([flipud(eval(strcat(p.Results.D4_colormap,'(round(p.Results.cbar_colors))')));flipud(eval(strcat(p.Results.bed_colormap,'(',num2str(p.Results.bed_colors),')')))]);
    end
    caxis([0 p.Results.cbar_colors+p.Results.bed_colors]);
    h = colorbar; % Display the colorbar
    h2=surf(x1:(x2-x1)/(a(2)-1):x2,y1:(y2-y1)/(a(1)-1):y2,p.Results.cbar_colors+((SUR-BED_MIN)/(BED_MAX-BED_MIN))*p.Results.bed_colors,(THI-THI_MIN)/(THI_DIF)*p.Results.cbar_colors); hold on; % Plot surface topography (with colorbar as chosen with 'D4_colormap')
    alpha(h2,p.Results.sur_trans); % Adapt surface transparency
    set(h,'location',p.Results.cbar_position)
    
    orient=get(h,'xlim'); % Needed to determine orientation axes (for newer MATLAB versions, not needed: use TickLabels instead of XTickLabel/YTickLabel)
    if orient(2)==p.Results.bed_colors+p.Results.cbar_colors;
        set(h,'xlim',[0 p.Results.cbar_colors])
        set(h,'XTick',0:p.Results.cbar_colors/5:p.Results.cbar_colors)
    else
        set(h,'ylim',[0 p.Results.cbar_colors])
        set(h,'YTick',0:p.Results.cbar_colors/5:p.Results.cbar_colors)
    end
    if strcmp(p.Results.cbar_tick_format,'')==1 % Case where no format is given
        if THI_DIF>100 % If the range is larger than 100: round
            tick1=num2str(round(THI_MIN));
            tick2=num2str(round(THI_MIN+THI_DIF/5));
            tick3=num2str(round(THI_MIN+2*THI_DIF/5));
            tick4=num2str(round(THI_MIN+3*THI_DIF/5));
            tick5=num2str(round(THI_MIN+4*THI_DIF/5));
            tick6=num2str(round(THI_MIN+THI_DIF));
        else % If range is smaller than 100
        factor=1000*10^(-(floor(log(THI_DIF))));
        tick1=num2str(round(THI_MIN*factor)/factor,'%g');
        tick2=num2str(round((THI_MIN+THI_DIF/5)*factor)/factor,'%g');
        tick3=num2str(round((THI_MIN+2*THI_DIF/5)*factor)/factor,'%g');
        tick4=num2str(round((THI_MIN+3*THI_DIF/5)*factor)/factor,'%g');
        tick5=num2str(round((THI_MIN+4*THI_DIF/5)*factor)/factor,'%g');
        tick6=num2str(round((THI_MIN+THI_DIF)*factor)/factor,'%g');
        end
    else % if format is given:
        tick1=num2str((THI_MIN),p.Results.cbar_tick_format);
        tick2=num2str((THI_MIN+THI_DIF/5),p.Results.cbar_tick_format);
        tick3=num2str((THI_MIN+2*THI_DIF/5),p.Results.cbar_tick_format);
        tick4=num2str((THI_MIN+3*THI_DIF/5),p.Results.cbar_tick_format);
        tick5=num2str((THI_MIN+4*THI_DIF/5),p.Results.cbar_tick_format);
        tick6=num2str((THI_MIN+THI_DIF),p.Results.cbar_tick_format);
    end
    if smaller_than_flag==1 && larger_than_flag==1 % Adapt the labelling
        if orient(2)==p.Results.bed_colors+p.Results.cbar_colors;
            set(h,'XTickLabel',{strcat('<',tick1),tick2,tick3,tick4,tick5,strcat('>',tick6)});
        else
            set(h,'YTickLabel',{strcat('<',tick1),tick2,tick3,tick4,tick5,strcat('>',tick6)});
        end
    elseif smaller_than_flag==1
        if orient(2)==p.Results.bed_colors+p.Results.cbar_colors;
            set(h,'XTickLabel',{strcat('<',tick1),tick2,tick3,tick4,tick5,tick6});
        else
            set(h,'YTickLabel',{strcat('<',tick1),tick2,tick3,tick4,tick5,tick6});
        end
    elseif larger_than_flag==1
        if orient(2)==p.Results.bed_colors+p.Results.cbar_colors;
            set(h,'XTickLabel',{tick1,tick2,tick3,tick4,tick5,strcat('>',tick6)});
        else
            set(h,'YTickLabel',{strcat('<',tick1),tick2,tick3,tick4,tick5,tick6});
        end
    else
        if orient(2)==p.Results.bed_colors+p.Results.cbar_colors;
            set(h,'XTickLabel',{tick1,tick2,tick3,tick4,tick5,tick6});
        else
            set(h,'YTickLabel',{tick1,tick2,tick3,tick4,tick5,tick6});
        end
    end
    
    % z-lim:
    max_dif=max(max(SUR))-BED_MIN;
    if max(max(BED))-BED_MIN>max_dif
        max_dif=max(max(BED))-BED_MIN;
    end
    bed_dif=max(max(BED))-BED_MIN;
    if strcmp(p.Results.zlim,'')==0 % zlim is given
        z_min=p.Results.cbar_colors+((p.Results.zlim(1)-BED_MIN)/bed_dif)*p.Results.bed_colors
        z_max=p.Results.cbar_colors+((p.Results.zlim(2)-BED_MIN)/bed_dif)*p.Results.bed_colors
        zlim([z_min z_max]);
        tick_dif=z_max-z_min;
        ax=gca;
        ax.ZTick=[z_min z_min+0.2*tick_dif z_min+0.4*tick_dif z_min+0.6*tick_dif z_min+0.8*tick_dif z_max];
        ax.ZTickLabel={p.Results.zlim(1),p.Results.zlim(1)+0.2*(p.Results.zlim(2)-p.Results.zlim(1)),p.Results.zlim(1)+0.4*(p.Results.zlim(2)-p.Results.zlim(1)),p.Results.zlim(1)+0.6*(p.Results.zlim(2)-p.Results.zlim(1)),p.Results.zlim(1)+0.8*(p.Results.zlim(2)-p.Results.zlim(1)),p.Results.zlim(1)+(p.Results.zlim(2)-p.Results.zlim(1))};
    else % zlim not given
        if p.Results.vertical_scaling>0 && p.Results.vertical_scaling<=1
            z_min=p.Results.cbar_colors;
            z_max=p.Results.cbar_colors+((max_dif/bed_dif)*p.Results.bed_colors)/p.Results.vertical_scaling;
            zlim([z_min z_max]);
            tick_dif=z_max-z_min;
            ax=gca;
            ax.ZTick=[z_min z_min+0.2*tick_dif z_min+0.4*tick_dif z_min+0.6*tick_dif z_min+0.8*tick_dif z_max];
            ax.ZTickLabel={BED_MIN,BED_MIN+0.2*max_dif/p.Results.vertical_scaling,BED_MIN+0.4*max_dif/p.Results.vertical_scaling,BED_MIN+0.6*max_dif/p.Results.vertical_scaling,BED_MIN+0.8*max_dif/p.Results.vertical_scaling,BED_MIN+max_dif/p.Results.vertical_scaling};
        else
            error('Vertical scaling should be between 0 and 1')
        end
    end
end % end of 4-D plot

% ----------------------------------------------------------------------- %
% --------- General manipulations: valid for 3-D and 4-D plots ---------- %
% ----------------------------------------------------------------------- %
set(gca,'FontSize',p.Results.tick_size);
title(p.Results.title,'Fontweight','Bold','FontSize',p.Results.title_size);
xlabel(p.Results.xlabel,'Fontweight','Bold','FontSize',p.Results.xlabel_size);h=get(gca,'xlabel');set(h,'rotation',p.Results.xlabel_rotation)
ylabel(p.Results.ylabel,'Fontweight','Bold','FontSize',p.Results.ylabel_size);h=get(gca,'ylabel');set(h,'rotation',p.Results.ylabel_rotation)
zlabel(p.Results.zlabel,'Fontweight','Bold','FontSize',p.Results.zlabel_size);h=get(gca,'zlabel');set(h,'rotation',p.Results.zlabel_rotation)
h=light;
lightangle(h,p.Results.light_orientation(1),p.Results.light_orientation(2));
lighting flat; 
shading interp;
if strcmp(p.Results.sur_material,'dull')==1
    material dull;    
elseif strcmp(p.Results.sur_material,'shiny')==1
    material shiny;
elseif strcmp(p.Results.sur_material,'metal')==1
    material metal;
end
if strcmp(p.Results.label_size,'')==0
    set(gca,'FontSize',p.Results.label_size);
end
if strcmp(p.Results.xlim,'')==0
    xlim([p.Results.xlim]);
end
if strcmp(p.Results.ylim,'')==0
    ylim([p.Results.ylim]);
end

if strcmp(p.Results.tick,'off')==1
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'ZTickLabel',[]);
end
if strcmp(p.Results.axes,'off')==1
    axis off
end

end % end of topo_zeko