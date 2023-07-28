%mvco env data and ciliate conc
%count data only

%%
%loading in data
%cnn summary data
load('/Volumes/IFCB_products/MVCO/summary_v4/count_group_class.mat')
%manual data
load('/Users/jillianpaquette/Desktop/WHOI Work/count_manual_current_jill_MVCO.mat')
%env data
load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat')

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
m_class2plot = 'Mesodinium';

switch m_class2plot
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
%salinity and temperature over time
figure
%days and temperature
yyaxis left
plot(count_env.days, count_env.Beam_temperature_corrected, '.')
ylabel('Beam Temperature Corrected (°C)', 'FontSize', 14)
%days and salinity
yyaxis right
plot(count_env.days, count_env.salinity_beam, '.')
ylabel('Salinity Beam (ppt)', 'FontSize', 14)
xlabel('Year', 'FontSize', 14)
ylim([28 34])

%%
%temperature and ciliate count
figure
plot(count_env.Beam_temperature_corrected, count_env.(classlabel)./count_env.ml_analyzed, '.');

%add graph details
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Beam Temperature Corrected (°C)', 'FontSize', 14)
ylim([0 inf])

%%
%salinity and ciliate count
figure
plot(count_env.salinity_beam, count_env.(classlabel)./count_env.ml_analyzed, '.');

%add graph details
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Salinity Beam (ppt)', 'FontSize', 14)
ylim([0 inf])

%%
%temperature-salinity (TS) plot with ciliate concentration colored by bar

%create variable for ciliate
Z_count_mvco = count_env.(classlabel)./count_env.ml_analyzed;
Z_ind_mvco = find(Z_count_mvco == 0);

%salinity and temperature scatter with empty '.' for 0 counts
scatter(count_env.salinity_beam(Z_ind_mvco), count_env.Beam_temperature_corrected(Z_ind_mvco), 10, Z_count_mvco(Z_ind_mvco));

%add filled '.' for non-zero counts
Z_ind_mvco = find(Z_count_mvco);
hold on
scatter(count_env.salinity_beam(Z_ind_mvco), count_env.Beam_temperature_corrected(Z_ind_mvco), 10, Z_count_mvco(Z_ind_mvco), 'filled');

%add graph details
colorbar
xlim([28 34])
set(gca,'ColorScale','log')
xlabel('Salinity Beam (ppt)')
ylabel('Beam Temperature Corrected (°C)')
title(['\it' class2use_label '\rm Count (ml^{-1})'])

%%
%boxplot for ciliate conc binned into temperatures

%create variables for the boxplot
temp_m = count_env.Beam_temperature_corrected;
ciliate_bxp_m = (count_env.(classlabel)./count_env.ml_analyzed);

%create bins from 0 to 22 with step 2 in between
temp_bins = 0:2:30;

%discretize temperatures to bin them
[temp_discrete_m, temp_e_m] = discretize(temp_m, temp_bins);

%add bin labels
%labels = 

%create the boxplot
figure
boxplot(ciliate_bxp_m, temp_discrete_m)

%add graph details
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Beam Temperature Corrected (°C)', 'FontSize', 14)
set(gca, 'XTickLabel', [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30])

%%
%same graph, tiled version for seasons
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
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
ylim([0 2])
xlabel('Temperature (°C)', 'FontSize', 14)
set(gca, 'XTickLabel', xticklabels)
title('Summer')

%fall
nexttile
temp_f = count_env.Beam_temperature_corrected(mvco_fall_ind);
ciliate_bxp_f = count_env.(classlabel)(mvco_fall_ind).^(1/tr_val)./count_env.ml_analyzed(mvco_fall_ind).^(1/tr_val);
temp_bins_f = 0:2:30;
[temp_discrete_f, temp_e_f] = discretize(temp_f, temp_bins_f);
boxplot(ciliate_bxp_f, temp_discrete_f)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
ylim([0 2])
xlabel('Temperature (°C)', 'FontSize', 14)
set(gca, 'XTickLabel', xticklabels)
title('Fall')

%winter
nexttile
temp_w = count_env.Beam_temperature_corrected(mvco_winter_ind);
ciliate_bxp_w = count_env.(classlabel)(mvco_winter_ind).^(1/tr_val)./count_env.ml_analyzed(mvco_winter_ind).^(1/tr_val);
temp_bins_w = 0:2:30;
[temp_discrete_w, temp_e_w] = discretize(temp_w, temp_bins_w);
boxplot(ciliate_bxp_w, temp_discrete_w)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
ylim([0 2])
xlabel('Temperature (°C)', 'FontSize', 14)
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

%%
%boxplot for ciliate conc binned into salinities

%create variables for the boxplot
salinity_m = count_env.salinity_beam;
ciliate_bxp_m = (count_env.(classlabel)./count_env.ml_analyzed);

%create bins from 28 to 34 with step 1 in between
salinity_bins = 28:1:34;

%discretize temperatures to bin them
[salinity_discrete_m, salinity_e_m] = discretize(salinity_m, salinity_bins);

%add bin labels
%labels = 

%create the boxplot
figure
boxplot(ciliate_bxp_m, salinity_discrete_m)

%add graph details
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Salinity Beam (ppt)', 'FontSize', 14)
set(gca, 'XTickLabel', [28 29 30 31 32 33 34])
