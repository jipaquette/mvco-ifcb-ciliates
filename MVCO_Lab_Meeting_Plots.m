%mvco plots for lab meeting

%%
%loading in data
%mvco cnn summary data
load('/Volumes/IFCB_products/MVCO/summary_v4/count_group_class.mat');
%mvco manual data
load('/Users/jillianpaquette/Desktop/WHOI Work/count_manual_current_jill_MVCO.mat');
%mvco env data
load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat');

%%
%change summary to timetable
count_mvco_ttable_full = table2timetable(classcount_opt_adhoc_merge,'rowtimes', meta_data.datetime);

%add ml_analyzed
count_mvco_ttable_full.ml_analyzed = meta_data.ml_analyzed;

%remove pid
count_mvco_ttable_full.pid = [];    

%remove imaginary samples
count_mvco_ttable_full(count_mvco_ttable_full.ml_analyzed < 0, :) = [];

%make daily bins and shift time to start of days
count_mvco_ttable = retime(count_mvco_ttable_full, 'daily', 'sum');     
count_mvco_ttable.Time = dateshift(count_mvco_ttable.Time, 'start', 'day');

%change env data to timetable
env_mvco_ttable = table2timetable(MVCO_Daily);

%combine summary and env data
count_env = synchronize(count_mvco_ttable, env_mvco_ttable, 'daily');

%repeat daily bins and shift time for env data
MVCO_Env_Table.time_local = dateshift(MVCO_Env_Table.time_local, 'start', 'day');
mvco_env_daily = retime(MVCO_Env_Table, 'daily', 'mean');
mvco_env_daily.time_local.TimeZone = char;
count_env = retime(count_env, 'daily', 'mean');

%recombine summary and env data to variable called count_env
count_env = synchronize(count_env, mvco_env_daily, 'daily');

%%
%choose transformation value
tr_val = 4;

%%
%mvco seasons
count_env.month = month(count_env.days);

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
%climatology
%climatology function
count_var2plot = count_env.(classlabel).^(1/tr_val)./count_env.ml_analyzed.^(1/tr_val);
count_mdate = datenum(count_env.days);
[ count_mdate_mat, count_y_mat, count_yearlist, count_yd ] = timeseries2ydmat( count_mdate, count_var2plot );

%create plot
figure
plot(count_yd, count_y_mat, '.')

%add graph details
%change from days of year to months
legend(num2str(count_yearlist'), 'Location', 'eastoutside')
ylim([0 inf])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14);
xlabel('Day of year', 'FontSize', 14)
xlim([0 366])

%%
%count vs. temp seasons as colors
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
%mvco boxplot count vs. temp tiled as seasons
figure
tiledlayout(2,2)
ticklabels = [0 2 4 6 8 10 12 14 16 18 20  22 24  26 28 30];
xticklabels = num2str(ticklabels');

%summer
nexttile
temp_su = count_env.Beam_temperature_corrected(mvco_summer_ind);
ciliate_bxp_su = count_env.(classlabel)(mvco_summer_ind).^(1/tr_val)./count_env.ml_analyzed(mvco_summer_ind).^(1/tr_val);
temp_bins_su = 0:2:30;
[temp_discrete_su, temp_e_su] = discretize(temp_su, temp_bins_su);
boxplot(ciliate_bxp_su, temp_discrete_su)
ylim([0 2])
set(gca, 'XTickLabel', xticklabels)
title('Summer')

%fall
nexttile
temp_f = count_env.Beam_temperature_corrected(mvco_fall_ind);
ciliate_bxp_f = count_env.(classlabel)(mvco_fall_ind).^(1/tr_val)./count_env.ml_analyzed(mvco_fall_ind).^(1/tr_val);
temp_bins_f = 0:2:30;
[temp_discrete_f, temp_e_f] = discretize(temp_f, temp_bins_f);
boxplot(ciliate_bxp_f, temp_discrete_f)
ylim([0 2])
set(gca, 'XTickLabel', xticklabels)
title('Fall')

%winter
nexttile
temp_w = count_env.Beam_temperature_corrected(mvco_winter_ind);
ciliate_bxp_w = count_env.(classlabel)(mvco_winter_ind).^(1/tr_val)./count_env.ml_analyzed(mvco_winter_ind).^(1/tr_val);
temp_bins_w = 0:2:30;
[temp_discrete_w, temp_e_w] = discretize(temp_w, temp_bins_w);
boxplot(ciliate_bxp_w, temp_discrete_w)
ylim([0 2])
set(gca, 'XTickLabel', xticklabels)
title('Winter')

%spring
nexttile
temp_sp = count_env.Beam_temperature_corrected(mvco_spring_ind);
ciliate_bxp_sp = count_env.(classlabel)(mvco_spring_ind).^(1/tr_val)./count_env.ml_analyzed(mvco_spring_ind).^(1/tr_val);
temp_bins_sp = 0:2:30;
[temp_discrete_sp, temp_e_sp] = discretize(temp_sp, temp_bins_sp);
boxplot(ciliate_bxp_sp, temp_discrete_sp)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
ylim([0 2])
xlabel('Temperature (°C)', 'FontSize', 14)
set(gca, 'XTickLabel', xticklabels)
title('Spring')
