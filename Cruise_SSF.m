%%
%loading data
%loading data
%load('/Volumes/IFCB_products/NESLTER_transect/summary/carbon_group_class_withTS.mat')
load('/Volumes/IFCB_products/NESLTER_transect/summary/count_group_class.mat')
load('count_manual_current_jill_NESLTER.mat');
load('/Volumes/IFCB_products/NESLTER_transect/summary/carbon_group_class.mat')
uwindall = find(strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);
c_tr_val = 4;

%%
%cases for cruiseStr
cruiseStr = 'AR34B';

switch cruiseStr
    case "AR34A"
        cruiseStr_label = "AR34A";
    case "AR34B"
        cruiseStr_label = "AR34B";
    case "AR66B"
        cruiseStr_label = "AR66B";
    case "EN644"
        cruiseStr_label = "EN644";
    case "EN687"
        cruiseStr_label = "EN687";
end

uwind = find(strcmp(meta_data.cruise, cruiseStr) & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);

%%
%cases for cruise
c_class2plot = "Laboea strobila";

switch c_class2plot
    case "Balanion"
        cruise_classlabel = "Balanion";
        class2use_label = "Balanion";
    case "Dictyocysta"
        cruise_classlabel = "Dictyocysta";
        class2use_label = "Dictyocysta";
    case "Didinum"
        cruise_classlabel = "Didinum";
        class2use_label = "Didinum";
    case "Euplotes"
        cruise_classlabel = "Euplotes";
        class2use_label = "Euplotes";
    case "Euplotes morphotype 1"
        cruise_classlabel = "Euplotes_morphotype1";
        class2use_label = "Euplotes morphotype 1";
    case "Eutintinnus"
        cruise_classlabel = "Eutintinnus";
        class2use_label = "Eutintinnus";
    case "Favella"
        cruise_classlabel = "Favella";
        class2use_label = "Favella";
    case "Laboea strobila"
        cruise_classlabel = "Laboea_strobila";
        class2use_label = "Laboea strobila";
    case "Leegaardiella ovalis"
        cruise_classlabel = "Leegaardiella_ovalis";
        class2use_label = "Leegaardiella ovalis";
    case "Mesodinium"
        cruise_classlabel = "Mesodinium";
        class2use_label = "Mesodinium";
    case "Pleuronema"
        cruise_classlabel = "Pleuronema";
        class2use_label = "Pleuronema";
    case "Stenosemella morphotype 1"
        cruise_classlabel = "Stenosemella_morphotype1";
        class2use_label = "Stenosemella morphotype 1";
    case "Stenosemella pacifica"
        cruise_classlabel = "Stenosemella_pacifica";
        class2use_label = "Stenosemella pacifica";
    case "Strombidium capitatum"
        cruise_classlabel = "Strombidium_capitatum";
        class2use_label = "Strombidium capitatum";
    case "Strombidium conicum"
        cruise_classlabel = "Strombidium_conicum";
        class2use_label = "Strombidium conicum";
    case "Strombidium inclinatum"
        cruise_classlabel = "Strombidium_inclinatum";
        class2use_label = "Strombidium inclinatum";
    case "Strombidium morphotype 1"
        cruise_classlabel = "Strombidium_morphotype1";
        class2use_label = "Strombidium morphotype 1";
    case "Strombidium morphotype 2"
        cruise_classlabel = "Strombidium_morphotype2";
        class2use_label = "Strombidium morphotype 2";
    case "Strombidium tintinnodes"
        cruise_classlabel = "Strombidium_tintinnodes";
        class2use_label = "Strombidium tintinnodes";
    case "Strombidium wulffi"
        cruise_classlabel = "Strombidium_wulffi";
        class2use_label = "Strombidium wulffi";
    case "Tiarina fusus"
        cruise_classlabel = "Tiarina_fusus";
        class2use_label = "Tiarina fusus";
    case "Tintinnia"
        cruise_classlabel = "Tintinnia";
        class2use_label = "Tintinnia";
    case "Tintinnidium mucicola"
        cruise_classlabel = "Tintinnidium_mucicola";
        class2use_label = "Tintinnidium mucicola";
    case "Tintinnopsis"
        cruise_classlabel = "Tintinnopsis";
        class2use_label = "Tintinnopsis";
    case "Tontonia appendiculariformis"
        cruise_classlabel = "Tontonia_appendiculariformis";
        class2use_label = "Tontonia appendiculariformis";
    case "Paratontonia gracillima"
        cruise_classlabel = "Paratontonia_gracillima";
        class2use_label = "Paratontonia gracillima";
    case "Ciliophora"
        cruise_classlabel = "Ciliophora";
        class2use_label = "Ciliophora";
end

%%
%tiled graphs between MVCO and cruise data

%%
%CNN graph over years
figure
tiledlayout(1,2)

%count
nexttile
plot(meta_data.datetime(uwindall), classcount_opt_adhoc_merge.(cruise_classlabel)(uwindall).^(1/c_tr_val)./meta_data.ml_analyzed(uwindall).^(1/c_tr_val))
%plot(meta_data.datetime(uwindall), classC_opt_adhoc_merge.(cruise_classlabel)(uwindall)./meta_data.ml_analyzed(uwindall)/1000)
ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
hold on
datetime_bin_c = datetime(matdate_cruise, "ConvertFrom", "datenum");
class_ind_c = strcmp(class2use_label, class2use_cruise);
plot(datetime_bin_c, (classcount_cruise(:,class_ind_c)./ml_analyzed_cruise), "r*")
xlabel("Year", "FontSize", 14)
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], "FontSize", 14)
legend("CNN Auto Classifier", "Manual Annotations", "Location", "northoutside")
title("Cruise CNN/Manual * Count (4th root)")

%carbon
nexttile
plot(meta_data.datetime(uwindall), classC_opt_adhoc_merge.(cruise_classlabel)(uwindall).^(1/c_tr_val)./meta_data.ml_analyzed(uwindall).^(1/c_tr_val))
ylabel(['\it' class2use_label '\rm Carbon (mg^{-1})'], 'FontSize', 14);
xlabel('Year', 'FontSize', 14)
title("Cruise CNN Carbon (4th root)")

%%
%lines across as months
figure
tiledlayout(1,2)

%count
nexttile
count_var2plot = classcount_opt_adhoc_merge.(cruise_classlabel).^(1/c_tr_val)./meta_data.ml_analyzed.^(1/c_tr_val);
count_mdate = datenum(meta_data.datetime);
[ count_mdate_mat, count_y_mat, count_yearlist, count_yd ] = timeseries2ydmat( count_mdate, count_var2plot );
plot(count_yd, count_y_mat, ".-")
datetick
legend(num2str(count_yearlist'), "Location", "eastoutside")
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14);
xlabel('Month', 'FontSize', 14)
title("Cruise CNN Count Line As Years (4th root)")

%carbon
nexttile
carbon_var2plot = classC_opt_adhoc_merge.(cruise_classlabel).^(1/c_tr_val)./meta_data.ml_analyzed.^(1/c_tr_val);
carbon_mdate = datenum(meta_data.datetime);
[ carbon_mdate_mat, carbon_y_mat, carbon_yearlist, carbon_yd ] = timeseries2ydmat( carbon_mdate, carbon_var2plot );
plot(carbon_yd, carbon_y_mat, ".-")
datetick
legend(num2str(carbon_yearlist'), "Location", "eastoutside")
ylabel(['\it' class2use_label '\rm Carbon (mg^{-1})'], 'FontSize', 14);
xlabel('Month', 'FontSize', 14)
title("Cruise CNN Carbon Line As Years (4th root)")

%%
%climatology
figure
tiledlayout(1,2)

%count
nexttile
[ count_xmean, count_xstd ] = smoothed_climatology( count_y_mat.^(1/c_tr_val) , 10);
plot(count_yd, count_y_mat, '.')
hold on
plot(count_yd, count_xmean.^c_tr_val, 'k-','linewidth', 3)
plot(count_yd, (count_xmean+count_xstd).^c_tr_val, 'k--', 'linewidth', 2)
plot(count_yd, (count_xmean-count_xstd).^c_tr_val, 'k--', 'linewidth', 2)
datetick
xlim([0 366])
legend(num2str(count_yearlist'), "Location", "eastoutside")
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14);
xlabel('Month', 'FontSize', 14)
title("Cruise CNN Count Seasonality (4th root)")

%carbon
nexttile
[ carbon_xmean, carbon_xstd ] = smoothed_climatology( carbon_y_mat.^(1/c_tr_val) , 10);
plot(carbon_yd, carbon_y_mat, '.')
hold on
plot(carbon_yd, carbon_xmean.^c_tr_val, 'k-','linewidth', 3)
plot(carbon_yd, (carbon_xmean+carbon_xstd).^c_tr_val, 'k--', 'linewidth', 2)
plot(carbon_yd, (carbon_xmean-carbon_xstd).^c_tr_val, 'k--', 'linewidth', 2)
datetick
xlim([0 366])
legend(num2str(carbon_yearlist'), "Location", "eastoutside")
ylabel(['\it' class2use_label '\rm Carbon (mg^{-1})'], 'FontSize', 14);
xlabel('Month', 'FontSize', 14)
title("Cruise CNN Carbon Seasonality (4th root)")

%%
% %environmental MVCO and cruise graphs
% %%
% %salinity and temp over time
% figure
% plot(meta_data.datetime(uwindall), meta_data.temperature(uwindall), '.')
% hold on
% plot(meta_data.datetime(uwindall), meta_data.salinity(uwindall), '.')
% title('Cruise')
% ylim([-5 40])
% 
% %%
% %beam temp/salinity versus ciliate count/carbon
% figure
% tiledlayout(1,2)
% 
% %cruise
% %temp
% nexttile
% plot(meta_data.temperature(uwindall), classC_opt_adhoc_merge.(cruise_classlabel)(uwindall), '.');
% xlabel("Temperature (°C)", "FontSize", 14)
% ylabel("Ciliate Carbon", "FontSize", 14)
% title("Cruise Temp")
% %salinity
% nexttile
% plot(meta_data.salinity(uwindall), classC_opt_adhoc_merge.(cruise_classlabel)(uwindall), '.');
% xlabel("Temperature (°C)", "FontSize", 14)
% ylabel("Ciliate Carbon", "FontSize", 14)
% title("Cruise Salinity")
% 
% %%
% %TS plot
% figure
% Z_cruise = classC_opt_adhoc_merge.(cruise_classlabel)(uwind);
% Zind_cruise = find(Z_cruise == 0);
% scatter(meta_data.salinity(uwind(Zind_cruise)), meta_data.temperature(uwind(Zind_cruise)), 20, Z_cruise(Zind_cruise));
% hold on
% Zind_cruise = find(Z_cruise);
% scatter(meta_data.salinity(uwind(Zind_cruise)), meta_data.temperature(uwind(Zind_cruise)), 20, Z_cruise(Zind_cruise), 'filled');
% xlim([30 37])
% colorbar
% set(gca,'ColorScale','log')
% %caxis([0 1e5])
% 
% %%
% %mvco temp ciliate count
% temp_m = cnn_env.Beam_temperature_corrected;
% ciliate_bxp_m = (cnn_env.(cnn_mvco_classlabel)./cnn_env.ml_analyzed).^(1/4);
% 
% %nbins_m = 7;
% bins = 0:2:22;
% [temp_discrete_m, e_m] = discretize(temp_m, bins);
% %[temp_discrete_m, e_m] = discretize(temp_m, nbins_m);
% 
% % binwidth_m = e_m(2) - e_m(1) - 0.0001;
% % 
% % %rightedges_m = e_m(1:nbins_m) + binwidth_m;
% % 
% % rightedgelabels_m = arrayfun(@num2str, rightedges_m, 'UniformOutput', 0);
% % leftedgelabels_m = arrayfun(@num2str, e_m(1:nbins_m), 'UniformOutput', 0);
% 
% %labels_m = leftedgelabels_m + "-" + rightedgelabels_m;
% %labels_m = num2str((1:2:21)');
% labels = num2str(mean([bins(1:2:end-1);bins(2:2:end)]));
% figure
% %boxplot(ciliate_bxp_m, temp_discrete_m);
% boxplot(ciliate_bxp_m, temp_discrete_m, 'Labels', labels_m);
% ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
% xlabel("Beam Temperature Corrected (°C)", "FontSize", 14)
% 
% %%
% %boxplot cruise temp ciliate C
% temp_c = meta_data.temperature(uwindall);
% ciliate_bxp_c = classC_opt_adhoc_merge.(cruise_classlabel)(uwindall);
% 
% nbins_c = 7;
% 
% [temp_discrete_c, e_c] = discretize(temp_c, nbins_c);
% 
% binwidth_c = e_c(2) - e_c(1) - 0.0001;
% 
% rightedges_c = e_c(1:nbins_c) + binwidth_c;
% 
% rightedgelabels_c = arrayfun(@num2str, rightedges_c, 'UniformOutput', 0);
% leftedgelabels_c = arrayfun(@num2str, e_c(1:nbins_c), 'UniformOutput', 0);
% 
% labels_c = leftedgelabels_c + "-" + rightedgelabels_c;
% 
% figure
% boxplot(ciliate_bxp_c, temp_discrete_c, 'Labels', labels_c)
% ylabel(['\it' class2use_label '\rm Carbon '], "FontSize", 14)
% xlabel("Temperature (°C)", "FontSize", 14)
% 
% %%
% %boxplot with lats & ciliate c
% lat_c = meta_data.latitude(uwindall);
% %ciliate_bxp_c
% 
% nbins_lat_c = 4;
% [lat_discrete_c, e_lat_c] = discretize(lat_c, nbins_lat_c);
% binwidth_lat_c = e_lat_c(2) - e_lat_c(1) - 0.0001;
% rightedges_lat_c = e_lat_c(1:nbins_lat_c) + binwidth_lat_c;
% rightedgelabels_lat_c = arrayfun(@num2str, rightedges_lat_c, 'UniformOutput', 0);
% leftedgelabels_lat_c = arrayfun(@num2str, e_lat_c(1:nbins_lat_c), 'UniformOutput', 0);
% 
% labels_lat_c = leftedgelabels_lat_c + "-" + rightedgelabels_lat_c;
% 
% figure
% boxplot(ciliate_bxp_c, lat_discrete_c, 'Labels', labels_lat_c)
% ylabel(['\it' class2use_label '\rm Carbon '], "FontSize", 14)
% xlabel("Latitude", "FontSize", 14)
% %%
% %and boxplot with temp and lats
% figure
% boxplot(temp_c, lat_discrete_c, 'Labels', labels_lat_c)
% 
% %%
% % %%
% % %shelf latitudes and temperature
% % innershelf_lat = 40.98;
% % midshelf_minlat = 40.98;
% % midshelf_maxlat  = 40.327;
% % outershelf_minlat = 40.327;
% % outershelf_maxlat = 39.923;
% % upperslope_lat = 39.923;
% % 
% % % metaT.longitude >= minlon & metaT.longitude <= maxlon & ...
% % %       metaT.latitude >= L11minlat & metaT.latitude <= L11maxlat
% % 
% % midshelf = meta_data.latitude(uwindall) >= midshelf_minlat & meta_data.latitude(uwindall) <= midshelf_maxlat;
% % outershelf = meta_data.latitude(uwindall) >= outershelf_minlat & meta_data.latitude(uwindall) <= outershelf_maxlat;
% % % upperslope = 

