%cruise cnn over time with manual graph
%count data only

%%
%loading in data
%cnn summary data
load('/Volumes/IFCB_products/NESLTER_transect/summary/count_group_class_withTS.mat')
%manual data
load('count_manual_current_jill_NESLTER.mat')

%%
%choose transformation value
tr_val = 4;

%%
%checking all vs manual bins using ismember
bins = readtable('/Users/jillianpaquette/Desktop/WHOI Work/IFCB bins annotated for ciliates - Cruise.csv');
annotated_bins = bins.bins;
jill_bins = ismember(filelist_cruise, annotated_bins);

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
%create cnn over time with manual graph

figure
plot(meta_data.datetime(underway_all), classcount_opt_adhoc_merge.(classlabel)(underway_all)./meta_data.ml_analyzed(underway_all), '.')
hold on
plot(meta_data.datetime(underway_discrete), classcount_opt_adhoc_merge.(classlabel)(underway_discrete)./meta_data.ml_analyzed(underway_discrete), 'g.')
hold on
plot(meta_data.datetime(scast), classcount_opt_adhoc_merge.(classlabel)(scast)./meta_data.ml_analyzed(scast), '.')


%add manual in r *
hold on
datetime_bin = datetime(matdate_cruise, 'ConvertFrom', 'datenum');
class_ind = strcmp(class2use_label, class2use_cruise);
plot(datetime_bin(jill_bins), (classcount_cruise(jill_bins, class_ind)./ml_analyzed_cruise(jill_bins)), 'r*')

%add graph details
legend('CNN Auto Classifier Underway', 'CNN Auto Classifier Underway Discrete', 'CNN Autoclassifier Surface Casts', 'Manual Annotations', 'Location', 'northoutside')
xlabel('Year', 'FontSize', 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
ylim([0 inf])
