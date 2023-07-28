%trying day function and gscatter for climatology

%%
%loading in data
%cnn summary data
load('/Volumes/IFCB_products/NESLTER_transect/summary/count_group_class_withTS.mat')

%%
%choose transformation value
tr_val = 4;

%%
%indexing
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

%creating indices for latitudes and shelf regions
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
%day function
doy = day(meta_data.datetime, 'dayofyear');
meta_data.year = year(meta_data.datetime); 

%%
%trying to do climatology with doy with gscatter
%gscatter
figure
gscatter(doy, classcount_opt_adhoc_merge.(classlabel)./meta_data.ml_analyzed, meta_data.year);
datetick
ylim([0 inf])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)

%%
%same graph but tiled for shelf regions
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
%same graph but tiled for seasons
figure
tiledlayout(2,2)

%summer
nexttile
gscatter(doy(cruise_summer_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind)./meta_data.ml_analyzed(cruise_summer_ind), meta_data.year(cruise_summer_ind));
datetick
ylim([0 inf])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Summer')
%fall
nexttile
gscatter(doy(cruise_fall_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind)./meta_data.ml_analyzed(cruise_fall_ind), meta_data.year(cruise_fall_ind));
datetick
ylim([0 inf])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Fall')
%winter
nexttile
gscatter(doy(cruise_winter_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind)./meta_data.ml_analyzed(cruise_winter_ind), meta_data.year(cruise_winter_ind));
datetick
ylim([0 inf])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Winter')
%spring
nexttile
gscatter(doy(cruise_spring_ind), classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind)./meta_data.ml_analyzed(cruise_spring_ind), meta_data.year(cruise_spring_ind));
datetick
ylim([0 inf])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Spring')