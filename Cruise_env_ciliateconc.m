%cruise env data and ciliate conc
%count data only

%%
%loading in data
%cnn summary data and env data
load('/Volumes/IFCB_products/NESLTER_transect/summary/count_group_class_withTS.mat')

%%
%choose transformation value
tr_val = 4;

%%
%creating indices for uwind, uwindall, underway_discrete, and depth < 10 & cast

%switch cases for different cruises (annotated only)
cruiseStr = 'AR34B';

switch cruiseStr
    case 'AR34A'
        cruiseStr_label = 'AR34A';
    case 'AR34B'
        cruiseStr_label = 'AR34B';
    case 'AR66B'
        cruiseStr_label = 'AR66B';
    case 'EN644'
        cruiseStr_label = 'EN644';
    case 'EN687'
        cruiseStr_label = 'EN687';
    case 'EN627'
        cruiseStr_label = 'EN627';
    case 'AT46'
        cruiseStr_label = 'AT46';
    case 'AR39B'
        cruiseStr_label = 'AR39B';
end

%underways
single_cruise = find(strcmp(meta_data.cruise, cruiseStr) ...
    & (meta_data.sample_type == 'underway' ...
     | meta_data.sample_type == 'underway_discrete' ...
     | meta_data.depth < 10 & meta_data.sample_type == 'cast'...
     & meta_data.skip));
underway_all = find(strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);
underway_discrete = find(strcmp(meta_data.sample_type, 'underway_discrete') & ~meta_data.skip);

%surface casts
scast = find(meta_data.depth < 10 & meta_data.sample_type == 'cast' & ~meta_data.skip);

%creating combined inds
all_underway_types = [underway_all; underway_discrete];
all_used_sample_types = [underway_all; underway_discrete; scast];

%switch cases for different cruise sample types
sampleind2use = 'underway all';

switch sampleind2use
    case 'underway'
        ind_specified = single_cruise;
        ind_label = 'Sample Type: Single Cruise Underway';
    case 'underway all'
        ind_specified = underway_all;
        ind_label = 'Sample Type: All Cruise Underway';
    case 'underway discrete'
        ind_specified = underway_discrete;
        ind_label = 'Sample Type: Underway Discrete';
    case 'surface cast'
        ind_specified = scast;
        ind_label = 'Sample Type: Casts < 10 m Depth';
    case 'all'
        ind_specified = all_used_sample_types;
        ind_label = 'Sample Types: Underway, Underway Discrete, and Surface Casts';
    case 'all underway types'
        ind_specified = all_underway_types;
        ind_label = 'Sample Types: Underway and Underway Discrete';
end

%shelf regions
%indexing latitudes for cruise: underway, underway_discrete, 
%and surface casts
cruise_innershelf_ind = find((meta_data.latitude >= 40.98 ...
    & ~meta_data.skip & meta_data.depth < 10) ...
    & (meta_data.sample_type == 'underway' ...
    | meta_data.sample_type == 'underway_discrete' ...
    | meta_data.sample_type == 'cast'));
cruise_midshelf_ind = find((meta_data.latitude >= 40.327 & meta_data.latitude <= 40.98 ...
    & ~meta_data.skip & meta_data.depth < 10) ...
    & (meta_data.sample_type == 'underway' ...
    | meta_data.sample_type == 'underway_discrete' ...
    | meta_data.sample_type == 'cast'));
cruise_outershelf_ind = find((meta_data.latitude >= 39.923 & meta_data.latitude <= 40.327 ...
    & ~meta_data.skip & meta_data.depth < 10) ...
    & (meta_data.sample_type == 'underway' ...
    | meta_data.sample_type == 'underway_discrete' ...
    | meta_data.sample_type == 'cast'));
cruise_upperslope_ind = find((meta_data.latitude <= 39.923 ...
    & ~meta_data.skip & meta_data.depth < 10) ...
    & (meta_data.sample_type == 'underway' ...
    | meta_data.sample_type == 'underway_discrete' ...
    | meta_data.sample_type == 'cast'));

%seasons
meta_data.month = month(meta_data.datetime);
%cruise seasons: specified months and underway, underway_discrete, and
%surface casts
cruise_summer_ind = find((meta_data.month == 6 ...
    | meta_data.month == 7 ...
    | meta_data.month == 8) ...
    & (~meta_data.skip & meta_data.depth < 10) ...
    & (meta_data.sample_type == 'underway' ...
    | meta_data.sample_type == 'underway_discrete' ...
    | meta_data.sample_type == 'cast'));
cruise_fall_ind = find((meta_data.month == 9 ...
    | meta_data.month == 10 ...
    | meta_data.month == 11) ...
    & (~meta_data.skip & meta_data.depth < 10) ...
    & (meta_data.sample_type == 'underway' ...
    | meta_data.sample_type == 'underway_discrete' ...
    | meta_data.sample_type == 'cast'));
cruise_winter_ind = find((meta_data.month == 12 ...
    | meta_data.month == 1 ...
    | meta_data.month == 2) ...
    & (~meta_data.skip & meta_data.depth < 10) ...
    & (meta_data.sample_type == 'underway' ...
    | meta_data.sample_type == 'underway_discrete' ...
    | meta_data.sample_type == 'cast'));
cruise_spring_ind = find((meta_data.month == 3 ...
    | meta_data.month == 4 ...
    | meta_data.month == 5) ...
    & (~meta_data.skip & meta_data.depth < 10) ...
    & (meta_data.sample_type == 'underway' ...
    | meta_data.sample_type == 'underway_discrete' ...
    | meta_data.sample_type == 'cast'));

%%
class2plot = 'Laboea strobila';

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
%salinity and temperature over time
figure
%datetime and temperature
yyaxis left
plot(meta_data.datetime, meta_data.temperature, '.')
ylabel('Temperature (°C)', 'FontSize', 14)
%datetime and salinity
yyaxis right
plot(meta_data.datetime, meta_data.salinity, '.')
ylabel('Salinity (ppt)', 'FontSize', 14)
ylim([30 38])
xlabel('Year', 'FontSize', 14)

%%
%temperature and ciliate count
figure
plot(meta_data.temperature, classcount_opt_adhoc_merge.(classlabel)./meta_data.ml_analyzed, '.')

%add graph details
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Temperature (°C)', 'FontSize', 14)
ylim([0 inf])

%%
%salinity and ciliate count
figure
plot(meta_data.salinity, classcount_opt_adhoc_merge.(classlabel)./meta_data.ml_analyzed, '.')

%add graph details
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Salinity (ppt)', 'FontSize', 14)
ylim([0 inf])
xlim([30 37])

%%
%temperature-salinity (TS) plot with ciliate concentration colored by bar
figure

%create variable for ciliate
Z_count_cruise = classcount_opt_adhoc_merge.(classlabel)(single_cruise)./meta_data.ml_analyzed(single_cruise);
Z_ind_cruise = find(Z_count_cruise == 0);

%salinity and temperature scatter with empty '.' for 0 counts
scatter(meta_data.salinity(single_cruise(Z_ind_cruise)), meta_data.temperature(single_cruise(Z_ind_cruise)), 20, Z_count_cruise(Z_ind_cruise));

%add filled '.' for non-zero counts
hold on
Z_ind_cruise = find(Z_count_cruise);
scatter(meta_data.salinity(single_cruise(Z_ind_cruise)), meta_data.temperature(single_cruise(Z_ind_cruise)), 20, Z_count_cruise(Z_ind_cruise), 'filled');

%add graph details
xlim([30 37])
colorbar
set(gca, 'ColorScale', 'log')
xlabel('Salinity (ppt)', 'FontSize', 14)
ylabel('Temperature (°C)', 'FontSize', 14)
title(['\it' class2use_label '\rm Count (ml^{-1})'])
caxis([0 10])

%%
%TS plot for all cruises
Z_count_allcruises = classcount_opt_adhoc_merge.(classlabel)./meta_data.ml_analyzed;
Z_ind_allcruises = find(Z_count_allcruises == 0);
scatter(meta_data.salinity(Z_ind_allcruises), meta_data.temperature(Z_ind_allcruises), 20, Z_count_allcruises(Z_ind_allcruises));
hold on
Z_ind_allcruises = find(Z_count_allcruises);
scatter(meta_data.salinity(Z_ind_allcruises), meta_data.temperature(Z_ind_allcruises), 20, Z_count_allcruises(Z_ind_allcruises));
colorbar
set(gca, 'ColorScale', 'log')
xlabel('Salinity (ppt)', 'FontSize', 14)
ylabel('Temperature (°C)', 'FontSize', 14)
title(['\it' class2use_label '\rm Count (ml^{-1})'])
caxis([0 10])

%%
%TS plot for shelf regions with ciliate concentration
figure
tiledlayout(2,2)

%inner
nexttile
Z_count_shelf_i = classcount_opt_adhoc_merge.(classlabel)(cruise_innershelf_ind)./meta_data.ml_analyzed(cruise_innershelf_ind);
Z_ind_shelf_i = find(Z_count_shelf_i == 0);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_i)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_i)), 20, Z_count_shelf_i(Z_ind_shelf_i));
hold on
Z_ind_shelf_i = find(Z_count_shelf_i);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_i)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_i)), 20, Z_count_shelf_i(Z_ind_shelf_i));
colorbar
set(gca, 'ColorScale', 'log')
xlabel('Salinity (ppt)', 'FontSize', 14)
ylabel('Temperature (°C)', 'FontSize', 14)
title(['\it' class2use_label '\rm Counts Inner Shelf (ml^{-1})'])
caxis([0 10])
%mid
nexttile
Z_count_shelf_m = classcount_opt_adhoc_merge.(classlabel)(cruise_midshelf_ind)./meta_data.ml_analyzed(cruise_midshelf_ind);
Z_ind_shelf_m = find(Z_count_shelf_m == 0);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_m)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_m)), 20, Z_count_shelf_m(Z_ind_shelf_m));
hold on
Z_ind_shelf_m = find(Z_count_shelf_m);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_m)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_m)), 20, Z_count_shelf_m(Z_ind_shelf_m));
colorbar
set(gca, 'ColorScale', 'log')
xlabel('Salinity (ppt)', 'FontSize', 14)
ylabel('Temperature (°C)', 'FontSize', 14)
title(['\it' class2use_label '\rm Counts Mid Shelf (ml^{-1})'])
caxis([0 10])
%outer
nexttile
Z_count_shelf_o = classcount_opt_adhoc_merge.(classlabel)(cruise_outershelf_ind)./meta_data.ml_analyzed(cruise_outershelf_ind);
Z_ind_shelf_o = find(Z_count_shelf_o == 0);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_o)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_o)), 20, Z_count_shelf_o(Z_ind_shelf_o));
hold on
Z_ind_shelf_o = find(Z_count_shelf_o);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_o)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_o)), 20, Z_count_shelf_o(Z_ind_shelf_o));
colorbar
set(gca, 'ColorScale', 'log')
xlabel('Salinity (ppt)', 'FontSize', 14)
ylabel('Temperature (°C)', 'FontSize', 14)
title(['\it' class2use_label '\rm Counts Outer Shelf (ml^{-1})'])
caxis([0 10])
%upper
nexttile
Z_count_shelf_u = classcount_opt_adhoc_merge.(classlabel)(cruise_upperslope_ind)./meta_data.ml_analyzed(cruise_upperslope_ind);
Z_ind_shelf_u = find(Z_count_shelf_u == 0);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_u)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_u)), 20, Z_count_shelf_u(Z_ind_shelf_u));
hold on
Z_ind_shelf_u = find(Z_count_shelf_u);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_u)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_u)), 20, Z_count_shelf_u(Z_ind_shelf_u));
colorbar
set(gca, 'ColorScale', 'log')
xlabel('Salinity (ppt)', 'FontSize', 14)
ylabel('Temperature (°C)', 'FontSize', 14)
title(['\it' class2use_label '\rm Counts Upper Slope (ml^{-1})'])
caxis([0 10])

%%
%TS plot for seasons with ciliate concentration
figure
tiledlayout(2,2)

%winter
nexttile
Z_count_shelf_w = classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind)./meta_data.ml_analyzed(cruise_winter_ind);
Z_ind_shelf_w = find(Z_count_shelf_w == 0);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_w)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_w)), 20, Z_count_shelf_w(Z_ind_shelf_w));
hold on
Z_ind_shelf_w = find(Z_count_shelf_w);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_w)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_w)), 20, Z_count_shelf_w(Z_ind_shelf_w));
colorbar
set(gca, 'ColorScale', 'log')
xlabel('Salinity (ppt)', 'FontSize', 14)
ylabel('Temperature (°C)', 'FontSize', 14)
title(['\it' class2use_label '\rm Counts Winter (ml^{-1})'])
caxis([0 10])
%spring
nexttile
Z_count_shelf_sp = classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind)./meta_data.ml_analyzed(cruise_spring_ind);
Z_ind_shelf_sp = find(Z_count_shelf_sp == 0);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_sp)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_sp)), 20, Z_count_shelf_sp(Z_ind_shelf_sp));
hold on
Z_ind_shelf_sp = find(Z_count_shelf_sp);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_sp)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_sp)), 20, Z_count_shelf_sp(Z_ind_shelf_sp));
colorbar
set(gca, 'ColorScale', 'log')
xlabel('Salinity (ppt)', 'FontSize', 14)
ylabel('Temperature (°C)', 'FontSize', 14)
title(['\it' class2use_label '\rm Counts Spring (ml^{-1})'])
caxis([0 10])
%summer
nexttile
Z_count_shelf_su = classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind)./meta_data.ml_analyzed(cruise_summer_ind);
Z_ind_shelf_su = find(Z_count_shelf_su == 0);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_su)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_su)), 20, Z_count_shelf_su(Z_ind_shelf_su));
hold on
Z_ind_shelf_su = find(Z_count_shelf_su);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_su)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_su)), 20, Z_count_shelf_su(Z_ind_shelf_su));
colorbar
set(gca, 'ColorScale', 'log')
xlabel('Salinity (ppt)', 'FontSize', 14)
ylabel('Temperature (°C)', 'FontSize', 14)
title(['\it' class2use_label '\rm Counts Summer (ml^{-1})'])
caxis([0 10])
%fall
nexttile
Z_count_shelf_f = classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind)./meta_data.ml_analyzed(cruise_fall_ind);
Z_ind_shelf_f = find(Z_count_shelf_f == 0);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_f)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_f)), 20, Z_count_shelf_f(Z_ind_shelf_f));
hold on
Z_ind_shelf_f = find(Z_count_shelf_f);
scatter(meta_data.salinity(all_used_sample_types(Z_ind_shelf_f)), meta_data.temperature(all_used_sample_types(Z_ind_shelf_f)), 20, Z_count_shelf_f(Z_ind_shelf_f));
colorbar
set(gca, 'ColorScale', 'log')
xlabel('Salinity (ppt)', 'FontSize', 14)
ylabel('Temperature (°C)', 'FontSize', 14)
title(['\it' class2use_label '\rm Counts Fall (ml^{-1})'])
caxis([0 10])

%%
%boxplot for ciliate conc binned into temperatures

%create variables for the boxplot
temp_c = meta_data.temperature;
ciliate_bxp_c = classcount_opt_adhoc_merge.(classlabel).^(1/tr_val)./meta_data.ml_analyzed.^(1/tr_val);

%create bins from 0 to 22 with step 2 in between
temp_bins = 0:2:30;

%discretize temperatures to bin them
[temp_discrete_c, temp_e_c] = discretize(temp_c, temp_bins);

%create the boxplot
figure
boxplot(ciliate_bxp_c, temp_discrete_c)

%add graph details
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Temperature (°C)', 'FontSize', 14)
set(gca, 'XTickLabel', [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30])

%%
%same graph, tiled version for seasons

%summer
figure
temp_su = meta_data.temperature(cruise_summer_ind);
ciliate_bxp_su = classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_summer_ind).^(1/tr_val);
temp_bins_su = 0:2:30;
[temp_discrete_su, temp_e_su] = discretize(temp_su, temp_bins_su);
boxplot(ciliate_bxp_su, temp_discrete_su)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Temperature (°C)', 'FontSize', 14)
set(gca, 'XTickLabel', [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30])

%fall
figure
temp_f = meta_data.temperature(cruise_fall_ind);
ciliate_bxp_f = classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_fall_ind).^(1/tr_val);
temp_bins_f = 0:2:30;
[temp_discrete_f, temp_e_f] = discretize(temp_f, temp_bins_f);
boxplot(ciliate_bxp_f, temp_discrete_f)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Temperature (°C)', 'FontSize', 14)
set(gca, 'XTickLabel', [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30])

%winter
figure
temp_w = meta_data.temperature(cruise_winter_ind);
ciliate_bxp_w = classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_winter_ind).^(1/tr_val);
temp_bins_w = 0:2:30;
[temp_discrete_w, temp_e_w] = discretize(temp_w, temp_bins_w);
boxplot(ciliate_bxp_w, temp_discrete_w)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Temperature (°C)', 'FontSize', 14)
set(gca, 'XTickLabel', [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30])

%spring
figure
temp_sp = meta_data.temperature(cruise_spring_ind);
ciliate_bxp_sp = classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_spring_ind).^(1/tr_val);
temp_bins_sp = 0:2:30;
[temp_discrete_sp, temp_e_sp] = discretize(temp_sp, temp_bins_sp);
boxplot(ciliate_bxp_sp, temp_discrete_sp)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Temperature (°C)', 'FontSize', 14)
set(gca, 'XTickLabel', [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30])

%%
%boxplot for ciliate conc binned into salinities

%create variables for the boxplot
salinity_c = meta_data.salinity;
ciliate_bxp_c = (classcount_opt_adhoc_merge.(classlabel).^(1/tr_val)./meta_data.ml_analyzed.^(1/tr_val));

%create bins from 28 to 34 with step 1 in between
salinity_bins = 30:1:38;

%discretize temperatures to bin them
[salinity_discrete_c, salinity_e_c] = discretize(salinity_c, salinity_bins);

%create the boxplot
figure
boxplot(ciliate_bxp_c, salinity_discrete_c)

%add graph details
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Salinity (ppt)', 'FontSize', 14)
set(gca, 'XTickLabel', [30 31 32 33 34 35 36 37 38])

