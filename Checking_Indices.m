%checking indices to make sure they're functionng as expected

%%
%loading in data
%mvco
mvco_cnn = load('/Volumes/IFCB_products/MVCO/summary_v4/count_group_class.mat');
%cruise
load('/Volumes/IFCB_products/NESLTER_transect/summary/count_group_class_withTS.mat');
%manual mvco
mvco_manual = load('/Users/jillianpaquette/Desktop/WHOI Work/count_manual_current_jill_MVCO.mat');
%manual cruise
load('count_manual_current_jill_NESLTER.mat');
%mvco env data
mvco_env = load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat');

%%
%first, adjustment of data
%change summary to timetable
count_mvco_ttable_full = table2timetable(mvco_cnn.classcount_opt_adhoc_merge,'rowtimes', mvco_cnn.meta_data.datetime);

%add ml_analyzed
count_mvco_ttable_full.ml_analyzed = mvco_cnn.meta_data.ml_analyzed;

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

%adjust meta_data and count_env to add month column
meta_data.month = month(meta_data.datetime);
count_env.month = month(count_env.days);

%%
%now, creating all indices

%checking all vs manual bins using ismember
bins = readtable('/Users/jillianpaquette/Desktop/WHOI Work/IFCB bins annotated for ciliates - Cruise.csv');
annotated_bins = bins.bins;
jill_manual_bins = ismember(filelist_cruise, annotated_bins);

%underways
cruiseStr = 'AR34B';
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

%indices for each region of the shelf with each season
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
class2plot = 'Tontonia appendiculariformis';

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
%cruise: create an ismember to have just CNN bins that I annotated
%annotated bins already defined, line 56-59
%bins = readtable('/Users/jillianpaquette/Desktop/WHOI Work/IFCB bins annotated for ciliates - Cruise.csv');
%annnotated_bins = bins.bins;
cnn_bins = meta_data.pid;
jill_bin_list = filelist_cruise(jill_manual_bins);
jill_cnn_bins = ismember(cnn_bins, jill_bin_list);

%%
%mvco: create an ismember to have just CNN bins vs annotated ones 


%%
%cruise: CNN vs manual - all annotated bins
class_ind = strcmp(class2use_label, class2use_cruise);
figure
plot((classcount_cruise(jill_manual_bins, class_ind)./ml_analyzed_cruise(jill_manual_bins)), ...
    (classcount_opt_adhoc_merge.(classlabel)(jill_cnn_bins)./meta_data.ml_analyzed(jill_cnn_bins)), ...
    '.', 'MarkerSize', 18)   
xlim([0 2])
ylim([0 2])
xlabel('Manually Identified Counts per mL', 'FontSize', 14)
ylabel('CNN Identified Counts per mL', 'FontSize', 14)
title(['\it' class2use_label '\rm'])

%%
%cruise: CNN vs manual - underway
% check_underway_manual = ;
% check_underway_cnn = ;
% 
% figure
% plot((classcount_cruise(jill_manual_bins, class_ind)./ml_analyzed_cruise(jill_manual_bins)), ...
%     (classcount_opt_adhoc_merge.(classlabel)(jill_cnn_bins)./meta_data.ml_analyzed(jill_cnn_bins)), ...
%     '.', 'MarkerSize', 18) 

%%
%cruise: CNN vs manual - underway_discrete

%%
%cruise: CNN vs manual - surface cast

%%
%cruise: counts vs latitude - checking that each latitude index is correct
figure
plot(meta_data.latitude(cruise_innershelf_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_innershelf_ind)./meta_data.ml_analyzed(cruise_innershelf_ind), '.')
hold on
plot(meta_data.latitude(cruise_midshelf_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_midshelf_ind)./meta_data.ml_analyzed(cruise_midshelf_ind), '.')
hold on
plot(meta_data.latitude(cruise_outershelf_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_outershelf_ind)./meta_data.ml_analyzed(cruise_outershelf_ind), '.')
hold on
plot(meta_data.latitude(cruise_upperslope_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_upperslope_ind)./meta_data.ml_analyzed(cruise_upperslope_ind), '.')
xlabel('Latitude (degrees)', 'FontSize', 14)
ylabel('Counts per mL', 'FontSize', 14)
legend('Inner Shelf', 'Mid Shelf', 'Outer Shelf', 'Upper Slope')

%%
%cruise: depth vs cast - checking that all 'scast_ind' points are <10 m
figure
plot(classcount_opt_adhoc_merge.(classlabel)./meta_data.ml_analyzed, meta_data.depth, '.')
hold on
plot(classcount_opt_adhoc_merge.(classlabel)(scast)./meta_data.ml_analyzed(scast), meta_data.depth(scast), '.')
set(gca, 'YDir', 'reverse')
ylabel('Depth (m)', 'FontSize', 14)
xlabel('Counts per mL', 'FontSize', 14)
ylim([-5, 100])

%%
%cruise: season vs time - checking that each season index is correct
figure
plot(meta_data.datetime(cruise_summer_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind)./meta_data.ml_analyzed(cruise_summer_ind), '.')
hold on
plot(meta_data.datetime(cruise_fall_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind)./meta_data.ml_analyzed(cruise_fall_ind), '.')
hold on
plot(meta_data.datetime(cruise_winter_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind)./meta_data.ml_analyzed(cruise_winter_ind), '.')
hold on
plot(meta_data.datetime(cruise_spring_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind)./meta_data.ml_analyzed(cruise_spring_ind), '.')
xlabel('Time', 'FontSize', 14)
ylabel('Counts per mL', 'FontSize', 14)
legend('Summer', 'Fall', 'Winter', 'Spring')
title('Cruise Seasons')

%%
%mvco: season vs time - checking that each season index is correct
figure
plot(count_env.days(mvco_summer_ind), count_env.(classlabel)(mvco_summer_ind)./count_env.ml_analyzed(mvco_summer_ind), '.')
hold on
plot(count_env.days(mvco_fall_ind), count_env.(classlabel)(mvco_fall_ind)./count_env.ml_analyzed(mvco_fall_ind), '.')
hold on
plot(count_env.days(mvco_winter_ind), count_env.(classlabel)(mvco_winter_ind)./count_env.ml_analyzed(mvco_winter_ind), '.')
hold on
plot(count_env.days(mvco_spring_ind), count_env.(classlabel)(mvco_spring_ind)./count_env.ml_analyzed(mvco_spring_ind), '.')
xlabel('Time', 'FontSize', 14)
ylabel('Counts per mL', 'FontSize', 14)
legend('Summer', 'Fall', 'Winter', 'Spring')
title('MVCO Seasons')

%%
%cruise: checking single_cruise index
figure
plot(meta_data.datetime(single_cruise), meta_data.latitude(single_cruise), '.')
xlabel('Time', 'FontSize', 14)
ylabel('Latitude (degrees)', 'FontSize', 14)