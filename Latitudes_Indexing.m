%indexing for latitudes to separate into inner, mid, outer shelf, upper slope 
%for ciliate counts/carbon

%loading in data
load('/Volumes/IFCB_products/NESLTER_transect/summary/carbon_group_class_withTS.mat');
load('/Volumes/IFCB_products/NESLTER_transect/summary/count_group_class_withTS.mat');
load('count_manual_current_jill_NESLTER.mat');
%uwindall = find(strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);
%uwind = find(strcmp(meta_data.cruise, cruiseStr) & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);

%specify transformation value
c_tr_val = 4;

%specify class2use
class2use_label = 'Laboea strobila';

%%
%indexing latitudes
uwind_innershelf_ind = find(meta_data.latitude >= 40.98 & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);
uwind_midshelf_ind = find(meta_data.latitude >= 40.327 & meta_data.latitude <= 40.98 & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);
uwind_outershelf_ind = find(meta_data.latitude >= 39.923 & meta_data.latitude <= 40.327 & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);
uwind_upperslope_ind = find(meta_data.latitude <= 39.923 & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);

% innershelf_lat = 40.98;
% midshelf_minlat = 40.98;
% midshelf_maxlat  = 40.327;
% outershelf_minlat = 40.327;
% outershelf_maxlat = 39.923;
% upperslope_lat = 39.923;

%%
%innershelf
count_var2plot_i = classcount_opt_adhoc_merge.Laboea_strobila(uwind_innershelf_ind).^(1/c_tr_val)./meta_data.ml_analyzed(uwind_innershelf_ind).^(1/c_tr_val);
count_mdate_i = datenum(meta_data.datetime(uwind_innershelf_ind));
[ count_mdate_mat_i, count_y_mat_i, count_yearlist_i, count_yd_i ] = timeseries2ydmat( count_mdate_i , count_var2plot_i );
[ count_xmean_i, count_xstd_i ] = smoothed_climatology( count_y_mat_i.^(1/c_tr_val) , 10);

figure
plot(count_yd_i, count_y_mat_i, '.', "MarkerSize", 10)
hold on
plot(count_yd_i, count_xmean_i.^c_tr_val, 'k-','linewidth', 2)
plot(count_yd_i, (count_xmean_i+count_xstd_i).^c_tr_val, 'k--', 'linewidth', 1)
plot(count_yd_i, (count_xmean_i-count_xstd_i).^c_tr_val, 'k--', 'linewidth', 1)
datetick
xlim([0 366])
ylim([0 1.2])
%legend(num2str(count_yearlist_i'), "Location", "eastoutside")
legend(num2str(count_yearlist_i'), "Location", "northeast")
ylabel({'\it Laboea strobila \rm';'Count (ml^{-1})'}, 'FontSize', 14);xlabel('Month', 'FontSize', 14)
%title("Cruise CNN Count Seasonality (4th root) for Inner Shelf")

%%
%midshelf
count_var2plot_m = classcount_opt_adhoc_merge.Laboea_strobila(uwind_midshelf_ind).^(1/c_tr_val)./meta_data.ml_analyzed(uwind_midshelf_ind).^(1/c_tr_val);
count_mdate_m = datenum(meta_data.datetime(uwind_midshelf_ind));
[ count_mdate_mat_m, count_y_mat_m, count_yearlist_m, count_yd_m ] = timeseries2ydmat( count_mdate_m , count_var2plot_m );
[ count_xmean_m, count_xstd_m ] = smoothed_climatology( count_y_mat_m.^(1/c_tr_val) , 10);

figure
plot(count_yd_m, count_y_mat_m, '.', "MarkerSize", 10)
hold on
plot(count_yd_m, count_xmean_m.^c_tr_val, 'k-','linewidth', 2)
plot(count_yd_m, (count_xmean_m+count_xstd_m).^c_tr_val, 'k--', 'linewidth', 1)
plot(count_yd_m, (count_xmean_m-count_xstd_m).^c_tr_val, 'k--', 'linewidth', 1)
datetick
xlim([0 366])
ylim([0 1.2])
legend(num2str(count_yearlist_i'), "Location", "northeast")
ylabel({'\it Laboea strobila \rm';'Count (ml^{-1})'}, 'FontSize', 14);xlabel('Month', 'FontSize', 14)
%title("Cruise CNN Count Seasonality (4th root) for Mid-Shelf")
%%
%outershelf
count_var2plot_o = classcount_opt_adhoc_merge.Laboea_strobila(uwind_outershelf_ind).^(1/c_tr_val)./meta_data.ml_analyzed(uwind_outershelf_ind).^(1/c_tr_val);
count_mdate_o = datenum(meta_data.datetime(uwind_outershelf_ind));
[ count_mdate_mat_o, count_y_mat_o, count_yearlist_o, count_yd_o ] = timeseries2ydmat( count_mdate_o , count_var2plot_o );
[ count_xmean_o, count_xstd_o ] = smoothed_climatology( count_y_mat_o.^(1/c_tr_val) , 10);

figure
plot(count_yd_o, count_y_mat_o, '.', 'MarkerSize', 10)
hold on
plot(count_yd_o, count_xmean_o.^c_tr_val, 'k-','linewidth', 2)
plot(count_yd_o, (count_xmean_o+count_xstd_o).^c_tr_val, 'k--', 'linewidth', 1)
plot(count_yd_o, (count_xmean_o-count_xstd_o).^c_tr_val, 'k--', 'linewidth', 1)
datetick
xlim([0 366])
ylim([0 1.2])
legend(num2str(count_yearlist_o'), "Location", "northeast")
ylabel({'\it Laboea strobila \rm';'Count (ml^{-1})'}, 'FontSize', 14);xlabel('Month', 'FontSize', 14)
%title("Cruise CNN Count Seasonality (4th root) for Outer Shelf")

%%
%upperslope
count_var2plot_u = classcount_opt_adhoc_merge.Laboea_strobila(uwind_upperslope_ind).^(1/c_tr_val)./meta_data.ml_analyzed(uwind_upperslope_ind).^(1/c_tr_val);
count_mdate_u = datenum(meta_data.datetime(uwind_upperslope_ind));
[ count_mdate_mat_u, count_y_mat_u, count_yearlist_u, count_yd_u ] = timeseries2ydmat( count_mdate_u , count_var2plot_u );
[ count_xmean_u, count_xstd_u ] = smoothed_climatology( count_y_mat_u.^(1/c_tr_val) , 10);

figure
plot(count_yd_u, count_y_mat_u, '.', "MarkerSize", 10)
hold on
plot(count_yd_u, count_xmean_u.^c_tr_val, 'k-','linewidth', 2)
plot(count_yd_u, (count_xmean_u+count_xstd_u).^c_tr_val, 'k--', 'linewidth', 1)
plot(count_yd_u, (count_xmean_u-count_xstd_u).^c_tr_val, 'k--', 'linewidth', 1)
datetick
xlim([0 366])
ylim([0 1.2])
legend(num2str(count_yearlist_u'), "Location", "northeast")
ylabel({'\it Laboea strobila \rm';'Count (ml^{-1})'}, 'FontSize', 14);
xlabel('Month', 'FontSize', 14)
%title("Cruise CNN Count Seasonality (4th root) for Upper Slope")