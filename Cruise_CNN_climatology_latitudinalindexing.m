%cruise cnn over time climatology graphs (includes latitudinal indexing)
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
underway_all = find(meta_data.sample_type == 'underway' & ~meta_data.skip);
underway_discrete = find(meta_data.sample_type == 'underway_discrete' & ~meta_data.skip);

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

% innershelf_lat = 40.98;
% midshelf_maxlat = 40.98;
% midshelf_minlat  = 40.327;
% outershelf_maxlat = 40.327;
% outershelf_minlat = 39.923;
% upperslope_lat = 39.923;

%%
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
%cnn data with each year as a separate colored line

%climatology function
count_var2plot = classcount_opt_adhoc_merge.(classlabel)./meta_data.ml_analyzed;
count_mdate = datenum(meta_data.datetime);
[ count_mdate_mat, count_y_mat, count_yearlist, count_yd ] = timeseries2ydmat( count_mdate, count_var2plot );

%create plot
figure
plot(count_yd, count_y_mat, '.-')

%add graph details
%change from days of year to months
datetick
legend(num2str(count_yearlist'), 'Location', 'eastoutside')
ylim([0 inf])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)

%%
%create same plot as above but tiledlayout(2,2) for each shelf region
figure
tiledlayout(2,2)
%innershelf
%new climatology function for innershelf_ind
count_var2plot_i = classcount_opt_adhoc_merge.(classlabel)(cruise_innershelf_ind)./meta_data.ml_analyzed(cruise_innershelf_ind);
count_mdate_i = datenum(meta_data.datetime(cruise_innershelf_ind));
[ count_mdate_mat_i, count_y_mat_i, count_yearlist_i, count_yd_i ] = timeseries2ydmat( count_mdate_i , count_var2plot_i );
[ count_xmean_i, count_xstd_i ] = smoothed_climatology( count_y_mat_i , 10);
%plot
nexttile
plot(count_yd_i, count_y_mat_i, '.', 'MarkerSize', 10)
datetick
legend(num2str(count_yearlist_i'), 'Location', 'northeast')
ylim([0 1.8])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Inner Shelf')
%midshelf
%new climatology function for midshelf_ind
count_var2plot_m = classcount_opt_adhoc_merge.(classlabel)(cruise_midshelf_ind)./meta_data.ml_analyzed(cruise_midshelf_ind);
count_mdate_m = datenum(meta_data.datetime(cruise_midshelf_ind));
[ count_mdate_mat_m, count_y_mat_m, count_yearlist_m, count_yd_m ] = timeseries2ydmat( count_mdate_m , count_var2plot_m );
[ count_xmean_m, count_xstd_m ] = smoothed_climatology( count_y_mat_m , 10);
%plot
nexttile
plot(count_yd_m, count_y_mat_m, '.', 'MarkerSize', 10)
datetick
legend(num2str(count_yearlist_m'), 'Location', 'northeast')
ylim([0 1.8])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Mid Shelf')
%outershelf
%new climatology function for outershelf_ind
count_var2plot_o = classcount_opt_adhoc_merge.(classlabel)(cruise_outershelf_ind)./meta_data.ml_analyzed(cruise_outershelf_ind);
count_mdate_o = datenum(meta_data.datetime(cruise_outershelf_ind));
[ count_mdate_mat_o, count_y_mat_o, count_yearlist_o, count_yd_o ] = timeseries2ydmat( count_mdate_o , count_var2plot_o );
[ count_xmean_o, count_xstd_o ] = smoothed_climatology( count_y_mat_o , 10);
%plot
nexttile
plot(count_yd_o, count_y_mat_o, '.', 'MarkerSize', 10)
datetick
legend(num2str(count_yearlist_o'), 'Location', 'northeast')
ylim([0 1.8])
ylabel(['\it' class2use_label '\rm Count (ml^({-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Outer Shelf')
%upperslope
%new climatology function for upperslope_ind
count_var2plot_u = classcount_opt_adhoc_merge.(classlabel)(cruise_upperslope_ind)./meta_data.ml_analyzed(cruise_upperslope_ind);
count_mdate_u = datenum(meta_data.datetime(cruise_upperslope_ind));
[ count_mdate_mat_u, count_y_mat_u, count_yearlist_u, count_yd_u ] = timeseries2ydmat( count_mdate_u , count_var2plot_u );
[ count_xmean_u, count_xstd_u ] = smoothed_climatology( count_y_mat_u , 10);
%plot
nexttile
plot(count_yd_u, count_y_mat_u, '.', 'MarkerSize', 10)
datetick
legend(num2str(count_yearlist_u'), 'Location', 'northeast')
ylim([0 1.8])
ylabel(['\it' class2use_label '\rm Count (ml^({-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Upper Slope')

%%
%create same plot as above but tiledlayout(2,2) for each season
figure
tiledlayout(2,2)
%winter
%new climatology function for cruise_winter_ind
count_var2plot_w = classcount_opt_adhoc_merge.(classlabel)(cruise_winter_ind)./meta_data.ml_analyzed(cruise_winter_ind);
count_mdate_w = datenum(meta_data.datetime(cruise_winter_ind));
[ count_mdate_mat_w, count_y_mat_w, count_yearlist_w, count_yd_w ] = timeseries2ydmat( count_mdate_w , count_var2plot_w );
[ count_xmean_w, count_xstd_w ] = smoothed_climatology( count_y_mat_w , 10);
%plot
nexttile
plot(count_yd_w, count_y_mat_w, '.', 'MarkerSize', 10)
datetick
legend(num2str(count_yearlist_w'), 'Location', 'northeast')
ylim([0 1.4])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Winter')
%summer
%new climatology function for cruise_summer_ind
count_var2plot_su = classcount_opt_adhoc_merge.(classlabel)(cruise_summer_ind)./meta_data.ml_analyzed(cruise_summer_ind);
count_mdate_su = datenum(meta_data.datetime(cruise_summer_ind));
[ count_mdate_mat_su, count_y_mat_su, count_yearlist_su, count_yd_su ] = timeseries2ydmat( count_mdate_su , count_var2plot_su );
[ count_xmean_su, count_xstd_su ] = smoothed_climatology( count_y_mat_su , 10);
%plot
nexttile
plot(count_yd_su, count_y_mat_su, '.', 'MarkerSize', 10)
datetick
legend(num2str(count_yearlist_su'), 'Location', 'northeast')
ylim([0 1.4])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Summer')
%fall
%new climatology function for cruise_fall_ind
count_var2plot_f = classcount_opt_adhoc_merge.(classlabel)(cruise_fall_ind)./meta_data.ml_analyzed(cruise_fall_ind);
count_mdate_f = datenum(meta_data.datetime(cruise_fall_ind));
[ count_mdate_mat_f, count_y_mat_f, count_yearlist_f, count_yd_f ] = timeseries2ydmat( count_mdate_f , count_var2plot_f );
[ count_xmean_f, count_xstd_f ] = smoothed_climatology( count_y_mat_f , 10);
%plot
nexttile
plot(count_yd_f, count_y_mat_f, '.', 'MarkerSize', 10)
datetick
legend(num2str(count_yearlist_f'), 'Location', 'northeast')
ylim([0 1.4])
ylabel(['\it' class2use_label '\rm Count (ml^({-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Fall')
%upperslope
%new climatology function for cruise_spring_ind
count_var2plot_sp = classcount_opt_adhoc_merge.(classlabel)(cruise_spring_ind)./meta_data.ml_analyzed(cruise_spring_ind);
count_mdate_sp = datenum(meta_data.datetime(cruise_spring_ind));
[ count_mdate_mat_sp, count_y_mat_sp, count_yearlist_sp, count_yd_sp ] = timeseries2ydmat( count_mdate_sp , count_var2plot_sp );
[ count_xmean_sp, count_xstd_sp ] = smoothed_climatology( count_y_mat_sp , 10);
%plot
nexttile
plot(count_yd_sp, count_y_mat_sp, '.', 'MarkerSize', 10)
datetick
legend(num2str(count_yearlist_sp'), 'Location', 'northeast')
ylim([0 1.4])
ylabel(['\it' class2use_label '\rm Count (ml^({-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Spring')

%%
%cnn data with each year as a separate colored dot + mean/std lines

%climatology function (included above)
    %count_var2plot = classcount_opt_adhoc_merge.(classlabel)./meta_data.ml_analyzed;
    %count_mdate = datenum(meta_data.datetime);
    %[ count_mdate_mat, count_y_mat, count_yearlist, count_yd ] = timeseries2ydmat( count_mdate, count_var2plot );

%create plot
figure
plot(count_yd, count_y_mat, '.')

%mean and std function
[ count_xmean, count_xstd ] = smoothed_climatology( count_y_mat , 10);

%add on mean and std
hold on
plot(count_yd, count_xmean, 'k-','linewidth', 3)
plot(count_yd, (count_xmean+count_xstd), 'k--', 'linewidth', 2)
plot(count_yd, (count_xmean-count_xstd), 'k--', 'linewidth', 2)

%add graph details
datetick
xlim([0 366])
legend(num2str(count_yearlist'), 'Location', 'eastoutside')
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14);
xlabel('Month', 'FontSize', 14)
ylim([0 inf])

%%
%create same plot as above but tiledlayout(2,2) for each shelf region
figure
tiledlayout(2,2)
%innershelf
%plot
nexttile
plot(count_yd_i, count_y_mat_i, '.', 'MarkerSize', 10)
hold on
plot(count_yd_i, count_xmean_i, 'k-','linewidth', 2)
plot(count_yd_i, (count_xmean_i+count_xstd_i), 'k--', 'linewidth', 2)
plot(count_yd_i, (count_xmean_i-count_xstd_i), 'k--', 'linewidth', 1)
datetick
legend(num2str(count_yearlist_i'), 'Location', 'northeast')
ylim([0 1.8])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Inner Shelf')
%midshelf
nexttile
plot(count_yd_m, count_y_mat_m, '.', 'MarkerSize', 10)
hold on
plot(count_yd_m, count_xmean_m, 'k-','linewidth', 2)
plot(count_yd_m, (count_xmean_m+count_xstd_m), 'k--', 'linewidth', 1)
plot(count_yd_m, (count_xmean_m-count_xstd_m), 'k--', 'linewidth', 1)
datetick
legend(num2str(count_yearlist_m'), 'Location', 'northeast')
ylim([0 1.8])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Mid Shelf')
%outershelf
nexttile
plot(count_yd_o, count_y_mat_o, '.', 'MarkerSize', 10)
hold on
plot(count_yd_o, count_xmean_o, 'k-','linewidth', 2)
plot(count_yd_o, (count_xmean_o+count_xstd_o), 'k--', 'linewidth', 1)
plot(count_yd_o, (count_xmean_o-count_xstd_o), 'k--', 'linewidth', 1)
datetick
legend(num2str(count_yearlist_o'), 'Location', 'northeast')
ylim([0 1.8])
ylabel(['\it' class2use_label '\rm Count (ml^({-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Outer Shelf')
%upperslope
nexttile
plot(count_yd_u, count_y_mat_u, '.', 'MarkerSize', 10)
hold on
plot(count_yd_u, count_xmean_u.^tr_val, 'k-','linewidth', 2)
plot(count_yd_u, (count_xmean_u+count_xstd_u), 'k--', 'linewidth', 1)
plot(count_yd_u, (count_xmean_u-count_xstd_u), 'k--', 'linewidth', 1)
datetick
legend(num2str(count_yearlist_u'), 'Location', 'northeast')
ylim([0 1.8])
ylabel(['\it' class2use_label '\rm Count (ml^({-1})'], 'FontSize', 14)
xlabel('Month', 'FontSize', 14)
title('Upper Slope')
