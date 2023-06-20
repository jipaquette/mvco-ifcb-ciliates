%CNN Case Seasonality with Environmental Plotting

%%
%load in CNN data
cnn_mvco = readtable('/Users/jillianpaquette/Desktop/WHOI Work/count_by_class_time_series_CNN_daily_20220622.csv');
load("count_manual_current_day.mat")

%%
%load in MVCO_Environmental_Tables from sosiknas1
load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat')

%%
%change to timetables
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
%Ciliate variable to change %THIS WILL HAVE TO CHANGE WITH UPDATED THRESH
class2plot = "Laboea strobila";

switch class2plot
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
        class2use_label = "Pelagostrobilidium";
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
    case "Cryptophyta"
        cnn_mvco_classlabel = "Cryptophyta";
        class2use_label = "Cryptophyta";
        ylim_max = 1000;
end

%%
%create figure for ciliate conc and temp
figure
plot(cnn_env.Beam_temperature_corrected, cnn_env.(cnn_mvco_classlabel)./cnn_env.ml_analyzed, '.');
ylim([0 ylim_max])
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
xlabel("Beam Temperature Corrected (°C)", "FontSize", 14)
title("Concentration of Ciliate Taxon with Beam Temperature Corrected")

%%
%Beam_temperature_corrected vs ciliate taxon double y axis
tr_val = 4;
figure
plot(cnn_env.datetime, cnn_env.Beam_temperature_corrected, '.-')
yyaxis right
plot(cnn_mvco.datetime, (cnn_mvco.(cnn_mvco_classlabel)./cnn_mvco.ml_analyzed).^(1/tr_val), '.')
legend("Beam Temperature Corrected", "Ciliate Count", "Location", "northoutside")
ylabel('Ciliate Count', "FontSize", 14)
yyaxis left
ylabel('Temperature (°C)')
xlabel("Year", "FontSize", 14)
title("Beam Temperature Corrected & Ciliate Count over Years")

%%
%create figure for ciliate conc and salinity
figure
plot(cnn_env.salinity_beam, cnn_env.(cnn_mvco_classlabel)./cnn_env.ml_analyzed, '.');
ylim([0 ylim_max])
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
xlabel("Salinity (ppt)", "FontSize", 14)
title("Concentration of Ciliate Taxon with Salinity Beam")

%%
%Salinity beam vs ciliate taxon double y axis
tr_val = 4;
figure
plot(cnn_env.datetime, cnn_env.salinity_beam, '.-')
yyaxis right
plot(cnn_mvco.datetime, (cnn_mvco.(cnn_mvco_classlabel)./cnn_mvco.ml_analyzed).^(1/tr_val))
legend("Salinity", "Ciliate Count", "Location", "northoutside")
ylabel('Ciliate Count', "FontSize", 14)
yyaxis left
ylabel('Salinity (ppt)')
xlabel("Year", "FontSize", 14)
title("Salinity & Ciliate Count over Years")

%%
%CNN and manual data graph
%Divide by ml_analyzed to get exact counts
figure
plot(cnn_mvco.datetime, cnn_mvco.(cnn_mvco_classlabel)./cnn_mvco.ml_analyzed)

%%
datetick("keeplimits")
hold on
datetime_bin = datetime(matdate_bin, "ConvertFrom", "datenum");
class_ind = strcmp(class2use_label, class2use);
plot(datetime_bin, (classcount_bin(:,class_ind)./ml_analyzed_mat_bin(:,class_ind)), "r*")
ylim([0 ylim_max])
legend("CNN Auto Classifier", "Manual Annotations", "Location", "northoutside")
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
xlabel("Year", "FontSize", 14)
title("CNN Results compared to Manual Annotations")

%%
%Create a figure of 2006-2022 as lines across months (seasonal changes)
var2plot = cnn_mvco.(cnn_mvco_classlabel)./cnn_mvco.ml_analyzed;
mdate = datenum(cnn_mvco.datetime);
[ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
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
tr_val = 4;
[ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val) , 10);
figure
plot(yd, y_mat, '.')
hold on % create mean and SD lines
plot(yd, xmean.^tr_val, 'k-','linewidth', 3)
plot(yd, (xmean+xstd).^tr_val, 'k--', 'linewidth', 2)
plot(yd, (xmean-xstd).^tr_val, 'k--', 'linewidth', 2)
ylim([0 4])
xlim([0 366])
ylabel(['\it' char(class2use_label) '\rm (ml^{-1})'], 'fontsize', 14)
xlabel('Month', 'fontsize', 14)
datetick
legend(num2str(yearlist'), "Location", "eastoutside")
title("CNN seasonality")
