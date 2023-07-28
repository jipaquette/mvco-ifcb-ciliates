%cruise, summing for highest counts

%%
%loading in data

%cruise cnn summary data
cruise = load('/Volumes/IFCB_products/NESLTER_transect/summary/count_group_class_withTS.mat');
%cruise manual data
cruise_manual = load('count_manual_current_jill_NESLTER.mat');
%mvco cnn summary data
mvco = load('/Volumes/IFCB_products/MVCO/summary_v4/count_group_class.mat');
%mvco manual data
mvco_manual = load('/Users/jillianpaquette/Desktop/WHOI Work/count_manual_current_jill_MVCO.mat');
%mvco env data
load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat')

%%
%first, adjustment of data
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

%adjust meta_data and count_env to add month column
cruise.meta_data.month = month(cruise.meta_data.datetime);
count_env.month = month(count_env.days);

%create manual bin list
bins = readtable('/Users/jillianpaquette/Desktop/WHOI Work/IFCB bins annotated for ciliates - Cruise.csv');
annotated_bins = bins.bins;
jill_manual_bins = ismember(cruise_manual.filelist_cruise, annotated_bins);
cnn_bins = cruise.meta_data.pid;
jill_bin_list = cruise_manual.filelist_cruise(jill_manual_bins);
jill_cnn_bins = ismember(cnn_bins, jill_bin_list);

%%
%cruise sums
balanion_c = sum(cruise.classcount_opt_adhoc_merge.Balanion./cruise.meta_data.ml_analyzed);

ciliophora_c = sum(cruise.classcount_opt_adhoc_merge.Ciliophora./cruise.meta_data.ml_analyzed);

dictyocysta_c = sum(cruise.classcount_opt_adhoc_merge.Dictyocysta./cruise.meta_data.ml_analyzed);

didinium_c = sum(cruise.classcount_opt_adhoc_merge.Didinium./cruise.meta_data.ml_analyzed);

euplotes_c = sum(cruise.classcount_opt_adhoc_merge.Euplotes./cruise.meta_data.ml_analyzed);

euplotes_m1_c = sum(cruise.classcount_opt_adhoc_merge.Euplotes_morphotype1./cruise.meta_data.ml_analyzed);

eutintinnus_c = sum(cruise.classcount_opt_adhoc_merge.Eutintinnus./cruise.meta_data.ml_analyzed);

favella_c = sum(cruise.classcount_opt_adhoc_merge.Favella./cruise.meta_data.ml_analyzed);

laboea_strobila_c = sum(cruise.classcount_opt_adhoc_merge.Laboea_strobila./cruise.meta_data.ml_analyzed);

leegaardiella_ovalis_c = sum(cruise.classcount_opt_adhoc_merge.Leegaardiella_ovalis./cruise.meta_data.ml_analyzed);

mesodinium_c = sum(cruise.classcount_opt_adhoc_merge.Mesodinium./cruise.meta_data.ml_analyzed);

pleuronema_c = sum(cruise.classcount_opt_adhoc_merge.Pleuronema./cruise.meta_data.ml_analyzed);

stenosemella_m1_c = sum(cruise.classcount_opt_adhoc_merge.Stenosemella_morphotype1./cruise.meta_data.ml_analyzed);

stenosemella_pacifica_c = sum(cruise.classcount_opt_adhoc_merge.Stenosemella_pacifica./cruise.meta_data.ml_analyzed);

pelagostrobilidum_c = sum(cruise.classcount_opt_adhoc_merge.Pelagostrobilidium./cruise.meta_data.ml_analyzed);

strombidium_capitatum_c = sum(cruise.classcount_opt_adhoc_merge.Strombidium_capitatum./cruise.meta_data.ml_analyzed);

strombidium_conicum_c = sum(cruise.classcount_opt_adhoc_merge.Strombidium_conicum./cruise.meta_data.ml_analyzed);

strombidium_inclinatum_c = sum(cruise.classcount_opt_adhoc_merge.Strombidium_inclinatum./cruise.meta_data.ml_analyzed);

strombidium_m1_c = sum(cruise.classcount_opt_adhoc_merge.Strombidium_morphotype1./cruise.meta_data.ml_analyzed);

strombidium_m2_c = sum(cruise.classcount_opt_adhoc_merge.Strombidium_morphotype2./cruise.meta_data.ml_analyzed);

strombidium_tintinnodes_c = sum(cruise.classcount_opt_adhoc_merge.Strombidium_tintinnodes./cruise.meta_data.ml_analyzed);

strombidium_wulffi_c = sum(cruise.classcount_opt_adhoc_merge.Strombidium_wulffi./cruise.meta_data.ml_analyzed);

tiarina_fusus_c = sum(cruise.classcount_opt_adhoc_merge.Tiarina_fusus./cruise.meta_data.ml_analyzed);

tintinnina_c = sum(cruise.classcount_opt_adhoc_merge.Tintinnina./cruise.meta_data.ml_analyzed);

tintinnidium_mucicola_c = sum(cruise.classcount_opt_adhoc_merge.Tintinnidium_mucicola./cruise.meta_data.ml_analyzed);

tintinnopsis_c = sum(cruise.classcount_opt_adhoc_merge.Tintinnopsis./cruise.meta_data.ml_analyzed);

tontonia_appendiculariformis_c = sum(cruise.classcount_opt_adhoc_merge.Tontonia_appendiculariformis./cruise.meta_data.ml_analyzed);

paratontonia_gracillima_c = sum(cruise.classcount_opt_adhoc_merge.Paratontonia_gracillima./cruise.meta_data.ml_analyzed);

%%
%mvco sums
balanion_m = sum(count_env.Balanion./count_env.ml_analyzed, 'omitnan');

ciliophora_m = sum(count_env.Ciliophora./count_env.ml_analyzed, 'omitnan');

dictyocysta_m = sum(count_env.Dictyocysta./count_env.ml_analyzed, 'omitnan');

didinium_m = sum(count_env.Didinium./count_env.ml_analyzed, 'omitnan');

euplotes_m = sum(count_env.Euplotes./count_env.ml_analyzed, 'omitnan');

euplotes_m1_m = sum(count_env.Euplotes_morphotype1./count_env.ml_analyzed, 'omitnan');

eutintinnus_m = sum(count_env.Eutintinnus./count_env.ml_analyzed, 'omitnan');

favella_m = sum(count_env.Favella./count_env.ml_analyzed, 'omitnan');

laboea_strobila_m = sum(count_env.Laboea_strobila./count_env.ml_analyzed, 'omitnan');

leegaardiella_ovalis_m = sum(count_env.Leegaardiella_ovalis./count_env.ml_analyzed, 'omitnan');

mesodinium_m = sum(count_env.Mesodinium./count_env.ml_analyzed, 'omitnan');

pleuronema_m = sum(count_env.Pleuronema./count_env.ml_analyzed, 'omitnan');

stenosemella_m1_m = sum(count_env.Stenosemella_morphotype1./count_env.ml_analyzed, 'omitnan');

stenosemella_pacifica_m = sum(count_env.Stenosemella_pacifica./count_env.ml_analyzed, 'omitnan');

pelagostrobilidum_m = sum(count_env.Pelagostrobilidium./count_env.ml_analyzed, 'omitnan');

strombidium_capitatum_m = sum(count_env.Strombidium_capitatum./count_env.ml_analyzed, 'omitnan');

strombidium_conicum_m = sum(count_env.Strombidium_conicum./count_env.ml_analyzed, 'omitnan');

strombidium_inclinatum_m = sum(count_env.Strombidium_inclinatum./count_env.ml_analyzed, 'omitnan');

strombidium_m1_m = sum(count_env.Strombidium_morphotype1./count_env.ml_analyzed, 'omitnan');

strombidium_m2_m = sum(count_env.Strombidium_morphotype2./count_env.ml_analyzed, 'omitnan');

strombidium_tintinnodes_m = sum(count_env.Strombidium_tintinnodes./count_env.ml_analyzed, 'omitnan');

strombidium_wulffi_m = sum(count_env.Strombidium_wulffi./count_env.ml_analyzed, 'omitnan');

tiarina_fusus_m = sum(count_env.Tiarina_fusus./count_env.ml_analyzed, 'omitnan');

tintinnina_m = sum(count_env.Tintinnina./count_env.ml_analyzed, 'omitnan');

tintinnidium_mucicola_m = sum(count_env.Tintinnidium_mucicola./count_env.ml_analyzed, 'omitnan');

tintinnopsis_m = sum(count_env.Tintinnopsis./count_env.ml_analyzed, 'omitnan');

tontonia_appendiculariformis_m = sum(count_env.Tontonia_appendiculariformis./count_env.ml_analyzed, 'omitnan');

paratontonia_gracillima_m = sum(count_env.Paratontonia_gracillima./count_env.ml_analyzed, 'omitnan');

%%
%switch cases for 1:1 lines

%mvco
class2plot_m = 'Balanion';
switch class2plot_m
    case 'Balanion'
        class2use_m = balanion_m;
    case 'Ciliophora'
        class2use_m = ciliophora_m;
    case 'Dictyocysta'
        class2use_m = dictyocysta_m;
    case 'Didinium'
        class2use_m = balanion_m;
    case 'Euplotes'
        class2use_m = balanion_m;
    case 'Euplotes_morphotype1'
        class2use_m = balanion_m;
    case 'Eutintinnius'
        class2use_m = eutintinnus_m;
    case 'Favella'
        class2use_m = favella_m;
    case 'Laboea_strobila'
        class2use_m = laboea_strobila_m;
    case 'Leegaardiella_ovalis'
        class2use_m = leegaardiella_ovalis_m;
    case 'Mesodinium'
        class2use_m = mesodinium_m;
    case 'Paratontonia_gracillima'
        class2use_m = paratontonia_gracillima_m;
    case 'Pelagostrobilidium'
        class2use_m = pelagostrobilidum_m;
    case 'Pleuronema'
        class2use_m = pleuronema_m;
    case 'Stenosemella_m1'
        class2use_m = stenosemella_m1_m;
    case 'Stenosemella_pacifica'
        class2use_m = stenosemella_pacifica_m;
    case 'Strombidium_capitatum'
        class2use_m = strombidium_capitatum_m;
    case 'Strombidium_conicum'
        class2use_m = strombidium_conicum_m;
    case 'Strombidium_inclinatum'
        class2use_m = strombidium_inclinatum_m;
    case 'Strombidium_morphotype1'
        class2use_m = strombidium_m1_m;
    case 'Strombidium_morphotype2'
        class2use_m = strombidium_m2_m;
    case 'Strombidium_tintinnodes'
        class2use_m = strombidium_tintinnodes_m;
    case 'Strombidium_wulffi'
        class2use_m = strombidium_wulffi_m;
    case 'Tiarina_fusus'
        class2use_m = tiarina_fusus_m;
    case 'Tintinnidium_mucicola'   
        class2use_m = tintinnidium_mucicola_m;
    case 'Tintinnina'
        class2use_m = tintinnina_m;
    case 'Tintinnopsis'
        class2use_m = tintinnopsis_m;
    case 'Tontonia_appendiculariformis'
        class2use_m = tontonia_appendiculariformis_m;
end

%cruise
class2plot_c = 'Dictyocysta';
switch class2plot_c
    case 'Balanion'
        class2use_c = balanion_c;
    case 'Ciliophora'
        class2use_c = ciliophora_c;
    case 'Dictyocysta'
        class2use_c = dictyocysta_c;
    case 'Didinium'
        class2use_c = balanion_c;
    case 'Euplotes'
        class2use_c = balanion_c;
    case 'Euplotes_morphotype1'
        class2use_c = balanion_c;
    case 'Eutintinnius'
        class2use_c = eutintinnus_c;
    case 'Favella'
        class2use_c = favella_c;
    case 'Laboea_strobila'
        class2use_c = laboea_strobila_c;
    case 'Leegaardiella_ovalis'
        class2use_c = leegaardiella_ovalis_c;
    case 'Mesodinium'
        class2use_c = mesodinium_c;
    case 'Paratontonia_gracillima'
        class2use_c = paratontonia_gracillima_c;
    case 'Pelagostrobilidium'
        class2use_c = pelagostrobilidum_c;
    case 'Pleuronema'
        class2use_c = pleuronema_c;
    case 'Stenosemella_morphotype1'
        class2use_c = stenosemella_m1_c;
    case 'Stenosemella_pacifica'
        class2use_c = stenosemella_pacifica_c;
    case 'Strombidium_capitatum'
        class2use_c = strombidium_capitatum_c;
    case 'Strombidium_conicum'
        class2use_c = strombidium_conicum_c;
    case 'Strombidium_inclinatum'
        class2use_c = strombidium_inclinatum_c;
    case 'Strombidium_morphotype1'
        class2use_c = strombidium_m1_c;
    case 'Strombidium_morphotype2'
        class2use_c = strombidium_m2_c;
    case 'Strombidium_tintinnodes'
        class2use_c = strombidium_tintinnodes_c;
    case 'Strombidium_wulffi'
        class2use_c = strombidium_wulffi_c;
    case 'Tiarina_fusus'
        class2use_c = tiarina_fusus_c;
    case 'Tintinnidium_mucicola'   
        class2use_c = tintinnidium_mucicola_c;
    case 'Tintinnina'
        class2use_c = tintinnina_c;
    case 'Tintinnopsis'
        class2use_c = tintinnopsis_c;
    case 'Tontonia_appendiculariformis'
        class2use_c = tontonia_appendiculariformis_c;
end

%%
%creating tables
cruise_sums = table;

cruise_sums.Balanion = balanion_c;
cruise_sums.Ciliophora = ciliophora_c;
cruise_sums.Dictyocysta = dictyocysta_c;
cruise_sums.Didinium = didinium_c;
cruise_sums.Euplotes = euplotes_c;
cruise_sums.Euplotes_morphotype_1 = euplotes_m1_c;
cruise_sums.Eutintinnius = eutintinnus_c;
cruise_sums.Favella = favella_c;
cruise_sums.Laboea_strobila = laboea_strobila_c;
cruise_sums.Leegaardiella_ovalis = leegaardiella_ovalis_c;
cruise_sums.Mesodinium = mesodinium_c;
cruise_sums.Paratontonia_gracillima = paratontonia_gracillima_c;
cruise_sums.Pelagostrobilidium = pelagostrobilidum_c;
cruise_sums.Pleuronema = pleuronema_c;
cruise_sums.Stenosemella_morphotype1 = stenosemella_m1_c;
cruise_sums.Stenosemella_pacifica = stenosemella_pacifica_c;
cruise_sums.Strombidium_capitatum = strombidium_capitatum_c;
cruise_sums.Strombidium_concium = strombidium_conicum_c;
cruise_sums.Strombidium_inclinatum = strombidium_inclinatum_c;
cruise_sums.Strombidium_morphotype1 = strombidium_m1_c;   
cruise_sums.Strombidium_morphotype2 = strombidium_m2_c;
cruise_sums.Strombidium_tintinnodes = strombidium_tintinnodes_c;
cruise_sums.Strombidium_wulffi = strombidium_wulffi_c;
cruise_sums.Tiarina_fusus = tiarina_fusus_c;
cruise_sums.Tintinnidium_mucicola = tintinnidium_mucicola_c;
cruise_sums.Tintinnina = tintinnina_c;
cruise_sums.Tintinnopsis = tintinnopsis_c;
cruise_sums.Tontonia_appendiculariformis = tontonia_appendiculariformis_c;

%%
mvco_sums = table;

mvco_sums.Balanion = balanion_m;
mvco_sums.Ciliophora = ciliophora_m;
mvco_sums.Dictyocysta = dictyocysta_m;
mvco_sums.Didinium = didinium_m;
mvco_sums.Euplotes = euplotes_m;
mvco_sums.Euplotes_morphotype_1 = euplotes_m1_m;
mvco_sums.Eutintinnius = eutintinnus_m;
mvco_sums.Favella = favella_m;
mvco_sums.Laboea_strobila = laboea_strobila_m;
mvco_sums.Leegaardiella_ovalis = leegaardiella_ovalis_m;
mvco_sums.Mesodinium = mesodinium_m;
mvco_sums.Paratontonia_gracillima = paratontonia_gracillima_m;
mvco_sums.Pelagostrobilidium = pelagostrobilidum_m;
mvco_sums.Pleuronema = pleuronema_m;
mvco_sums.Stenosemella_morphotype1 = stenosemella_m1_m;
mvco_sums.Stenosemella_pacifica = stenosemella_pacifica_m;
mvco_sums.Strombidium_capitatum = strombidium_capitatum_m;
mvco_sums.Strombidium_concium = strombidium_conicum_m;
mvco_sums.Strombidium_inclinatum = strombidium_inclinatum_m;
mvco_sums.Strombidium_morphotype1 = strombidium_m1_m;   
mvco_sums.Strombidium_morphotype2 = strombidium_m2_m;
mvco_sums.Strombidium_tintinnodes = strombidium_tintinnodes_m;
mvco_sums.Strombidium_wulffi = strombidium_wulffi_m;
mvco_sums.Tiarina_fusus = tiarina_fusus_m;
mvco_sums.Tintinnidium_mucicola = tintinnidium_mucicola_m;
mvco_sums.Tintinnina = tintinnina_m;
mvco_sums.Tintinnopsis = tintinnopsis_m;
mvco_sums.Tontonia_appendiculariformis = tontonia_appendiculariformis_m;

%%
%highest counts for mvco
%balanion = 2.3859e+03
%ciliophora = 1.4664e+04
%mesodinium  = 3.0900e+03
%laboea strobila = 502.9804
%paratontonia gracillima = 921.1206
%strombidium m1 = 1.1002e+03
%strombidium m2 = 
%strombidium tintinnodes = 742.6627 
%tintinnopsis = 1.1714e+03

%highest counts for cruise
%balanion = 4.7429e+03
%ciliophora = 5.1893e+04
%laboea strobila = 632.0185
%leegaardiella ovalis = 609.7518
%mesodinium = 8.3534e+03
%strombidim m1 = 1.0730e+03
%strombidium tintinnodes = 3.3387e+03
%tintinnina = 2.0156e+03
%tontonia appendiculariformis = 1.9685e+03

%don't use ciliophora or anything not overlapping
%meaning, just use balanion, mesodinium, laboea strobila, strombidium m1,
%strombidium tintinnodes

%%
%1:1 line graphs - cruise
figure
tiledlayout(2,3)
%balanion
nexttile
class_ind = strcmp('Balanion', cruise_manual.class2use_cruise);
plot((cruise_manual.classcount_cruise(jill_manual_bins, class_ind)./cruise_manual.ml_analyzed_cruise(jill_manual_bins)), ...
    (cruise.classcount_opt_adhoc_merge.Balanion(jill_cnn_bins)./cruise.meta_data.ml_analyzed(jill_cnn_bins)), ...
    '.', 'MarkerSize', 8)   
xlabel('Manual ml^{-1}')
ylabel('CNN ml^{-1}')
xlim([0 4])
ylim([0 4])
title('Balanion')
%mesodinium
nexttile
class_ind = strcmp('Mesodinium', cruise_manual.class2use_cruise);
plot((cruise_manual.classcount_cruise(jill_manual_bins, class_ind)./cruise_manual.ml_analyzed_cruise(jill_manual_bins)), ...
    (cruise.classcount_opt_adhoc_merge.Mesodinium(jill_cnn_bins)./cruise.meta_data.ml_analyzed(jill_cnn_bins)), ...
    '.', 'MarkerSize', 8)   
xlabel('Manual ml^{-1}')
ylabel('CNN ml^{-1}')
xlim([0 5])
ylim([0 5])
title('Mesodinium')
%laboea strobila 
nexttile
class_ind = strcmp('Laboea strobila', cruise_manual.class2use_cruise);
plot((cruise_manual.classcount_cruise(jill_manual_bins, class_ind)./cruise_manual.ml_analyzed_cruise(jill_manual_bins)), ...
    (cruise.classcount_opt_adhoc_merge.Laboea_strobila(jill_cnn_bins)./cruise.meta_data.ml_analyzed(jill_cnn_bins)), ...
    '.', 'MarkerSize', 8)   
xlabel('Manual ml^{-1}')
ylabel('CNN ml^{-1}')
xlim([0 2])
ylim([0 2])
title('Laboea strobila')
%strombidium m1
nexttile
class_ind = strcmp('Strombidium morphotype1', cruise_manual.class2use_cruise);
plot((cruise_manual.classcount_cruise(jill_manual_bins, class_ind)./cruise_manual.ml_analyzed_cruise(jill_manual_bins)), ...
    (cruise.classcount_opt_adhoc_merge.Strombidium_morphotype1(jill_cnn_bins)./cruise.meta_data.ml_analyzed(jill_cnn_bins)), ...
    '.', 'MarkerSize', 8)   
xlabel('Manual ml^{-1}')
ylabel('CNN ml^{-1}')
xlim([0 1.5])
ylim([0 1.5])
title('Strombidium morphotype 1')
%strombidium tintinnodes 
nexttile
class_ind = strcmp('Strombidium tintinnodes', cruise_manual.class2use_cruise);
plot((cruise_manual.classcount_cruise(jill_manual_bins, class_ind)./cruise_manual.ml_analyzed_cruise(jill_manual_bins)), ...
    (cruise.classcount_opt_adhoc_merge.Strombidium_tintinnodes(jill_cnn_bins)./cruise.meta_data.ml_analyzed(jill_cnn_bins)), ...
    '.', 'MarkerSize', 8)   
xlabel('Manual ml^{-1}')
ylabel('CNN ml^{-1}')
xlim([0 4])
ylim([0 4])
title('Strombidium tintinnodes')
