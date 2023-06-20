%MVCO Environmental Plotting

%%
cnn_mvco = readtable('/Users/jillianpaquette/Desktop/WHOI Work/count_by_class_time_series_CNN_daily_20220622.csv');
load("count_manual_current_day.mat");
load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat')

%Change to sync timetables
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
%Making a TS plot
figure
plot(cnn_env.Beam_temperature_corrected, cnn_env.salinity_beam, '.')
xlabel("Temperature (°C)", "FontSize", 14)
ylabel("Salinity (ppt)", "FontSize", 14)
title("TS Plot")

%%
%Just salinity
figure
plot(cnn_env.datetime, cnn_env.salinity_beam, '.')
xlabel("Years", "FontSize", 14)
ylabel("Salinity (ppt)", "FontSize", 14)
title("Salinity over Years")
ylim([28 33])

%%
%Just beam temp
figure
plot(cnn_env.datetime, cnn_env.Beam_temperature_corrected, '.')
xlabel("Years", "FontSize", 14)
ylabel("Temperature (°C)", "FontSize", 14)
title("Temperature over Years")

