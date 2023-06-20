%imported MVCO_Env_Tables.m from sosiknas1
%imported count_by_class_time_series_CNN_daily_20220622.csv for daily_data
%(CNN data)
%loading count_manual_current_day.mat
%Laboea strobila only in this practice

%%
daily_data = readtable('/Users/jillianpaquette/Desktop/WHOI Work/count_by_class_time_series_CNN_daily_20220622.csv');
load("count_manual_current_day.mat")

%%
daily_data_classlabel = "Laboea_strobila";
class2use_label = "Laboea strobila";
ylim_max = 3;

%%
daily_data_ttable = table2timetable(daily_data);
MVCO_daily_ttable = table2timetable(MVCO_Daily);
daily_data_ttable.datetime = dateshift(daily_data_ttable.datetime, 'start', 'day');

merged_table = synchronize(daily_data_ttable, MVCO_daily_ttable, 'daily');

%%
figure
plot(merged_table.Beam_temperature_corrected, merged_table.Laboea_strobila./merged_table.ml_analyzed, '.');
%transform laboea

%%
%CNN and manual data graph
%Divide by ml_analyzed to get exact counts
figure
plot(daily_data.datetime, daily_data.(daily_data_classlabel)./daily_data.ml_analyzed)

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
%Viewing beam_temperature_corrected spread
figure
plot(MVCO_Daily.days, MVCO_Daily.Beam_temperature_corrected, '.-')
legend("Beam Temperature Corrected", "Location", "northoutside")
ylabel('Temperature (°C)', "FontSize", 14)
xlabel("Year", "FontSize", 14)
title("Beam Temperature over Years")

yyaxis right
plot(daily_data.datetime, daily_data.(daily_data_classlabel)./daily_data.ml_analyzed)

%%
%Viewing salinity_beam spread
figure
plot(MVCO_Env_Table.time_local, MVCO_Env_Table.salinity_beam, '.-')
legend("Salinity Beam", "Location", "northoutside")
ylabel('Salinity (ppt)', "FontSize", 14)
xlabel("Local Time and Year", "FontSize", 14)
title("Salinity over Years")

%%
%Practice with double y-axis graph
figure
x = linspace(0,25);
y = sin(x/2);
yyaxis left
plot(x,y);
r = x.^2/2;
yyaxis right
plot(x,r);
yyaxis left
title('Plots with Different y-Scales')
xlabel('Values from 0 to 25')
ylabel('Left Side')
yyaxis right
ylabel('Right Side')

%%
%Overlaying those two graphs together (just CNN results) with hold on
figure
plot(daily_data.datetime, daily_data.(daily_data_classlabel)./daily_data.ml_analyzed)
hold on
plot(MVCO_Daily.days, MVCO_Daily.Beam_temperature_corrected, '.-')


