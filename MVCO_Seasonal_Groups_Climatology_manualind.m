%seasonal groups mvco - smoothed climatologies - testing code from last
%year and making it work with 2023 summary files

%%
%Creating variables
mvco = load('/Volumes/IFCB_products/MVCO/summary_v4/count_group_class.mat');
mvco2 = table2timetable(mvco.classcount_opt_adhoc_merge, 'RowTimes', mvco.meta_data.datetime);
mvco2.ml = mvco.meta_data.ml_analyzed;
mvco2.pid = [];
mvco2(mvco2.ml<0,:) = [];
mvco2 = retime(mvco2, 'daily', 'sum');
mdate = datenum(mvco2.Time);

% group_table = readtable('IFCB_classlist_type_ciliate_namechange.csv');
% [~, ia, ib] = intersect(group_table.CNN_classlist, mvco.classcount_opt_adhoc_merge.Properties.VariableNames);
% ciliate_ind = ib(find(group_table.Ciliate(ia)));
% ciliate_label = mvco.ciliate_label;

%%
%choose transformation value
tr_val = 4;

%%
%ciliate indices
% balanion = mvco2(:, 11)
% ciliophora = mvco2(:, 135)
% dictyocysta = mvco2(:, 43)
% didinium = mvco2(:, 44)
% euplotes = mvco2(:, 56)
% euplotes_m1 = mvco2(:, 57)
% eutintinnus = mvco2(:, 58)
% favella = mvco2(:, 59)
% laboea_strobila = mvco2(:, 72)
% leegaardiella_ovalis = mvco2(:, 74)
% mesodinium = mvco2(:, 79)
% pleuronema = mvco2(:, 88)
% stenosemella_m1 = mvco2(:, 106)
% stenosemella_pacifica = mvco2(:, 107)
% pelagostrobilidium = mvco2(:, 109)
% strombidium_capitatum = mvco2(:, 110)
% strombidium_conicum = mvco2(:, 111)
% strombidium_inclinatum = mvco2(:, 112)
% strombidium_m1 = mvco2(:, 113)
% strombidium_m2 = mvco2(:, 114)
% strombidium_tintinnodes = mvco2(:, 115)
% strombidium_wulffi = mvco2(:, 116)
% tiarina_fusus = mvco2(:, 122)
% tintinnina = mvco2(:, 123)
% tintinnidium_mucicola = mvco2(:, 124)
% tintinnopsis = mvco2(:, 125)
% tontonia_appendiculariformis = mvco2(:, 126)
% paratontonia_gracillima = mvco2(:, 127)

%%
%creating figure of all

% figure, hold on
% for count1 = 1:length(ciliate_ind)
%     tr_val_all = 4;
%     var2plot = mvco2{:, ciliate_ind(count1)}./mvco2.ml;
%     [mdate_mat, y_mat, yearlist, yd] = timeseries2ydmat(mdate, var2plot);
%     [xmean, xstd] = smoothed_climatology(y_mat.^(1/tr_val_all), 10);
%     plot(yd, xmean.^(tr_val_all), '-', 'linewidth', 2)
% end

%plot all classes except ciliophora
figure, hold on
ciliate_to_plot_all = [11 43 44 56 57 58 59 72 74 79 88 106 107 109 110 111 112 ...
    113 114 115 116 122 123 124 125 126 127];
for count_all = ciliate_to_plot_all
    tr_val = 4;
    var2plot = mvco2{:,(count_all)}./mvco2.ml;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val) , 10);
    plot(yd, xmean.^tr_val, '-', 'linewidth', 2)
end

%figure legend and axis adjustments
legend('Balanion', 'Dictyocysta', 'Didinium', 'Euplotes', 'Euplotes morphotype 1', ...
    'Eutintinnus', 'Favella', 'Laboea strobila', 'Leegaardiella ovalis', 'Mesodinium', ...
    'Pleuronema', 'Stenosemella morphotype 1', 'Stenosemella pacifica', 'Pelagostrobilidium', ...
    'Strombidium capitatum', 'Strombidium conicum', 'Strombidium inclinatum', ...
    'Strombidium morphotype 1', 'Strombidium morphotype 2', 'Strombidium tintinnodes', ...
    'Strombidium wulffi', 'Tintinnina', 'Tintinnidium mucicola', 'Tintinnopsis', ...
    'Tontonia appendiculariformis', 'Paratontonia gracillima', ...
    'Location', 'eastoutside', 'Interpreter','none')
%title('All Ciliates CNN Climatology')
%legend(ciliate_label, 'Location', 'eastoutside', 'Interpreter','none')
ylabel('Counts ml^{-1}', 'FontSize', 14)
xlabel('Day of year', 'FontSize', 14)
xlim([0 366])
%colors
numberOfDataSets = length(ciliate_ind);
newDefaultColors = jet(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');

%%
%spring peak, fall peak

% figure, hold on
% ciliate_to_plot_sf = [9 13 20 21 22 23 26];
% for count_sf = ciliate_to_plot_sf
%     var2plot = mvco2{:,ciliate_ind(count_sf)}./mvco2.ml;
%     [mdate_mat, y_mat, yearlist, yd] = timeseries2ydmat(mdate, var2plot);
%     tr_val_sf = 4;
%     [xmean, xstd] = smoothed_climatology(y_mat.^(1/tr_val_sf), 10);
%     plot(yd, xmean.^(tr_val_sf), '-', 'linewidth', 2)
% end    

figure, hold on
ciliate_to_plot_springfall = [72 109 113 114 115 116 123]; 
for count_sprfall = ciliate_to_plot_springfall
    var2plot = mvco2{:,(count_sprfall)}./mvco2.ml;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    tr_val_sf = 4;
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_sf), 10);
    plot(yd, xmean.^tr_val_sf, '-', 'linewidth', 2)
end
numberOfDataSets = count_sprfall;
newDefaultColors = lines(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
legend('Laboea strobila', 'Pelagostrobilidium', 'Strombidium morphotype 1', ...
    'Strombidium morphotype 2', 'Strombidium tintinnodes', 'Strombidium wulffi', 'Tintinnina', ...
    'Location', 'northwest', 'Interpreter', 'none')
%title('Ciliates with CNN spring and fall peaks')
%legend(ciliate_label(ciliate_to_plot_sf), 'Location', 'eastoutside', 'Interpreter','none')
ylabel('Counts ml^{-1}', 'FontSize', 14)
xlabel('Day of year', 'FontSize', 14)
xlim([0 366])

%%
%fall

% ciliate_to_plot_f = [1 4 10 11 16 19 25];
% for count_f = ciliate_to_plot_f
%     var2plot = mvco2{:, ciliate_ind(count_f)}./mvco2.ml;
%     [mdate_mat, y_mat, yearlist, yd] = timeseries2ydmat(mdate, var2plot);
%     tr_val_f = 4;
%     [xmean, xstd] = smoothed_climatology(y_mat.^(1/tr_val_f), 10);
%     plot(yd, xmean.^(tr_val_f), '-', 'linewidth', 2)
% end

figure, hold on
ciliate_to_plot_fall = [11 44 74 79 107 112 124];
for count_fall = ciliate_to_plot_fall
    var2plot = mvco2{:,(count_fall)}./mvco2.ml;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    tr_val_f = 4;
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_f) , 10);
    plot(yd, xmean.^tr_val_f, '-', 'linewidth', 2)
end
numberOfDataSets = count_fall;
newDefaultColors = colorcube(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
legend('Balanion', 'Didinium', 'Leegaardiella ovalis', 'Mesodinium', 'Stenosemella pacifica', ...
    'Strombidium inclinatum', 'Tintinnidium mucicola', 'Location', 'northwest')
%title('Ciliates with CNN fall seasonality')
%legend(ciliate_label(ciliate_to_plot_f), 'Location', 'eastoutside', 'Interpreter', 'none')
ylabel('Counts ml^{-1}', 'FontSize', 14)
xlabel('Day of year', 'FontSize', 14)
xlim([0 366])
