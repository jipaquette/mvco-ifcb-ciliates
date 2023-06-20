%Combined MVCO and Cruise data to have subplots of seasonality graphs
%compared to each other

%%
%loading data
%MVCO data
cnn_mvco = readtable('/Users/jillianpaquette/Desktop/WHOI Work/count_by_class_time_series_CNN_daily_20220622.csv');
load("count_manual_current_jill_MVCO.mat")
load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat')

cnn_mvco_ttable = table2timetable(cnn_mvco);
env_mvco_ttable = table2timetable(MVCO_Daily);
cnn_mvco_ttable.datetime = dateshift(cnn_mvco_ttable.datetime, 'start', 'day');

cnn_env = synchronize(cnn_mvco_ttable, env_mvco_ttable, 'daily');

MVCO_Env_Table.time_local = dateshift(MVCO_Env_Table.time_local, 'start', 'day');
mvco_env_daily = retime(MVCO_Env_Table, 'daily', 'mean');
mvco_env_daily.time_local.TimeZone = char;
cnn_env = retime(cnn_env, 'daily', 'mean');
cnn_env = synchronize(cnn_env, mvco_env_daily, 'daily');

%%
%ciliate variable to change
%cases for CNN 
m_class2plot = "Laboea strobila";

switch m_class2plot
    case "Balanion"
        cnn_mvco_classlabel = "Balanion";
        class2use_label = "Balanion";
        ylim_max = 45;
    case "Ciliophora"
        cnn_mvco_classlabel = "Ciliophora";
        class2use_label = "Ciliophora";
        ylim_max = 80;
    case "Dictyocysta"
        cnn_mvco_classlabel = "Dictyocysta";
        class2use_label = "Dictyocysta";
        ylim_max = 0.3;
    case "Didinium"
        cnn_mvco_classlabel = "Didinium";
        class2use_label = "Didinium";
        ylim_max = 0.45;
    case "Euplotes"
        cnn_mvco_classlabel = "Euplotes";
        class2use_label = "Euplotes";
        ylim_max = 1.6;

        % error that vectors must be the same length
        % case "Euplotes morphotype 1"
        % cnn_mvco_classlabel = "Euplotes_morphotype1";
        % class2use_label = "Euplotes morphotype1"; % does not exist in class2use
        % ylim_max = 1;

    case "Eutintinnus"
        cnn_mvco_classlabel = "Eutintinnus";
        class2use_label = "Eutintinnus";
        ylim_max = 0.25;
    case "Favella"
        cnn_mvco_classlabel = "Favella";
        class2use_label = "Favella";
        ylim_max = 3;
    case "Laboea strobila"
        cnn_mvco_classlabel = "Laboea_strobila";
        class2use_label = "Laboea strobila";
        ylim_max = 3;
    case "Leegaardiella ovalis"
        cnn_mvco_classlabel = "Leegaardiella_ovalis";
        class2use_label = "Leegaardiella ovalis";
        ylim_max = 4;
    case "Mesodinium"
        cnn_mvco_classlabel = "Mesodinium";
        class2use_label = "Mesodinium";
        ylim_max = 20;
    case "Pleuronema"
        cnn_mvco_classlabel = "Pleuronema";
        class2use_label = "Pleuronema";
        ylim_max = 1;
    case "Stenosemella morphotype 1"
        cnn_mvco_classlabel = "Stenosemella_morphotype1";
        class2use_label = "Stenosemella morphotype1";
        ylim_max = 1.6;
    case "Stenosemella pacifica"
        cnn_mvco_classlabel = "Stenosemella_pacifica";
        class2use_label = "Stenosemella pacifica";
        ylim_max = 7;
    case "Pelagostrobilidium"
        cnn_mvco_classlabel = "Pelagostrobilidium";
        class2use_label = "Pelagotrobilidium";
        ylim_max = 1.4;
    case "Strombidium capitatum"
        cnn_mvco_classlabel = "Strombidium_capitatum";
        class2use_label = "Strombidium capitatum";
        ylim_max = 0.25;
    case "Strombidium conicum"
        cnn_mvco_classlabel = "Strombidium_conicum";
        class2use_label = "Strombidium conicum";
        ylim_max = 1;
    case "Strombidium inclinatum"
        cnn_mvco_classlabel = "Strombidium_inclinatum";
        class2use_label = "Strombidium inclinatum";
        ylim_max = 1.8;
    case "Strombidium morphotype 1"
        cnn_mvco_classlabel = "Strombidium_morphotype1";
        class2use_label = "Strombidium morphotype1";
        ylim_max = 8;
    case "Strombidium morphotype 2"
        cnn_mvco_classlabel = "Strombidium_morphotype2";
        class2use_label = "Strombidium morphotype2";
        ylim_max = 4.5;
    case "Strombidium tintinnodes"
        cnn_mvco_classlabel = "Strombidium_tintinnodes";
        class2use_label = "Strombidium tintinnodes";
        ylim_max = 6;
    case "Strombidium wulffi"
        cnn_mvco_classlabel = "Strombidium_wulffi";
        class2use_label = "Strombidium wulffi";
        ylim_max = 2.5;
    case "Tiarina fusus"
        cnn_mvco_classlabel = "Tiarina_fusus";
        class2use_label = "Tiarina fusus";
        ylim_max = 0.3;
    case "Tintinnina"
        cnn_mvco_classlabel = "Tintinnina";
        class2use_label = "Tintinnina";
        ylim_max = 12;
    case "Tintinnidium mucicola"
        cnn_mvco_classlabel = "Tintinnidium_mucicola";
        class2use_label = "Tintinnidium mucicola";
        ylim_max = 0.6;
    case "Tintinnopsis"
        cnn_mvco_classlabel = "Tintinnopsis";
        class2use_label = "Tintinnopsis";
        ylim_max = 35;
    case "Tontonia appendiculariformis"
        cnn_mvco_classlabel = "Tontonia_appendiculariformis";
        class2use_label = "Tontonia appendiculariformis";
        ylim_max = 3;
    case "Paratontonia gracillima"
        cnn_mvco_classlabel = "Paratontonia_gracillima";
        class2use_label = "Paratontonia gracillima";
        ylim_max = 9;
end

%%
%cruise data
%loading data
load('/Volumes/IFCB_products/NESLTER_transect/summary/carbon_group_class_withTS.mat')
load('count_manual_current_jill_NESLTER.mat')
uwindall = find(strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);

%%
%cases for cruiseStr
cruiseStr = 'AR34B';

switch cruiseStr
    case "AR34A"
        cruiseStr_label = "AR34A";
    case "AR34B"
        cruiseStr_label = "AR34B";
    case "AR66B"
        cruiseStr_label = "AR66B";
    case "EN644"
        cruiseStr_label = "EN644";
    case "EN687"
        cruiseStr_label = "EN687";
end

uwind = find(strcmp(meta_data.cruise, cruiseStr) & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);

%%
%cases for cruise
c_class2plot = "Laboea strobila";

switch c_class2plot
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
%tiled graphs between MVCO and cruise data

%%
%CNN graph over years
figure
%tiledlayout(1,2)

%MVCO
%nexttile
plot(cnn_env.datetime, cnn_env.(cnn_mvco_classlabel)./cnn_env.ml_analyzed)
datetick("keeplimits")
hold on
datetime_bin_m = datetime(matdate_bin_mvco, "ConvertFrom", "datenum");
class_ind_m = strcmp(class2use_label, class2use_mvco);
plot(datetime_bin_m, (classcount_bin_mvco(:,class_ind_m)./ml_analyzed_mat_bin_mvco(:,class_ind_m)), "r*")
ylim([0 ylim_max])
legend("CNN Auto Classifier", "Manual Annotations", "Location", "northoutside")
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
xlabel("Year", "FontSize", 14)
title("MVCO CNN Results compared to Manual Annotations")

%cruise
%nexttile
figure
plot(meta_data.datetime, classC_opt_adhoc_merge.(cruise_classlabel)./meta_data.ml_analyzed)
datetick("keeplimits")

%nexttile
figure
datetime_bin_c = datetime(matdate_cruise, "ConvertFrom", "datenum");
class_ind_c = strcmp(class2use_label, class2use_cruise);
plot(datetime_bin_c, (classcount_cruise(:,class_ind_c)./ml_analyzed_cruise(class_ind_c)), "r*")
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
xlabel("Year", "FontSize", 14)
title("Cruise CNN Results compared to Manual Annotations")

%%
%lines across as months
figure
tiledlayout(2,1)

%MVCO
nexttile
m_var2plot = cnn_mvco.(cnn_mvco_classlabel)./cnn_mvco.ml_analyzed;
m_mdate = datenum(cnn_mvco.datetime);
[ m_mdate_mat, m_y_mat, m_yearlist, m_yd ] = timeseries2ydmat( m_mdate, m_var2plot );
%subplot(2,1,1)
plot(m_yd, m_y_mat, ".-")
datetick
legend(num2str(m_yearlist'), "Location", "eastoutside")
%cruise
nexttile
c_var2plot = classC_opt_adhoc_merge.(cruise_classlabel)./meta_data.ml_analyzed;
c_mdate = datenum(meta_data.datetime);
[ c_mdate_mat, c_y_mat, c_yearlist, c_yd ] = timeseries2ydmat( c_mdate, c_var2plot );
%subplot(2,1,1)
plot(c_yd, c_y_mat, ".-")
datetick
legend(num2str(c_yearlist'), "Location", "eastoutside")

%%
%climatology
figure
tiledlayout(1,2)

%MVCO
nexttile
m_tr_val = 4;
[ m_xmean, m_xstd ] = smoothed_climatology( m_y_mat.^(1/m_tr_val) , 10);
plot(m_yd, m_y_mat, '.')
datetick
xlim([0 366])
legend(num2str(m_yearlist'), "Location", "eastoutside")
title("CNN seasonality")
%cruise
nexttile
c_tr_val = 4;
[ c_xmean, c_xstd ] = smoothed_climatology( c_y_mat.^(1/c_tr_val) , 10);
plot(c_yd, c_y_mat, '.')
datetick
xlim([0 366])
legend(num2str(c_yearlist'), "Location", "eastoutside")
title("Cruise seasonality")

%%
%environmental MVCO and cruise graphs
%%
%salinity and temp over time
figure
tiledlayout(1,2)

%mvco
nexttile
plot(cnn_env.datetime, cnn_env.Beam_temperature_corrected, '.')
hold on
plot(cnn_env.datetime, cnn_env.salinity_beam, '.')
title('MVCO')
ylim([-5 40])
%cruise
nexttile
plot(meta_data.datetime(uwindall), meta_data.temperature(uwindall), '.')
hold on
plot(meta_data.datetime(uwindall), meta_data.salinity(uwindall), '.')
title('Cruise')
ylim([-5 40])

%%
%beam temp/salinity versus ciliate count/carbon
figure
tiledlayout(2,2)

%mvco
%temp
nexttile
plot(cnn_env.Beam_temperature_corrected, cnn_env.(cnn_mvco_classlabel)./cnn_env.ml_analyzed, '.');
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
xlabel("Beam Temperature Corrected (°C)", "FontSize", 14)
title("MVCO Temperature")
%salinity
nexttile
plot(cnn_env.salinity_beam, cnn_env.(cnn_mvco_classlabel)./cnn_env.ml_analyzed, '.');
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
xlabel("Salinity (ppt)", "FontSize", 14)
title("MVCO Salinity")
%cruise
%temp
nexttile
plot(meta_data.temperature(uwindall), classC_opt_adhoc_merge.(cruise_classlabel)(uwindall), '.');
xlabel("Temperature (°C)", "FontSize", 14)
ylabel("Ciliate Carbon", "FontSize", 14)
title("Cruise Temp")
%salinity
nexttile
plot(meta_data.salinity(uwindall), classC_opt_adhoc_merge.(cruise_classlabel)(uwindall), '.');
xlabel("Temperature (°C)", "FontSize", 14)
ylabel("Ciliate Carbon", "FontSize", 14)
title("Cruise Salinity")

%%
%TS plot for MVCO
figure
Z_mvco = cnn_env.(cnn_mvco_classlabel)./cnn_env.ml_analyzed;
scatter(cnn_env.salinity_beam, cnn_env.Beam_temperature_corrected, 10, Z_mvco);
hold on
scatter(cnn_env.salinity_beam, cnn_env.Beam_temperature_corrected, 10, Z_mvco, 'filled');
colorbar
xlim([28 34])
set(gca,'ColorScale','log')

%%
%TS plot with Heidi
figure
Z_cruise = classC_opt_adhoc_merge.(cruise_classlabel)(uwind);
Zind_cruise = find(Z_cruise == 0);
scatter(meta_data.salinity(uwind(Zind_cruise)), meta_data.temperature(uwind(Zind_cruise)), 20, Z_cruise(Zind_cruise));
hold on
Zind_cruise = find(Z_cruise);
scatter(meta_data.salinity(uwind(Zind_cruise)), meta_data.temperature(uwind(Zind_cruise)), 20, Z_cruise(Zind_cruise), 'filled');
xlim([30 37])
colorbar
set(gca,'ColorScale','log')
%caxis([0 1e5])

%%

