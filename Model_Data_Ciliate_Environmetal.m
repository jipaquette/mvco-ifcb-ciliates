%No longer relevant, refer to CNN_Case_Seasonality_Env.m
%Model script to copy and paste for environmental-ciliate research

%%
cnn_mvco = readtable('/Users/jillianpaquette/Desktop/WHOI Work/count_by_class_time_series_CNN_daily_20220622.csv');
load("count_manual_current_day.mat");
%manually load in MVCO_Environmental_Tables.mat
load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat')

%%
cnn_mvco_classlabel = "Laboea_strobila";
class2use_label = "Laboea strobila";
ylim_max = 3;

%%
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
%Ciliate conc and beam temp
figure
plot(cnn_env.Beam_temperature_corrected, cnn_env.Laboea_strobila./cnn_env.ml_analyzed, '.');
ylim([0 ylim_max])
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
xlabel("Beam Temperature Corrected (°C)", "FontSize", 14)
title("Concentration of Ciliate Taxon with Beam Temperature Corrected")
%transform laboea

%%
%create figure for ciliate conc and salinity
figure
plot(cnn_env.salinity_beam, cnn_env.(cnn_mvco_classlabel)./cnn_env.ml_analyzed, '.');
ylim([0 ylim_max])
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
xlabel("Salinity (ppt)", "FontSize", 14)
title("Concentration of Ciliate Taxon with Salinity Beam")

%%
%CNN and manual data graph
%Divide by ml_analyzed to get exact counts
figure
plot(cnn_mvco.datetime, cnn_mvco.(cnn_mvco_classlabel)./cnn_mvco.ml_analyzed)

%%
datetick("keeplimits")
hold on
datetime_bin = datetime(matdate_bin, "ConvertFrom", "datenum")
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

%%
%Viewing beam_temperature_corrected spread
figure
plot(MVCO_Daily.days, MVCO_Daily.Beam_temperature_corrected, '.-')
legend("Beam Temperature Corrected", "Location", "northoutside")
ylabel('Temperature (°C)', "FontSize", 14)
xlabel("Year", "FontSize", 14)
title("Beam Temperature over Years")

%%
%Beam_temperature_corrected vs ciliate taxon
figure
plot(MVCO_Daily.days, MVCO_Daily.Beam_temperature_corrected, '.-')
yyaxis right
plot(cnn_mvco.datetime, (cnn_mvco.(cnn_mvco_classlabel)./cnn_mvco.ml_analyzed).^(1/tr_val))
legend("Beam Temperature Corrected", "Ciliate Count", "Location", "northoutside")
ylabel('Ciliate Count', "FontSize", 14)
yyaxis left
ylabel('Temperature (°C)')
xlabel("Year", "FontSize", 14)
title("Beam Temperature Corrected & Ciliate Count over Years")


figure
histogram(cnn_mvco.(cnn_mvco_classlabel)./(cnn_mvco.ml_analyzed).^(1/tr_val))
histogram(cnn_mvco.(cnn_mvco_classlabel)./(cnn_mvco.ml_analyzed).^(1/tr_val), 0:1:100)

%%
%Viewing salinity_beam spread
figure
plot(MVCO_Env_Table.time_local, MVCO_Env_Table.salinity_beam, '.-')
legend("Salinity Beam ", "Location", "northoutside")
ylabel('Salinity (ppt)', "FontSize", 14)
xlabel("Year", "FontSize", 14)
title("Salinity over Years")

%%
%Salinity vs ciliate taxon
%figure
%plot(MVCO_Env_Table.time_local, MVCO_Env_Table.salinity_beam, '.-')
%yyaxis right
%plot(cnn_mvco.datetime, cnn_mvco.(cnn_mvco_classlabel)./cnn_mvco.ml_analyzed)
%legend("Salinity", "Ciliate Count", "Location", "northoutside")
%ylabel('Ciliate Count', "FontSize", 14)
%yyaxis left
%ylabel('Salinity (ppt)')
%xlabel("Year", "FontSize", 14)
%title("Salinity & Ciliate Count over Years")
