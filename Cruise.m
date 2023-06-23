%Cruise data

%%
%loading in cruise data
load('/Volumes/IFCB_products/NESLTER_transect/summary/carbon_group_class_withTS.mat')

%%
%Specify which cruise
cruiseStr = 'EN687';

%%
%Create plot of all cruises, just looking at the ciliate group
%Looks at carbon as a function of biomass, separates larger ciliates
%compared to 100 smaller ones and their impact, dominance in C vs count
figure
plot(meta_data.datetime, groupC_opt.Ciliate./meta_data.ml_analyzed, '.-')
uwind = find(strcmp(meta_data.cruise, cruiseStr) & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);
uwindall = find(strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);

%%
%Create plot of specified cruise, just looking at the ciliate group still
figure
plot(meta_data.datetime(uwind), groupC_opt.Ciliate(uwind)./meta_data.ml_analyzed(uwind), '.-')
 
%%
%Tell me the optimal threshold score of x taxon
optthresh.Laboea_strobila

%%
%Over the days of the year, for all cruises, show me this particular
%class's seasonality
figure
plot(day(meta_data.datetime(uwindall), 'dayofyear'), classC_opt_adhoc_merge.Laboea_strobila(uwindall)./meta_data.ml_analyzed(uwindall), '.')
xlabel("Days of Year", "FontSize", 14)
ylabel("Carbon of Ciliate", "FontSize", 14)
% what is contributing to biomass and what is their seasonality
%nearshore and offshore - split by lat (& meta_data.latitude<40);

%%
%Create graph of lat vs temperature (underway), all cruises
figure
plot(meta_data.latitude(uwindall), meta_data.temperature(uwindall), '.')

%And holding on with salinity (underway)
hold on
plot(meta_data.latitude(uwindall), meta_data.salinity(uwindall), '.')
legend("Temperature (°C)", "Salinity (ppt)", "Location", "northoutside")
xlabel("Latitude", "FontSize", 14)
ylabel("Temperature and Salinity", "FontSize", 14)

%%
%Show me group Ciliate vs latitude
figure
plot(meta_data.latitude(uwindall), groupC_opt.Ciliate(uwindall), '.')
xlabel("Latitude", "FontSize", 14)
ylabel("Ciliate Carbon", "FontSize", 14)

%%
%Show me group Ciliate vs temperature
figure
plot(meta_data.temperature(uwindall), groupC_opt.Ciliate(uwindall), '.')
xlabel("Temperature (°C)", "FontSize", 14)
ylabel("Ciliate Carbon", "FontSize", 14)

%%
%Three previous figures in one tile and adding salinity
figure
tiledlayout(2,3)

%Top left plot
nexttile
plot(meta_data.latitude(uwindall), meta_data.temperature(uwindall), '.')
xlabel("Latitude", "FontSize", 14)
ylabel("Temperature (°C)", "FontSize", 14)
title('Lat vs Temp')

%Top middle plot
nexttile
plot(meta_data.latitude(uwindall), groupC_opt.Ciliate(uwindall), '.')
xlabel("Latitude", "FontSize", 14)
ylabel("Ciliate Carbon", "FontSize", 14)
title('Lat vs Ciliate C')

%Top right plot
nexttile
plot(meta_data.temperature(uwindall), groupC_opt.Ciliate(uwindall), '.')
xlabel("Temperature (°C)", "FontSize", 14)
ylabel("Ciliate Carbon", "FontSize", 14)
title('Temp vs Ciliate C')

%Bottom left plot
nexttile
plot(meta_data.latitude(uwindall), meta_data.salinity(uwindall), '.')
xlabel("Latitude", "FontSize", 14)
ylabel("Salinity (ppt)", "FontSize", 14)
title('Lat vs Salinity')

%Bottom middle plot
nexttile
plot(meta_data.latitude(uwindall), groupC_opt.Ciliate(uwindall), '.')
xlabel("Latitude", "FontSize", 14)
ylabel('Ciliate Carbon', "FontSize", 14)
title('Lat vs Ciliate C')

%Bottom right plot
nexttile
plot(meta_data.salinity(uwindall), groupC_opt.Ciliate(uwindall), '.')
xlabel("Salinity (ppt)", "FontSize", 14)
ylabel('Ciliate Carbon', "FontSize", 14)
title('Salinity vs Ciliate C')

%%
%Set up for cases plotting classes with classC_opt_adhoc_merge

class2plot = "Laboea strobila";

switch class2plot
    case "Balanion"
        cruise_classlabel = "Balanion";
        class2use_label = "Balanion";
    case "Dictyocysta"
        cruise_classlabel = "Dictyocysta";
        class2use_label = "Dictyocysta";
    case "Didinum"
        cruise_classlabel = "Didinum";
        class2use_label = "Didinum";
    case "Euplotes"
        cruise_classlabel = "Euplotes";
        class2use_label = "Euplotes";
    case "Euplotes morphotype 1"
        cruise_classlabel = "Euplotes_morphotype1";
        class2use_label = "Euplotes morphotype 1";
    case "Eutintinnus"
        cruise_classlabel = "Eutintinnus";
        class2use_label = "Eutintinnus";
    case "Favella"
        cruise_classlabel = "Favella";
        class2use_label = "Favella";
    case "Laboea strobila"
        cruise_classlabel = "Laboea_strobila";
        class2use_label = "Laboea strobila";
    case "Leegaardiella ovalis"
        cruise_classlabel = "Leegaardiella_ovalis";
        class2use_label = "Leegaardiella ovalis";
    case "Mesodinium"
        cruise_classlabel = "Mesodinium";
        class2use_label = "Mesodinium";
    case "Pleuronema"
        cruise_classlabel = "Pleuronema";
        class2use_label = "Pleuronema";
    case "Stenosemella morphotype 1"
        cruise_classlabel = "Stenosemella_morphotype1";
        class2use_label = "Stenosemella morphotype 1";
    case "Stenosemella pacifica"
        cruise_classlabel = "Stenosemella_pacifica";
        class2use_label = "Stenosemella pacifica";
    case "Strombidium capitatum"
        cruise_classlabel = "Strombidium_capitatum";
        class2use_label = "Strombidium capitatum";
    case "Strombidium conicum"
        cruise_classlabel = "Strombidium_conicum";
        class2use_label = "Strombidium conicum";
    case "Strombidium inclinatum"
        cruise_classlabel = "Strombidium_inclinatum";
        class2use_label = "Strombidium inclinatum";
    case "Strombidium morphotype 1"
        cruise_classlabel = "Strombidium_morphotype1";
        class2use_label = "Strombidium morphotype 1";
    case "Strombidium morphotype 2"
        cruise_classlabel = "Strombidium_morphotype2";
        class2use_label = "Strombidium morphotype 2";
    case "Strombidium tintinnodes"
        cruise_classlabel = "Strombidium_tintinnodes";
        class2use_label = "Strombidium tintinnodes";
    case "Strombidium wulffi"
        cruise_classlabel = "Strombidium_wulffi";
        class2use_label = "Strombidium wulffi";
    case "Tiarina fusus"
        cruise_classlabel = "Tiarina_fusus";
        class2use_label = "Tiarina fusus";
    case "Tintinnia"
        cruise_classlabel = "Tintinnia";
        class2use_label = "Tintinnia";
    case "Tintinnidium mucicola"
        cruise_classlabel = "Tintinnidium_mucicola";
        class2use_label = "Tintinnidium mucicola";
    case "Tintinnopsis"
        cruise_classlabel = "Tintinnopsis";
        class2use_label = "Tintinnopsis";
    case "Tontonia appendiculariformis"
        cruise_classlabel = "Tontonia_appendiculariformis";
        class2use_label = "Tontonia appendiculariformis";
    case "Paratontonia gracillima"
        cruise_classlabel = "Paratontonia_gracillima";
        class2use_label = "Paratontonia gracillima";
    case "Ciliophora"
        cruise_classlabel = "Ciliophora";
        class2use_label = "Ciliophora";
end

%%
%Same three tiled figure, but with cases implemented
figure
tiledlayout(2,3)

%Top left plot
nexttile
plot(meta_data.latitude(uwindall), meta_data.temperature(uwindall), '.')
xlabel("Latitude", "FontSize", 14)
ylabel("Temperature (°C)", "FontSize", 14)
title('Lat vs Temp')

%Top middle plot
nexttile
plot(meta_data.latitude(uwindall), classC_opt_adhoc_merge.(cruise_classlabel)(uwindall), '.')
xlabel("Latitude", "FontSize", 14)
ylabel(['\it' class2use_label '\rm (Carbon)'], "FontSize", 14)
title('Lat vs Ciliate C')

%Top right plot
nexttile
plot(meta_data.temperature(uwindall), classC_opt_adhoc_merge.(cruise_classlabel)(uwindall), '.')
xlabel("Temperature (°C)", "FontSize", 14)
ylabel(['\it' class2use_label '\rm (Carbon)'], "FontSize", 14)
title('Temp vs Ciliate C')

%Bottom left plot
nexttile
plot(meta_data.latitude(uwindall), meta_data.salinity(uwindall), '.')
xlabel("Latitude", "FontSize", 14)
ylabel("Salinity (ppt)", "FontSize", 14)
title('Lat vs Salinity')

%Bottom middle plot
nexttile
plot(meta_data.latitude(uwindall), classC_opt_adhoc_merge.(cruise_classlabel)(uwindall), '.')
xlabel("Latitude", "FontSize", 14)
ylabel(['\it' class2use_label '\rm (Carbon)'], "FontSize", 14)
title('Lat vs Ciliate C')

%Bottom right plot
nexttile
plot(meta_data.salinity(uwindall), classC_opt_adhoc_merge.(cruise_classlabel)(uwindall), '.')
xlabel("Salinity (ppt)", "FontSize", 14)
ylabel(['\it' class2use_label '\rm (Carbon)'], "FontSize", 14)
title('Salinity vs Ciliate C')


%%
%TS plot
figure
plot(meta_data.temperature(uwindall), meta_data.salinity(uwindall), '.')
title ('TS plot')

%%
%Recreating MVCO CNN graphs but for cruise data
%%
%CNN graph
figure
plot(meta_data.datetime, classC_opt_adhoc_merge.(cruise_classlabel)./meta_data.ml_analyzed)
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
xlabel("Year", "FontSize", 14)
title("CNN Cruise Results")

%%
%Create a figure of 2006-2022 as lines across months (seasonal changes)
c_var2plot = classC_opt_adhoc_merge.(cruise_classlabel)./meta_data.ml_analyzed;
c_mdate = datenum(meta_data.datetime);
[ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( c_mdate, c_var2plot );
% create the figure
figure
subplot(2,1,1)
plot(yd, y_mat, ".-")
datetick
legend(num2str(yearlist'), "Location", "eastoutside")
xlabel("Month", "FontSize", 14)
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14) % italicize and superscript

%%
%Smoothed climatology
c_tr_val = 4;
[ xmean, xstd ] = smoothed_climatology( y_mat.^(1/c_tr_val) , 10);
figure
plot(yd, y_mat, '.')
%hold on % create mean and SD lines
%plot(yd, xmean.^tr_val, 'k-','linewidth', 3)
%plot(yd, (xmean+xstd).^tr_val, 'k--', 'linewidth', 2)
%plot(yd, (xmean-xstd).^tr_val, 'k--', 'linewidth', 2)
%ylim([0 4])
xlim([0 366])
ylabel(['\it' char(class2use_label) '\rm (ml^{-1})'], 'fontsize', 14)
xlabel('Month', 'fontsize', 14)
datetick
legend(num2str(yearlist'), "Location", "eastoutside")
title("Cruise seasonality")

