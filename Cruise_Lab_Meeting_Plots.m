%cruise lab meeting plots

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
%day function
doy = day(meta_data.datetime, 'dayofyear');
meta_data.year = year(meta_data.datetime); 

%%
%gscatter using doy for "climatology"
figure
tiledlayout(2,2)

%inner
nexttile
gscatter(doy(cruise_innershelf_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_innershelf_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_innershelf_ind).^(1/tr_val), meta_data.year(cruise_innershelf_ind));
ylim([0 inf])
title('Inner Shelf')
%mid
nexttile
gscatter(doy(cruise_midshelf_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_midshelf_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_midshelf_ind).^(1/tr_val), meta_data.year(cruise_midshelf_ind));
ylim([0 inf])
title('Mid Shelf')
%outer
nexttile
gscatter(doy(cruise_outershelf_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_outershelf_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_outershelf_ind).^(1/tr_val), meta_data.year(cruise_outershelf_ind));
ylim([0 inf])
title('Outer Shelf')
%upper
nexttile
gscatter(doy(cruise_upperslope_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_upperslope_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_upperslope_ind).^(1/tr_val), meta_data.year(cruise_upperslope_ind));
ylim([0 inf])
title('Upper Slope')

ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Day of year', 'FontSize', 14)

%%
%temp boxplot tiled
figure
tiledlayout(2,2)
ticklabels = [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30];
xticklabels = num2str(ticklabels');

%summer
nexttile
temp_su = meta_data.temperature(cruise_summer_ind);
ciliate_bxp_su = classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_summer_ind).^(1/tr_val);
temp_bins_su = 0:2:30;
[temp_discrete_su, temp_e_su] = discretize(temp_su, temp_bins_su);
boxplot(ciliate_bxp_su, temp_discrete_su)
set(gca, 'XTickLabel', xticklabels)
title('Summer')

%fall
nexttile
temp_f = meta_data.temperature(cruise_fall_ind);
ciliate_bxp_f = classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_fall_ind).^(1/tr_val);
temp_bins_f = 0:2:30;
[temp_discrete_f, temp_e_f] = discretize(temp_f, temp_bins_f);
boxplot(ciliate_bxp_f, temp_discrete_f)
set(gca, 'XTickLabel', xticklabels)
title('Fall')

%winter
nexttile
temp_w = meta_data.temperature(cruise_winter_ind);
ciliate_bxp_w = classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_winter_ind).^(1/tr_val);
temp_bins_w = 0:2:30;
[temp_discrete_w, temp_e_w] = discretize(temp_w, temp_bins_w);
boxplot(ciliate_bxp_w, temp_discrete_w)
set(gca, 'XTickLabel', xticklabels)
title('Winter')

%spring
nexttile
temp_sp = meta_data.temperature(cruise_spring_ind);
ciliate_bxp_sp = classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_spring_ind).^(1/tr_val);
temp_bins_sp = 0:2:30;
[temp_discrete_sp, temp_e_sp] = discretize(temp_sp, temp_bins_sp);
boxplot(ciliate_bxp_sp, temp_discrete_sp)
set(gca, 'XTickLabel', xticklabels)
title('Spring')

ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Temperature (°C)', 'FontSize', 14)

%%
%count vs. temp seasons
figure

%fall
plot(meta_data.temperature(cruise_fall_ind), ...
    classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_fall_ind).^(1/tr_val), ...
    'o', 'Color', [0.8500 0.3250 0.0980])
%winter
hold on
plot(meta_data.temperature(cruise_winter_ind), ...
    classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_winter_ind).^(1/tr_val), ...
    '*', 'Color', [0 0.4470 0.7410])
%spring
hold on
plot(meta_data.temperature(cruise_spring_ind), ...
    classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_spring_ind).^(1/tr_val), ...
    '+', 'Color', [0.4660 0.6740 0.1880])
%summer
hold on
plot(meta_data.temperature(cruise_summer_ind), ...
    classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind).^(1/tr_val)./meta_data.ml_analyzed(cruise_summer_ind).^(1/tr_val), ...
    '.', 'Color', [0.9290 0.6940 0.1250])

%adding graph details
xlabel('Temperature (°C)', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
legend('Fall', 'Winter', 'Spring', 'Summer')