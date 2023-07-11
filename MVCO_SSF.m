%%
%loading data
%cnn_mvco = readtable('/Users/jillianpaquette/Desktop/WHOI Work/count_by_class_time_series_CNN_daily_20220622.csv');
A = load('/Volumes/IFCB_products/MVCO/summary_v4/count_group_class.mat');
load("count_manual_current_jill_MVCO.mat")
load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat')
B = load('/Volumes/IFCB_products/MVCO/summary_v4/carbon_group_class.mat');

%%
%count and env data combine
count_mvco_ttable_full = table2timetable(A.classcount_opt_adhoc_merge,'rowtimes', A.meta_data.datetime);
count_mvco_ttable_full.ml_analyzed = A.meta_data.ml_analyzed;
count_mvco_ttable_full.pid = [];    
count_mvco_ttable = retime(count_mvco_ttable_full, 'daily', 'sum');     
count_mvco_ttable.Time = dateshift(count_mvco_ttable.Time, 'start', 'day');

%cnn_mvco_ttable = table2timetable(cnn_mvco);
env_mvco_ttable = table2timetable(MVCO_Daily);

count_env = synchronize(count_mvco_ttable, env_mvco_ttable, 'daily');

MVCO_Env_Table.time_local = dateshift(MVCO_Env_Table.time_local, 'start', 'day');
mvco_env_daily = retime(MVCO_Env_Table, 'daily', 'mean');
mvco_env_daily.time_local.TimeZone = char;
count_env = retime(count_env, 'daily', 'mean');
count_env = synchronize(count_env, mvco_env_daily, 'daily');

%carbon and env data combine
carbon_mvco_ttable_full = table2timetable(B.classC_opt_adhoc_merge, 'rowtimes', B.meta_data.datetime);
carbon_mvco_ttable_full.ml_analyzed = B.meta_data.ml_analyzed;
carbon_mvco_ttable_full.pid = [];
carbon_mvco_ttable = retime(carbon_mvco_ttable_full, 'daily', 'sum');
carbon_mvco_ttable.Time = dateshift(carbon_mvco_ttable.Time, 'start', 'day');

carbon_env = synchronize(carbon_mvco_ttable, env_mvco_ttable, 'daily');
carbon_env = retime(carbon_env, 'daily', 'mean');
carbon_env = synchronize(carbon_env, mvco_env_daily, 'daily');

tr_val = 4;

%%
class2plot_list =  ["Balanion" "Dictyocysta" "Didinium" ...
    "Euplotes" "Euplotes morphotype 1" "Eutintinnus" "Favella" "Laboea strobila" "Leegaardiella ovalis" ...
    "Mesodinium" "Pleuronema" "Stenosemella morphotype 1" "Stenosemella pacifica" ...
    "Strombidium capitatum" "Strombidium conicum" "Strombidium inclinatum" ...
    "Strombidium morphotype 1" "Strombidium morphotype 2" "Strombidium tintinnodes" ...
    "Strombidium wulffi" "Tiarina fusus" "Tintinnina" "Tintinnidium mucicola" ...
    "Tintinnopsis" "Tontonia appendiculariformis" "Paratontonia gracillima" "Ciliophora"];

%%
%ciliate variable to change
%cases for CNN 
for pagecount = 1:length(class2plot_list)
    m_class2plot = class2plot_list(pagecount);
    %m_class2plot = "Laboea strobila";

    switch m_class2plot
        case "Balanion"
            cnn_mvco_classlabel = "Balanion";
            class2use_label = "Balanion";
            ylim_max = 45;
        case "Ciliophora"
            cnn_mvco_classlabel = "Ciliophora";
            class2use_label = "Ciliophora";
            ylim_max = 80;
        case "Dictyocysta"
            cnn_mvco_classlabel = "Dictyocysta";
            class2use_label = "Dictyocysta";
            ylim_max = 0.3;
        case "Didinium"
            cnn_mvco_classlabel = "Didinium";
            class2use_label = "Didinium";
            ylim_max = 0.45;
        case "Euplotes"
            cnn_mvco_classlabel = "Euplotes";
            class2use_label = "Euplotes";
            ylim_max = 1.6;
        % case "Euplotes morphotype 1"
        %     cnn_mvco_classlabel = "Euplotes_morphotype1";
        %     class2use_label = "Euplotes morphotype1";
        %     ylim_max = 1;
        case "Eutintinnus"
            cnn_mvco_classlabel = "Eutintinnus";
            class2use_label = "Eutintinnus";
            ylim_max = 0.25;
        case "Favella"
            cnn_mvco_classlabel = "Favella";
            class2use_label = "Favella";
            ylim_max = 3;
        case "Laboea strobila"
            cnn_mvco_classlabel = "Laboea_strobila";
            class2use_label = "Laboea strobila";
            ylim_max = 3;
        case "Leegaardiella ovalis"
            cnn_mvco_classlabel = "Leegaardiella_ovalis";
            class2use_label = "Leegaardiella ovalis";
            ylim_max = 4;
        case "Mesodinium"
            cnn_mvco_classlabel = "Mesodinium";
            class2use_label = "Mesodinium";
            ylim_max = 20;
        case "Pleuronema"
            cnn_mvco_classlabel = "Pleuronema";
            class2use_label = "Pleuronema";
            ylim_max = 1;
        % case "Stenosemella morphotype 1"
        %     cnn_mvco_classlabel = "Stenosemella_morphotype1";
        %     class2use_label = "Stenosemella morphotype1";
        %     ylim_max = 1.6;
        case "Stenosemella pacifica"
            cnn_mvco_classlabel = "Stenosemella_pacifica";
            class2use_label = "Stenosemella pacifica";
            ylim_max = 7;
        case "Pelagostrobilidium"
            cnn_mvco_classlabel = "Pelagostrobilidium";
            class2use_label = "Pelagotrobilidium";
            ylim_max = 1.4;
        case "Strombidium capitatum"
            cnn_mvco_classlabel = "Strombidium_capitatum";
            class2use_label = "Strombidium capitatum";
            ylim_max = 0.25;
        % case "Strombidium conicum"
        %     cnn_mvco_classlabel = "Strombidium_conicum";
        %     class2use_label = "Strombidium conicum";
        %     ylim_max = 1;
        case "Strombidium inclinatum"
            cnn_mvco_classlabel = "Strombidium_inclinatum";
            class2use_label = "Strombidium inclinatum";
            ylim_max = 1.8;
        % case "Strombidium morphotype 1"
        %     cnn_mvco_classlabel = "Strombidium_morphotype1";
        %     class2use_label = "Strombidium morphotype1";
        %     ylim_max = 8;
        % case "Strombidium morphotype 2"
        %     cnn_mvco_classlabel = "Strombidium_morphotype2";
        %     class2use_label = "Strombidium morphotype2";
        %     ylim_max = 4.5;
        case "Strombidium tintinnodes"
            cnn_mvco_classlabel = "Strombidium_tintinnodes";
            class2use_label = "Strombidium tintinnodes";
            ylim_max = 6;
        case "Strombidium wulffi"
            cnn_mvco_classlabel = "Strombidium_wulffi";
            class2use_label = "Strombidium wulffi";
            ylim_max = 2.5;
        case "Tiarina fusus"
            cnn_mvco_classlabel = "Tiarina_fusus";
            class2use_label = "Tiarina fusus";
            ylim_max = 0.3;
        case "Tintinnina"
            cnn_mvco_classlabel = "Tintinnina";
            class2use_label = "Tintinnina";
            ylim_max = 12;
        case "Tintinnidium mucicola"
            cnn_mvco_classlabel = "Tintinnidium_mucicola";
            class2use_label = "Tintinnidium mucicola";
            ylim_max = 0.6;
        case "Tintinnopsis"
            cnn_mvco_classlabel = "Tintinnopsis";
            class2use_label = "Tintinnopsis";
            ylim_max = 35;
        case "Tontonia appendiculariformis"
            cnn_mvco_classlabel = "Tontonia_appendiculariformis";
            class2use_label = "Tontonia appendiculariformis";
            ylim_max = 3;
        case "Paratontonia gracillima"
            cnn_mvco_classlabel = "Paratontonia_gracillima";
            class2use_label = "Paratontonia gracillima";
            ylim_max = 9;
    end

    % %%
    % %CNN graph over years
    % figure(1), clf, set(gcf, 'position', [120 75 1150 600])
    % subplot(2,1,1)
    % %tiledlayout(1,2)
    % 
    % %count
    % %nexttile
    % plot(count_env.days, count_env.(cnn_mvco_classlabel)./count_env.ml_analyzed)
    % hold on
    % datetime_bin_m = datetime(matdate_bin_mvco, "ConvertFrom", "datenum");
    % class_ind_m = strcmp(class2use_label, class2use_mvco);
    % plot(datetime_bin_m, (classcount_bin_mvco(:,class_ind_m)./ml_analyzed_mat_bin_mvco(:,class_ind_m)), "r*")
    % ylim([0 ylim_max])
    % legend("CNN Auto Classifier", "Manual Annotations", "Location", "northoutside")
    % ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], "FontSize", 14)
    % xlabel("Year", "FontSize", 14)
    % title("MVCO CNN/Manual Count")
    % 
    % % %carbon
    % % nexttile
    % % plot(carbon_env.days, carbon_env.(cnn_mvco_classlabel)./carbon_env.ml_analyzed)
    % % ylim([0 inf])
    % % ylabel(['\it' class2use_label '\rm Carbon (mg^{-1})'], "FontSize", 14)
    % % xlabel("Year", "FontSize", 14)
    % % title("MVCO CNN Carbon")
    % 
    % %%
    % %lines across as months
    % figure(1)
    % subplot(2,2,3)
    % %figure
    % %tiledlayout(1,2)
    % 
    % %count
    % %nexttile
    % count_var2plot = count_mvco_ttable_full.(cnn_mvco_classlabel)./count_mvco_ttable_full.ml_analyzed;
    % count_mdate = datenum(count_mvco_ttable_full.Time);
    % [ count_mdate_mat, count_y_mat, count_yearlist, count_yd ] = timeseries2ydmat( count_mdate, count_var2plot );
    % plot(count_yd, count_y_mat, ".-")
    % datetick
    % legend(num2str(count_yearlist'), "Location", "eastoutside")
    % ylim([0 inf])
    % ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14);
    % xlabel('Month', 'FontSize', 14)
    % title("MVCO CNN Count Line As Years")
    % 
    % % %carbon
    % % nexttile
    % % carbon_var2plot = carbon_mvco_ttable_full.(cnn_mvco_classlabel)./carbon_mvco_ttable_full.ml_analyzed;
    % % carbon_mdate = datenum(carbon_mvco_ttable_full.Time);
    % % [ carbon_mdate_mat, carbon_y_mat, carbon_yearlist, carbon_yd ] = timeseries2ydmat( carbon_mdate, carbon_var2plot );
    % % plot(carbon_yd, carbon_y_mat, ".-")
    % % datetick
    % % legend(num2str(carbon_yearlist'), "Location", "eastoutside")
    % % ylim([0 inf])
    % % ylabel(['\it' class2use_label '\rm Carbon (mg^{-1})'], 'FontSize', 14);
    % % xlabel('Month', 'FontSize', 14)
    % % title("MVCO CNN Carbon Line As Years")
    % 
    % %%
    % %climatology
    % figure(1)
    % subplot(2,2,4)
    % %figure
    % %tiledlayout(1,2)
    % 
    % %count
    % %nexttile
    [ count_xmean, count_xstd ] = smoothed_climatology( count_y_mat.^(1/tr_val) , 10);
    plot(count_yd, count_y_mat, '.')
    hold on
    plot(count_yd, count_xmean.^tr_val, 'k-','linewidth', 3)
    plot(count_yd, (count_xmean+count_xstd).^tr_val, 'k--', 'linewidth', 2)
    plot(count_yd, (count_xmean-count_xstd).^tr_val, 'k--', 'linewidth', 2)
    datetick
    xlim([0 366])
    legend(num2str(count_yearlist'), "Location", "northwest")
    ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14);
    xlabel('Month', 'FontSize', 14)
    ylim([0 inf])
    % title("MVCO CNN Count Seasonality (4th root)")
    % 
    % % %carbon
    % % nexttile
    % % [ carbon_xmean, carbon_xstd ] = smoothed_climatology( carbon_y_mat.^(1/tr_val) , 10);
    % % plot(carbon_yd, carbon_y_mat, '.')
    % % hold on
    % % plot(carbon_yd, carbon_xmean.^tr_val, 'k-','linewidth', 3)
    % % plot(carbon_yd, (carbon_xmean+carbon_xstd).^tr_val, 'k--', 'linewidth', 2)
    % % plot(carbon_yd, (carbon_xmean-carbon_xstd).^tr_val, 'k--', 'linewidth', 2)
    % % datetick
    % % xlim([0 366])
    % % legend(num2str(carbon_yearlist'), "Location", "eastoutside")
    % % ylim([0 inf])
    % % ylabel(['\it' class2use_label '\rm Carbon (mg^{-1})'], 'FontSize', 14);
    % % xlabel('Month', 'FontSize', 14)
    % % title("MVCO CNN Carbon Seasonality (4th root)")
    % 
    %%
    %salinity and temp over time
    figure
    yyaxis left
    plot(count_env.days, count_env.Beam_temperature_corrected, '.')
    ylabel("Beam Temperature Corrected (°C)", "FontSize", 14)
    yyaxis right
    plot(count_env.days, count_env.salinity_beam, '.')
    ylabel("Salinity (ppt)", "FontSize", 14)
    %title('MVCO Salinity and Temp over Time')
    %legend('Temperature (°C)', 'Salinity (ppt)', 'Location', 'northoutside')
    xlabel('Year', 'FontSize', 14)

    %%
    %beam temp/salinity versus ciliate count
    figure(2), clf, set(gcf, 'position', [120 75 1150 600])
    subplot(2,2,1)
    %tiledlayout(2,2)
    
    %count
    %temp
    %nexttile
    plot(count_env.Beam_temperature_corrected, count_env.(cnn_mvco_classlabel)./count_env.ml_analyzed, '.');
    ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
    xlabel("Beam Temperature Corrected (°C)", "FontSize", 14)
    title("MVCO Temperature and Count")
    ylim([0 inf])
    %salinity
    subplot(2,2,2)
    %nexttile
    plot(count_env.salinity_beam, count_env.(cnn_mvco_classlabel)./count_env.ml_analyzed, '.');
    ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
    xlabel("Salinity (ppt)", "FontSize", 14)
    title("MVCO Salinity and Count")
    ylim([0 inf])
    
    % %carbon
    % %temp
    % nexttile
    % plot(carbon_env.Beam_temperature_corrected, carbon_env.(cnn_mvco_classlabel)./carbon_env.ml_analyzed, '.');
    % ylabel(['\it' class2use_label '\rm (mg^{-1})'], "FontSize", 14)
    % xlabel("Beam Temperature Corrected (°C)", "FontSize", 14)
    % title("MVCO Temperature and Carbon")
    % ylim([0 inf])
    % %salinity
    % nexttile
    % plot(carbon_env.salinity_beam, carbon_env.(cnn_mvco_classlabel)./carbon_env.ml_analyzed, '.');
    % ylabel(['\it' class2use_label '\rm (mg^{-1})'], "FontSize", 14)
    % xlabel("Salinity (ppt)", "FontSize", 14)
    % title("MVCO Salinity and Carbon")
    % ylim([0 inf])
    
    %%
    %TS plot
    
    figure(2)
    subplot(2,2,3)
    %tiledlayout(1,2)
    
    %count
    %nexttile
    Z_count_mvco = count_env.(cnn_mvco_classlabel)./count_env.ml_analyzed;
    scatter(count_env.salinity_beam, count_env.Beam_temperature_corrected, 10, Z_count_mvco);
    hold on
    scatter(count_env.salinity_beam, count_env.Beam_temperature_corrected, 10, Z_count_mvco, 'filled');
    colorbar
    xlim([28 34])
    set(gca,'ColorScale','log')
    xlabel('Salinity (ppt)')
    ylabel('Temperature (°C)')
    title('MVCO TS plot count')
    
    % %carbon
    % nexttile
    % Z_carbon_mvco = carbon_env.(cnn_mvco_classlabel)./carbon_env.ml_analyzed;
    % scatter(carbon_env.salinity_beam, carbon_env.Beam_temperature_corrected, 10, Z_carbon_mvco);
    % hold on
    % scatter(carbon_env.salinity_beam, carbon_env.Beam_temperature_corrected, 10, Z_carbon_mvco, 'filled');
    % colorbar
    % xlim([28 34])
    % set(gca,'ColorScale','log')
    % xlabel('Salinity (ppt)')
    % ylabel('Temperature (°C)')
    % title('MVCO TS plot carbon')
    
    
    %%
    %mvco temp ciliate count
    
    temp_m = count_env.Beam_temperature_corrected;
    ciliate_bxp_m = (count_env.(cnn_mvco_classlabel)./count_env.ml_analyzed).^(1/4);
    
    %nbins_m = 7;
    bins = 0:2:22;
    [temp_discrete_m, e_m] = discretize(temp_m, bins);
    %[temp_discrete_m, e_m] = discretize(temp_m, nbins_m);
    
    % binwidth_m = e_m(2) - e_m(1) - 0.0001;
    % 
    % %rightedges_m = e_m(1:nbins_m) + binwidth_m;
    % 
    % rightedgelabels_m = arrayfun(@num2str, rightedges_m, 'UniformOutput', 0);
    % leftedgelabels_m = arrayfun(@num2str, e_m(1:nbins_m), 'UniformOutput', 0);
    
    %labels_m = leftedgelabels_m + "-" + rightedgelabels_m;
    %labels_m = num2str((1:2:21)');
    labels = num2str(mean([bins(1:2:end-1);bins(2:2:end)]));
    figure(2)
    subplot(2,2,4)
    boxplot(ciliate_bxp_m, temp_discrete_m);
    %boxplot(ciliate_bxp_m, temp_discrete_m, 'Labels', labels_m);
    ylabel(['\it' class2use_label '\rm (ml^{-1})'], "FontSize", 14)
    xlabel("Beam Temperature Corrected (°C)", "FontSize", 14)
    title('MVCO Boxplot temp/count (4th root)')

%%
an = annotation('rectangle', [0 0 1 1], 'color', 'w');
%exportgraphics(figure(1), 'MVCO_All_Cases_Count.pdf', 'append', true)
exportgraphics(figure(2), 'MVCO_Temp_Salinity_andCasesBoxplot.pdf', 'append', true)
%print

end