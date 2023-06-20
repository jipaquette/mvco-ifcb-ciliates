%Creating smoothed climatologies means of all ciliate classes

%Creating variables
daily_data = readtable('/Users/jillianpaquette/Desktop/WHOI Work/count_by_class_time_series_CNN_daily_20220622.csv');
group_table = readtable("IFCB_classlist_type.csv");
%28 ciliate classes, not Helico or Strobil m1
[~, ia, ib] = intersect(group_table.CNN_classlist, daily_data.Properties.VariableNames);
ciliate_ind = ib(find(group_table.Ciliate(ia)));
ciliate_label = daily_data.Properties.VariableNames(ciliate_ind);
mdate = datenum(daily_data.datetime);

%Mesodinium and cryptophytes
figure, hold on
var2plot = (daily_data.cryptophyta./daily_data.ml_analyzed)./100;
tr_val_crypto = 4;
[ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
[ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_crypto) , 10);
plot(yd, xmean.^tr_val_crypto, '-', 'linewidth', 2)
var2plot2 = daily_data.Mesodinium./daily_data.ml_analyzed;
tr_val_meso = 4;
[ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot2 );
[ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_meso) , 10);
plot(yd, xmean.^tr_val_meso, '-', 'linewidth', 2)
title("Mesodinium vs Cryptophytes CNN Climatology")
datetick
legend("Cryptophyta (count/100)", "Mesodinium", "Location", "northoutside", "Interpreter", "none")
ylabel("Counts per mL", 'FontSize',14)
xlabel("Month", "FontSize", 14)

%Creating figure of all
figure, hold on
for count1 = 1:length(ciliate_ind)
    tr_val_all = 4;
    var2plot = daily_data{:,ciliate_ind(count1)}./daily_data.ml_analyzed;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_all) , 10);
    % plot(yd, y_mat, '-', 'linewidth', 2)
    plot(yd, xmean.^tr_val_all, '-', 'linewidth', 2)
end

%Colors
numberOfDataSets = length(ciliate_ind);
newDefaultColors = jet(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');

%Figure legend and axis adjustments for 1
legend(ciliate_label, "Location", "eastoutside", "Interpreter","none")
title("All Ciliates CNN Climatology")
datetick
ylabel("Counts per mL", "FontSize", 14)
xlabel("Month", "FontSize", 14)

%Create figures of lowest count ciliates
figure, hold on
% sum(daily_data{:, ciliate_ind}, "omitnan") % use this to figure out
% highest and lowest ciliate counts (EP)
ciliate_to_plot_low = [2 3 4 5 6 12 15 22 24]; % ciliates with sums of less than 10k
for count2 = ciliate_to_plot_low
    var2plot = daily_data{:,ciliate_ind(count2)}./daily_data.ml_analyzed;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    tr_val_low = 4;
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_low) , 10);
    % plot(yd, y_mat, '-', 'linewidth', 2)
    plot(yd, xmean.^tr_val_low, '-', 'linewidth', 2)
end
numberOfDataSets = count2;
newDefaultColors = colorcube(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
legend(ciliate_label(ciliate_to_plot_low), "Location", "eastoutside", "Interpreter","none")
title("All Lowest Count Ciliates CNN Climatology (< 10,000 counts)")
datetick
ylabel("Counts per mL", "FontSize", 14)
xlabel("Month", "FontSize", 14)

%Create figures of highest count ciliates
figure, hold on
% sum(daily_data{:, ciliate_ind}, "omitnan") % use this to figure out
% highest and lowest ciliate counts (EP)
ciliate_to_plot_high = [1 7:11 13 14 16:21 23 25:28]; % ciliates with sums of greater than 10k
for count3 = ciliate_to_plot_high
    var2plot = daily_data{:,ciliate_ind(count3)}./daily_data.ml_analyzed;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    tr_val_high = 4;
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_high) , 10);
    % plot(yd, y_mat, '-', 'linewidth', 2)
    plot(yd, xmean.^tr_val_high, '-', 'linewidth', 2)
end
numberOfDataSets = count3;
newDefaultColors = colorcube(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
legend(ciliate_label(ciliate_to_plot_high), "Location", "eastoutside", "Interpreter","none")
title("All Highest Count Ciliates CNN Climatology (> 10,000 counts)")
datetick
ylabel("Counts per mL", "FontSize", 14)
xlabel("Month", "FontSize", 14)

%New graphs based on results seasonally
%Very rare ciliates
figure, hold on
ciliate_to_plot_rare = [2 4 6 7 15 16 22 26];
for count_rare = ciliate_to_plot_rare
    var2plot = daily_data{:,ciliate_ind(count_rare)}./daily_data.ml_analyzed;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    tr_val_rare = 4;
    [xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_rare) , 10);
    % plot(yd, y_mat, '-', 'linewidth', 2)
    plot(yd, xmean.^tr_val_rare, '-', 'linewidth', 2)
end
numberOfDataSets = count_rare;
newDefaultColors = colorcube(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
legend(ciliate_label(ciliate_to_plot_rare), "Location", "eastoutside", "Interpreter","none")
title("Overall rare ciliates with no CNN seasonality")
datetick
ylabel("Counts per mL", "FontSize", 14)
xlabel("Month", "FontSize", 14)

%Spring peak, fall peak
figure, hold on
ciliate_to_plot_springfall = [8 14 18 19 20 21 23]; 
for count_sprfall = ciliate_to_plot_springfall
    var2plot = daily_data{:,ciliate_ind(count_sprfall)}./daily_data.ml_analyzed;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    tr_val_sf = 4;
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_sf), 10);
    % plot(yd, y_mat, '-', 'linewidth', 2)
    plot(yd, xmean.^tr_val_sf, '-', 'linewidth', 2)
end
numberOfDataSets = count_sprfall;
newDefaultColors = lines(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
legend(ciliate_label(ciliate_to_plot_springfall), "Location", "eastoutside", "Interpreter","none")
title("Ciliates with CNN spring and fall peaks")
datetick
ylabel("Counts per mL", "FontSize", 14)
xlabel("Month", "FontSize", 14)

%Fall
figure, hold on
ciliate_to_plot_fall = [1 3 9 10 13 17 24];
for count_fall = ciliate_to_plot_fall
    var2plot = daily_data{:,ciliate_ind(count_fall)}./daily_data.ml_analyzed;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    tr_val_f = 4;
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_f) , 10);
    % plot(yd, y_mat, '-', 'linewidth', 2)
    plot(yd, xmean.^tr_val_f, '-', 'linewidth', 2)
end
numberOfDataSets = count_fall;
newDefaultColors = colorcube(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
legend(ciliate_label(ciliate_to_plot_fall), "Location", "eastoutside", "Interpreter","none")
title("Ciliates with CNN fall seasonality")
datetick
ylabel("Counts per mL", "FontSize", 14)
xlabel("Month", "FontSize", 14)

%Pleuronema (Jan-Mar, May-Aug, Sep-Dec)
figure, hold on
ciliate_to_plot_pl = [11];
for count_pl = ciliate_to_plot_pl
    var2plot = daily_data{:,ciliate_ind(count_pl)}./daily_data.ml_analyzed;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    tr_val_p = 4;
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_p) , 10);
    % plot(yd, y_mat, '-', 'linewidth', 2)
    plot(yd, xmean.^tr_val_p, '-', 'linewidth', 2)
end
numberOfDataSets = count_pl;
newDefaultColors = lines(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
title("Pleuronema")
datetick
ylabel("Counts per mL", "FontSize", 14)
xlabel("Month", "FontSize", 14)

%Tontonia gracillima (Spring)
figure, hold on
ciliate_to_plot_tg = [27];
for count_tg = ciliate_to_plot_tg
    var2plot = daily_data{:,ciliate_ind(count_tg)}./daily_data.ml_analyzed;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    tr_val_tg = 4;
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_tg) , 10);
    % plot(yd, y_mat, '-', 'linewidth', 2)
    plot(yd, xmean.^tr_val_tg, '-', 'linewidth', 2)
end
numberOfDataSets = count_tg;
newDefaultColors = lines(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
title("Tontonia gracillima")
datetick
ylabel("Counts per mL", "FontSize", 14)
xlabel("Month", "FontSize", 14)

%Ciliate (year-round)
figure, hold on
ciliate_to_plot_c = [28];
for count_c = ciliate_to_plot_c
    var2plot = daily_data{:,ciliate_ind(count_c)}./daily_data.ml_analyzed;
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    tr_val_ciliate = 4;
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val_ciliate) , 10);
    % plot(yd, y_mat, '-', 'linewidth', 2)
    plot(yd, xmean.^tr_val_ciliate, '-', 'linewidth', 2)
end
numberOfDataSets = count_c;
newDefaultColors = lines(numberOfDataSets);
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
title("ciliate")
datetick
ylabel("Counts per mL", "FontSize", 14)
xlabel("Month", "FontSize", 14)
