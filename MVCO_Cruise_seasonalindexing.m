%seasonal indexing, combined mvco and cruise data
%count only

%%
%loading in data
%cruise data
cruise = load('/Volumes/IFCB_products/NESLTER_transect/summary/count_group_class_withTS.mat');
%mvco data
mvco = load('/Volumes/IFCB_products/MVCO/summary_v4/count_group_class.mat');
%mvco env data
mvco_env = load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat');

%%
%mvco data adjustment
%change summary to timetable
count_mvco_ttable_full = table2timetable(mvco.classcount_opt_adhoc_merge,'rowtimes', mvco.meta_data.datetime);

%add ml_analyzed
count_mvco_ttable_full.ml_analyzed = mvco.meta_data.ml_analyzed;

%remove pid
count_mvco_ttable_full.pid = [];    

%remove imaginary samples
count_mvco_ttable_full(count_mvco_ttable_full.ml_analyzed < 0, :) = [];

%make daily bins and shift time to start of days
count_mvco_ttable = retime(count_mvco_ttable_full, 'daily', 'sum');     
count_mvco_ttable.Time = dateshift(count_mvco_ttable.Time, 'start', 'day');

%change env data to timetable
env_mvco_ttable = table2timetable(mvco_env.MVCO_Daily);

%combine summary and env data
count_env = synchronize(count_mvco_ttable, env_mvco_ttable, 'daily');

%repeat daily bins and shift time for env data
mvco_env.MVCO_Env_Table.time_local = dateshift(mvco_env.MVCO_Env_Table.time_local, 'start', 'day');
mvco_env_daily = retime(mvco_env.MVCO_Env_Table, 'daily', 'mean');
mvco_env_daily.time_local.TimeZone = char;
count_env = retime(count_env, 'daily', 'mean');

%recombine summary and env data to variable called count_env
count_env = synchronize(count_env, mvco_env_daily, 'daily');

%%
%adjust meta_data and count_env to add month column
cruise.meta_data.month = month(cruise.meta_data.datetime);
count_env.month = month(count_env.days);

%%
%indexing seasons for both mvco and cruise

%mvco seasons: specified months
mvco_summer_ind = find(count_env.month == 6 ...
    | count_env.month == 7 ...
    | count_env.month == 8);
mvco_fall_ind = find(count_env.month == 9 ...
    | count_env.month == 10 ...
    | count_env.month == 11);
mvco_winter_ind = find(count_env.month == 12 ...
    | count_env.month == 1 ...
    | count_env.month == 2);
mvco_spring_ind = find(count_env.month == 3 ...
    | count_env.month == 4 ...
    | count_env.month == 5);

%cruise seasons: specified months and underway, underway_discrete, and
%surface casts
cruise_summer_ind = find((cruise.meta_data.month == 6 ...
    | cruise.meta_data.month == 7 ...
    | cruise.meta_data.month == 8) ...
    & (~cruise.meta_data.skip & cruise.meta_data.depth < 10) ...
    & (cruise.meta_data.sample_type == 'underway' ...
    | cruise.meta_data.sample_type == 'underway_discrete' ...
    | cruise.meta_data.sample_type == 'cast'));
cruise_fall_ind = find((cruise.meta_data.month == 9 ...
    | cruise.meta_data.month == 10 ...
    | cruise.meta_data.month == 11) ...
    & (~cruise.meta_data.skip & cruise.meta_data.depth < 10) ...
    & (cruise.meta_data.sample_type == 'underway' ...
    | cruise.meta_data.sample_type == 'underway_discrete' ...
    | cruise.meta_data.sample_type == 'cast'));
cruise_winter_ind = find((cruise.meta_data.month == 12 ...
    | cruise.meta_data.month == 1 ...
    | cruise.meta_data.month == 2) ...
    & (~cruise.meta_data.skip & cruise.meta_data.depth < 10) ...
    & (cruise.meta_data.sample_type == 'underway' ...
    | cruise.meta_data.sample_type == 'underway_discrete' ...
    | cruise.meta_data.sample_type == 'cast'));
cruise_spring_ind = find((cruise.meta_data.month == 3 ...
    | cruise.meta_data.month == 4 ...
    | cruise.meta_data.month == 5) ...
    & (~cruise.meta_data.skip & cruise.meta_data.depth < 10) ...
    & (cruise.meta_data.sample_type == 'underway' ...
    | cruise.meta_data.sample_type == 'underway_discrete' ...
    | cruise.meta_data.sample_type == 'cast'));

%%
%choose transformation value
tr_val = 4;

%%
%ciliate taxon to change
class2plot = 'Mesodinium';

switch class2plot
    case 'Balanion'
        classlabel = 'Balanion';
        class2use_label = 'Balanion';
    case 'Ciliophora'
        classlabel = 'Ciliophora';
        class2use_label = 'Ciliophora';
    case 'Dictyocysta'
        classlabel = 'Dictyocysta';
        class2use_label = 'Dictyocysta';
    case 'Didinium'
        classlabel = 'Didinium';
        class2use_label = 'Didinium';
    case 'Euplotes'
        classlabel = 'Euplotes';
        class2use_label = 'Euplotes';
    case 'Euplotes morphotype 1'
        classlabel = 'Euplotes_morphotype1';
        class2use_label = 'Euplotes morphotype1';
    case 'Eutintinnus'
        classlabel = 'Eutintinnus';
        class2use_label = 'Eutintinnus';
    case 'Favella'
        classlabel = 'Favella';
        class2use_label = 'Favella';
    case 'Laboea strobila'
        classlabel = 'Laboea_strobila';
        class2use_label = 'Laboea strobila';
    case 'Leegaardiella ovalis'
        classlabel = 'Leegaardiella_ovalis';
        class2use_label = 'Leegaardiella ovalis';
    case 'Mesodinium'
        classlabel = 'Mesodinium';
        class2use_label = 'Mesodinium';
    case 'Pleuronema'
        classlabel = 'Pleuronema';
        class2use_label = 'Pleuronema';
    case 'Stenosemella morphotype 1'
        classlabel = 'Stenosemella_morphotype1';
        class2use_label = 'Stenosemella morphotype1';
    case 'Stenosemella pacifica'
        classlabel = "Stenosemella_pacifica";
        class2use_label = "Stenosemella pacifica";
    case 'Pelagostrobilidium'
        classlabel = 'Pelagostrobilidium';
        class2use_label = 'Pelagotrobilidium';
    case 'Strombidium capitatum'
        classlabel = 'Strombidium_capitatum';
        class2use_label = 'Strombidium capitatum';
    case 'Strombidium conicum'
        classlabel = 'Strombidium_conicum';
        class2use_label = 'Strombidium conicum';
    case 'Strombidium inclinatum'
        classlabel = 'Strombidium_inclinatum';
        class2use_label = 'Strombidium inclinatum';
    case 'Strombidium morphotype 1'
        classlabel = 'Strombidium_morphotype1';
        class2use_label = 'Strombidium morphotype1';
    case 'Strombidium morphotype 2'
        classlabel = 'Strombidium_morphotype2';
        class2use_label = 'Strombidium morphotype2';
    case 'Strombidium tintinnodes'
        classlabel = 'Strombidium_tintinnodes';
        class2use_label = 'Strombidium tintinnodes';
    case 'Strombidium wulffi'
        classlabel = 'Strombidium_wulffi';
        class2use_label = 'Strombidium wulffi';
    case 'Tiarina fusus'
        classlabel = 'Tiarina_fusus';
        class2use_label = 'Tiarina fusus';
    case 'Tintinnina'
        classlabel = 'Tintinnina';
        class2use_label = 'Tintinnina';
    case 'Tintinnidium mucicola'
        classlabel = 'Tintinnidium_mucicola';
        class2use_label = 'Tintinnidium mucicola';
    case 'Tintinnopsis'
        classlabel = 'Tintinnopsis';
        class2use_label = 'Tintinnopsis';
    case 'Tontonia appendiculariformis'
        classlabel = 'Tontonia_appendiculariformis';
        class2use_label = 'Tontonia appendiculariformis';
    case 'Paratontonia gracillima'
        classlabel = 'Paratontonia_gracillima';
        class2use_label = 'Paratontonia gracillima';
end

%%
%creating graph of temperature and cnn with seasons as colors mvco
figure

%fall
plot(count_env.Beam_temperature_corrected(mvco_fall_ind), ...
    count_env.(classlabel)(mvco_fall_ind).^(1/tr_val)./count_env.ml_analyzed(mvco_fall_ind).^(1/tr_val), ...
    'o', 'Color', [0.8500 0.3250 0.0980])
%winter
hold on
plot(count_env.Beam_temperature_corrected(mvco_winter_ind), ...
    count_env.(classlabel)(mvco_winter_ind).^(1/tr_val)./count_env.ml_analyzed(mvco_winter_ind).^(1/tr_val), ...
    '*', 'Color', [0 0.4470 0.7410])
%spring
hold on
plot(count_env.Beam_temperature_corrected(mvco_spring_ind), ...
    count_env.(classlabel)(mvco_spring_ind).^(1/tr_val)./count_env.ml_analyzed(mvco_spring_ind).^(1/tr_val), ...
    '+', 'Color', [0.4660 0.6740 0.1880])
%summer
hold on
plot(count_env.Beam_temperature_corrected(mvco_summer_ind), ...
    count_env.(classlabel)(mvco_summer_ind).^(1/tr_val)./count_env.ml_analyzed(mvco_summer_ind).^(1/tr_val), ...
    '.', 'Color', [0.9290 0.6940 0.1250])

%adding graph details
xlabel('Beam Temperature Corrected (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
legend('Fall', 'Winter', 'Spring', 'Summer')

%%
%same graph, tiled version
figure
tiledlayout(2,2)

%fall
nexttile
plot(count_env.Beam_temperature_corrected(mvco_fall_ind), ...
    count_env.(classlabel)(mvco_fall_ind)./count_env.ml_analyzed(mvco_fall_ind), ...
    'o', 'Color', [0.8500 0.3250 0.0980])
xlabel('Beam Temperature Corrected (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Fall')
%winter
nexttile
plot(count_env.Beam_temperature_corrected(mvco_winter_ind), ...
    count_env.(classlabel)(mvco_winter_ind)./count_env.ml_analyzed(mvco_winter_ind), ...
    '*', 'Color', [0 0.4470 0.7410])
xlabel('Beam Temperature Corrected (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Winter')
%spring
nexttile
plot(count_env.Beam_temperature_corrected(mvco_spring_ind), ...
    count_env.(classlabel)(mvco_spring_ind)./count_env.ml_analyzed(mvco_spring_ind), ...
    '+', 'Color', [0.4660 0.6740 0.1880])
xlabel('Beam Temperature Corrected (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Spring')
%summer
nexttile
plot(count_env.Beam_temperature_corrected(mvco_summer_ind), ...
    count_env.(classlabel)(mvco_summer_ind)./count_env.ml_analyzed(mvco_summer_ind), ...
    '.', 'Color', [0.9290 0.6940 0.1250])
xlabel('Beam Temperature Corrected (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Summer')


%%
%temperature and cnn with seasons as colors cruise
figure

%fall
plot(cruise.meta_data.temperature(cruise_fall_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind).^(1/tr_val)./cruise.meta_data.ml_analyzed(cruise_fall_ind).^(1/tr_val), ...
    'o', 'Color', [0.8500 0.3250 0.0980])
%winter
hold on
plot(cruise.meta_data.temperature(cruise_winter_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind).^(1/tr_val)./cruise.meta_data.ml_analyzed(cruise_winter_ind).^(1/tr_val), ...
    '*', 'Color', [0 0.4470 0.7410])
%spring
hold on
plot(cruise.meta_data.temperature(cruise_spring_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind).^(1/tr_val)./cruise.meta_data.ml_analyzed(cruise_spring_ind).^(1/tr_val), ...
    '+', 'Color', [0.4660 0.6740 0.1880])
%summer
hold on
plot(cruise.meta_data.temperature(cruise_summer_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind).^(1/tr_val)./cruise.meta_data.ml_analyzed(cruise_summer_ind).^(1/tr_val), ...
    '.', 'Color', [0.9290 0.6940 0.1250])

%adding graph details
xlabel('Temperature (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
legend('Fall', 'Winter', 'Spring', 'Summer')

%%
%same graph, tiled version
figure
tiledlayout(2,2)

%cruise summer
nexttile
plot(cruise.meta_data.temperature(cruise_summer_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind)./cruise.meta_data.ml_analyzed(cruise_summer_ind), ...
    '.', 'Color', [0.9290 0.6940 0.1250])
xlabel('Temperature (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Summer')
%cruise fall
nexttile
plot(cruise.meta_data.temperature(cruise_fall_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind)./cruise.meta_data.ml_analyzed(cruise_fall_ind), ...
    'o', 'Color', [0.8500 0.3250 0.0980])
xlabel('Temperature (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Fall')
%cruise winter
nexttile
plot(cruise.meta_data.temperature(cruise_winter_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind)./cruise.meta_data.ml_analyzed(cruise_winter_ind), ...
    '*', 'Color', [0 0.4470 0.7410])
xlabel('Temperature (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Winter')
%cruise spring
nexttile
plot(cruise.meta_data.temperature(cruise_spring_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind)./cruise.meta_data.ml_analyzed(cruise_spring_ind), ...
    '+', 'Color', [0.4660 0.6740 0.1880])
xlabel('Temperature (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Spring')

%%
%temperature and cnn with seasons as colors cruise AND mvco
figure

%mvco summer
plot(count_env.Beam_temperature_corrected(mvco_summer_ind), ...
    count_env.(classlabel)(mvco_summer_ind)./count_env.ml_analyzed(mvco_summer_ind), ...
    '.', 'Color', [0.4 0.4 0.4])
%mvco fall
hold on
plot(count_env.Beam_temperature_corrected(mvco_fall_ind), ...
    count_env.(classlabel)(mvco_fall_ind)./count_env.ml_analyzed(mvco_fall_ind), ...
    'o', 'Color', [0.4 0.4 0.4])
%mvco winter
hold on
plot(count_env.Beam_temperature_corrected(mvco_winter_ind), ...
    count_env.(classlabel)(mvco_winter_ind)./count_env.ml_analyzed(mvco_winter_ind), ...
    '*', 'Color', [0.4 0.4 0.4])
%mvco spring
hold on
plot(count_env.Beam_temperature_corrected(mvco_spring_ind), ...
    count_env.(classlabel)(mvco_spring_ind)./count_env.ml_analyzed(mvco_spring_ind), ...
    '+', 'Color', [0.4 0.4 0.4])

%adding cruise
hold on

%cruise summer
plot(cruise.meta_data.temperature(cruise_summer_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind)./cruise.meta_data.ml_analyzed(cruise_summer_ind), ...
    '.', 'Color', [0.9290 0.6940 0.1250])
%cruise fall
plot(cruise.meta_data.temperature(cruise_fall_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind)./cruise.meta_data.ml_analyzed(cruise_fall_ind), ...
    'o', 'Color', [0.8500 0.3250 0.0980])
%cruise winter
hold on
plot(cruise.meta_data.temperature(cruise_winter_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind)./cruise.meta_data.ml_analyzed(cruise_winter_ind), ...
    '*', 'Color', [0 0.4470 0.7410])
%cruise spring
hold on
plot(cruise.meta_data.temperature(cruise_spring_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind)./cruise.meta_data.ml_analyzed(cruise_spring_ind), ...
    '+', 'Color', [0.4660 0.6740 0.1880])

%adding graph details
xlabel('Temperature (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
legend('MVCO Summer', 'MVCO Fall', 'MVCO Winter', 'MVCO Spring', ...
    'Cruise Summer', 'Cruise Fall', 'Cruise Winter', 'Cruise Spring')

%%
%time and cnn with seasons as colors cruise AND mvco not seasons
figure

%mvco
plot(count_env.days, count_env.(classlabel)./count_env.ml_analyzed, ...
    '.', 'Color', [0.4 0.4 0.4])

%adding cruise
hold on

%cruise summer
plot(cruise.meta_data.datetime(cruise_summer_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind)./cruise.meta_data.ml_analyzed(cruise_summer_ind), ...
    '.', 'Color', [0.9290 0.6940 0.1250])
%cruise fall
plot(cruise.meta_data.datetime(cruise_fall_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind)./cruise.meta_data.ml_analyzed(cruise_fall_ind), ...
    'o', 'Color', [0.8500 0.3250 0.0980])
%cruise winter
hold on
plot(cruise.meta_data.datetime(cruise_winter_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind)./cruise.meta_data.ml_analyzed(cruise_winter_ind), ...
    '*', 'Color', [0 0.4470 0.7410])
%cruise spring
hold on
plot(cruise.meta_data.datetime(cruise_spring_ind), ...
    cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind)./cruise.meta_data.ml_analyzed(cruise_spring_ind), ...
    '+', 'Color', [0.4660 0.6740 0.1880])

%adding graph details
xlabel('Year', 'FontSize', 14)
    %not sure how to xlim the mvco days to just where cruise data is or to
    %days of the year like in bethany's graph
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
legend('MVCO','Cruise Summer', 'Cruise Fall', 'Cruise Winter', 'Cruise Spring')

%%
%boxplot of counts binned by seasons over all cruise data
seasons = [cruise_fall_ind; cruise_spring_ind; cruise_summer_ind; cruise_winter_ind];
boxplot(seasons)