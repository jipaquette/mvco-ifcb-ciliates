%mvco and cruise seasons and shelf regions graph
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
%indexing latitudes for cruise: underway, underway_discrete, 
%and surface casts
cruise_innershelf_ind = find((cruise.meta_data.latitude >= 40.98 ...
    & ~cruise.meta_data.skip & cruise.meta_data.depth < 10) ...
    & (cruise.meta_data.sample_type == 'underway' ...
    | cruise.meta_data.sample_type == 'underway_discrete' ...
    | cruise.meta_data.sample_type == 'cast'));
cruise_midshelf_ind = find((cruise.meta_data.latitude >= 40.327 & cruise.meta_data.latitude <= 40.98 ...
    & ~cruise.meta_data.skip & cruise.meta_data.depth < 10) ...
    & (cruise.meta_data.sample_type == 'underway' ...
    | cruise.meta_data.sample_type == 'underway_discrete' ...
    | cruise.meta_data.sample_type == 'cast'));
cruise_outershelf_ind = find((cruise.meta_data.latitude >= 39.923 & cruise.meta_data.latitude <= 40.327 ...
    & ~cruise.meta_data.skip & cruise.meta_data.depth < 10) ...
    & (cruise.meta_data.sample_type == 'underway' ...
    | cruise.meta_data.sample_type == 'underway_discrete' ...
    | cruise.meta_data.sample_type == 'cast'));
cruise_upperslope_ind = find((cruise.meta_data.latitude <= 39.923 ...
    & ~cruise.meta_data.skip & cruise.meta_data.depth < 10) ...
    & (cruise.meta_data.sample_type == 'underway' ...
    | cruise.meta_data.sample_type == 'underway_discrete' ...
    | cruise.meta_data.sample_type == 'cast'));

% innershelf_lat = 40.98;
% midshelf_maxlat = 40.98;
% midshelf_minlat  = 40.327;
% outershelf_maxlat = 40.327;
% outershelf_minlat = 39.923;
% upperslope_lat = 39.923;

%%
%choose transformation value
tr_val = 4;

%%
%ciliate taxon to change
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
        class2use_label = "Tintinnopsis";
    case 'Tontonia appendiculariformis'
        classlabel = 'Tontonia_appendiculariformis';
        class2use_label = 'Tontonia appendiculariformis';
    case 'Paratontonia gracillima'
        classlabel = 'Paratontonia_gracillima';
        class2use_label = 'Paratontonia gracillima';
end

%%
%time and cnn seasons as colors mvco as gray over shelf regions cruise and mvco 

%first create indices for each region of the shelf with each season
%inner
cruise_inner_fall = intersect(cruise_innershelf_ind, cruise_fall_ind);
cruise_inner_winter = intersect(cruise_innershelf_ind, cruise_winter_ind);
cruise_inner_spring = intersect(cruise_innershelf_ind, cruise_spring_ind);
cruise_inner_summer = intersect(cruise_innershelf_ind, cruise_summer_ind);
%mid
cruise_mid_fall = intersect(cruise_midshelf_ind, cruise_fall_ind);
cruise_mid_winter = intersect(cruise_midshelf_ind, cruise_winter_ind);
cruise_mid_spring = intersect(cruise_midshelf_ind, cruise_spring_ind);
cruise_mid_summer = intersect(cruise_midshelf_ind, cruise_summer_ind);
%outer
cruise_outer_fall = intersect(cruise_outershelf_ind, cruise_fall_ind);
cruise_outer_winter = intersect(cruise_outershelf_ind, cruise_winter_ind);
cruise_outer_spring = intersect(cruise_outershelf_ind, cruise_spring_ind);
cruise_outer_summer = intersect(cruise_outershelf_ind, cruise_summer_ind);
%upper
cruise_upper_fall = intersect(cruise_upperslope_ind, cruise_fall_ind);
cruise_upper_winter = intersect(cruise_upperslope_ind, cruise_winter_ind);
cruise_upper_spring = intersect(cruise_upperslope_ind, cruise_spring_ind);
cruise_upper_summer = intersect(cruise_upperslope_ind, cruise_summer_ind);

%%
%now create the figure using created indices
figure
tiledlayout(2,2)

%mvco and inner shelf + seasons
nexttile
    %mvco
    plot(count_env.days, count_env.(classlabel)./count_env.ml_analyzed, ...
        '.', 'Color', [0.4 0.4 0.4])
    %cruise inner summer
    hold on
    plot(cruise.meta_data.datetime(cruise_inner_summer), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_inner_summer) ...
        ./cruise.meta_data.ml_analyzed(cruise_inner_summer), ...
        '.', 'Color', [0.9290 0.6940 0.1250])
    %cruise inner fall
    hold on
    plot(cruise.meta_data.datetime(cruise_inner_fall), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_inner_fall) ...
        ./cruise.meta_data.ml_analyzed(cruise_inner_fall), ...
        'o', 'Color', [0.8500 0.3250 0.0980])
    %cruise inner winter
    hold on
    plot(cruise.meta_data.datetime(cruise_inner_winter), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_inner_winter) ...
        ./cruise.meta_data.ml_analyzed(cruise_inner_winter), ...
        '*', 'Color', [0 0.4470 0.7410])
    %cruise inner spring
    hold on
    plot(cruise.meta_data.datetime(cruise_inner_spring), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_inner_spring) ...
        ./cruise.meta_data.ml_analyzed(cruise_inner_spring), ...
        '+', 'Color', [0.4660 0.6740 0.1880])
xlabel('Year', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
ylim([0 10])
title('Inner Shelf + Seasons')

%mvco and mid shelf + seasons
nexttile
    %mvco
    plot(count_env.days, count_env.(classlabel)./count_env.ml_analyzed, ...
        '.', 'Color', [0.4 0.4 0.4])
    %cruise mid summer
    hold on
    plot(cruise.meta_data.datetime(cruise_mid_summer), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_mid_summer) ...
        ./cruise.meta_data.ml_analyzed(cruise_mid_summer), ...
        '.', 'Color', [0.9290 0.6940 0.1250])
    %cruise mid fall
    hold on
    plot(cruise.meta_data.datetime(cruise_mid_fall), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_mid_fall) ...
        ./cruise.meta_data.ml_analyzed(cruise_mid_fall), ...
        'o', 'Color', [0.8500 0.3250 0.0980])
    %cruise mid winter
    hold on
    plot(cruise.meta_data.datetime(cruise_mid_winter), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_mid_winter) ...
        ./cruise.meta_data.ml_analyzed(cruise_mid_winter), ...
        '*', 'Color', [0 0.4470 0.7410])
    %cruise mid spring
    hold on
    plot(cruise.meta_data.datetime(cruise_mid_spring), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_mid_spring) ...
        ./cruise.meta_data.ml_analyzed(cruise_mid_spring), ...
        '+', 'Color', [0.4660 0.6740 0.1880])
xlabel('Year', 'FontSize', 14)
ylim([0 10])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Mid Shelf + Seasons')

%mvco and outer shelf + seasons
nexttile
    %mvco
    plot(count_env.days, count_env.(classlabel)./count_env.ml_analyzed, ...
        '.', 'Color', [0.4 0.4 0.4])
    %cruise outer summer
    hold on
    plot(cruise.meta_data.datetime(cruise_outer_summer), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_outer_summer) ...
        ./cruise.meta_data.ml_analyzed(cruise_outer_summer), ...
        '.', 'Color', [0.9290 0.6940 0.1250])
    %cruise outer fall
    hold on
    plot(cruise.meta_data.datetime(cruise_outer_fall), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_outer_fall) ...
        ./cruise.meta_data.ml_analyzed(cruise_outer_fall), ...
        'o', 'Color', [0.8500 0.3250 0.0980])
    %cruise outer winter
    hold on
    plot(cruise.meta_data.datetime(cruise_outer_winter), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_outer_winter) ...
        ./cruise.meta_data.ml_analyzed(cruise_outer_winter), ...
        '*', 'Color', [0 0.4470 0.7410])
    %cruise outer spring
    hold on
    plot(cruise.meta_data.datetime(cruise_outer_spring), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_outer_spring) ...
        ./cruise.meta_data.ml_analyzed(cruise_outer_spring), ...
        '+', 'Color', [0.4660 0.6740 0.1880])
xlabel('Year', 'FontSize', 14)
ylim([0 10])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Outer Shelf + Seasons')

%mvco and upper slope + seasons
nexttile
    %mvco
    plot(count_env.days, count_env.(classlabel)./count_env.ml_analyzed, ...
        '.', 'Color', [0.4 0.4 0.4])
    %cruise upper summer
    hold on
    plot(cruise.meta_data.datetime(cruise_upper_summer), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_upper_summer) ...
        ./cruise.meta_data.ml_analyzed(cruise_upper_summer), ...
        '.', 'Color', [0.9290 0.6940 0.1250])
    %cruise upper fall
    hold on
    plot(cruise.meta_data.datetime(cruise_upper_fall), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_upper_fall) ...
        ./cruise.meta_data.ml_analyzed(cruise_upper_fall), ...
        'o', 'Color', [0.8500 0.3250 0.0980])
    %cruise upper winter
    hold on
    plot(cruise.meta_data.datetime(cruise_upper_winter), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_upper_winter) ...
        ./cruise.meta_data.ml_analyzed(cruise_upper_winter), ...
        '*', 'Color', [0 0.4470 0.7410])
    %cruise upper spring
    hold on
    plot(cruise.meta_data.datetime(cruise_upper_spring), ...
        cruise.classcount_opt_adhoc_merge.(classlabel)(cruise_upper_spring) ...
        ./cruise.meta_data.ml_analyzed(cruise_upper_spring), ...
        '+', 'Color', [0.4660 0.6740 0.1880])
xlabel('Year', 'FontSize', 14)
ylim([0 10])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
title('Upper Slope + Seasons')
