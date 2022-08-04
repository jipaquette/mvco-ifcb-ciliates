%% *Ciliate case graphs*
%% *Jill Paquette, Heidi Sosik, Emily Peacock*
%
%
% *Loading in the files*
%
% Assigning the CNN data to daily_data
%
% _readtable_ loads it into the interface

daily_data = readtable('/Users/jillianpaquette/Desktop/WHOI Work/count_by_class_time_series_CNN_daily_20220622.csv');
load("count_manual_current_day.mat")
class2plot_list = ["Balanion" "ciliate" "Dictyocysta" "Didinium" ...
    "Euplotes" "Eutintinnus" "Favella" "Laboea strobila" "Leegaardiella ovalis" ...
    "Mesodinium" "Pleuronema" "Stenosemella morphotype 1" "Stenosemella pacifica" ...
    "Strobilidium" "Strombidium capitatum" "Strombidium conicum" "Strombidium inclinatum" ...
    "Strombidium morphotype 1" "Strombidium morphotype 2" "Strombidium oculatum" ...
    "Strombidium wulffi" "Tiarina fusus" "Tintinnida" "Tintinnidium mucicola" ...
    "Tintinnopsis" "Tontonia appendiculariformis" "Tontonia gracillima"];
%%
% Ciliate variable to change
for pagecount = 1:length(class2plot_list)
    class2plot = class2plot_list(pagecount);
    switch class2plot
        case "Balanion"
            daily_data_classlabel = "Balanion";
            class2use_label = "Balanion";
            ylim_max = 45;
        case "ciliate"
            daily_data_classlabel = "ciliate";
            class2use_label = "ciliate";
            ylim_max = 80;
        case "Dictyocysta"
            daily_data_classlabel = "Dictyocysta";
            class2use_label = "Dictyocysta";
            ylim_max = 0.3;
        case "Didinium"
            daily_data_classlabel = "Didinium";
            class2use_label = "Didinium";
            ylim_max = 0.45;
        case "Euplotes"
            daily_data_classlabel = "Euplotes";
            class2use_label = "Euplotes";
            ylim_max = 1.6;
        case "Euplotes morphotype 1"
            daily_data_classlabel = "Euplotes_morphotype1";
            class2use_label = "Euplotes morphotype1"; % check that this one runs
            ylim_max = 1;
        case "Eutintinnus"
            daily_data_classlabel = "Eutintinnus";
            class2use_label = "Eutintinnus";
            ylim_max = 0.25;
        case "Favella"
            daily_data_classlabel = "Favella";
            class2use_label = "Favella";
            ylim_max = 3;
            %Helico subu no CNN labels
        case "Laboea strobila"
            daily_data_classlabel = "Laboea_strobila";
            class2use_label = "Laboea strobila";
            ylim_max = 3;
        case "Leegaardiella ovalis"
            daily_data_classlabel = "Leegaardiella_ovalis";
            class2use_label = "Leegaardiella ovalis";
            ylim_max = 4;
        case "Mesodinium"
            daily_data_classlabel = "Mesodinium";
            class2use_label = "Mesodinium";
            ylim_max = 80;
        case "Pleuronema"
            daily_data_classlabel = "Pleuronema";
            class2use_label = "Pleuronema";
            ylim_max = 1;
        case "Stenosemella morphotype 1"
            daily_data_classlabel = "Stenosemella_morphotype1";
            class2use_label = "Stenosemella morphotype1";
            ylim_max = 1.6;
        case "Stenosemella pacifica"
            daily_data_classlabel = "Stenosemella_pacifica";
            class2use_label = "Stenosemella pacifica";
            ylim_max = 7;
        case "Strobilidium"
            daily_data_classlabel = "Strobilidium";
            class2use_label = "Strobilidium";
            ylim_max = 1.4;
            %Strobilidium m1 no CNN labels
        case "Strombidium capitatum"
            daily_data_classlabel = "Strombidium_capitatum";
            class2use_label = "Strombidium capitatum";
            ylim_max = 0.25;
        case "Strombidium conicum"
            daily_data_classlabel = "Strombidium_conicum";
            class2use_label = "Strombidium conicum";
            ylim_max = 1;
        case "Strombidium inclinatum"
            daily_data_classlabel = "Strombidium_inclinatum";
            class2use_label = "Strombidium inclinatum";
            ylim_max = 1.8;
        case "Strombidium morphotype 1"
            daily_data_classlabel = "Strombidium_morphotype1";
            class2use_label = "Strombidium morphotype1";
            ylim_max = 8;
        case "Strombidium morphotype 2"
            daily_data_classlabel = "Strombidium_morphotype2";
            class2use_label = "Strombidium morphotype2";
            ylim_max = 4.5;
        case "Strombidium oculatum"
            daily_data_classlabel = "Strombidium_oculatum";
            class2use_label = "Strombidium oculatum";
            ylim_max = 6;
        case "Strombidium wulffi"
            daily_data_classlabel = "Strombidium_wulffi";
            class2use_label = "Strombidium wulffi";
            ylim_max = 2.5;
        case "Tiarina fusus"
            daily_data_classlabel = "Tiarina_fusus";
            class2use_label = "Tiarina fusus";
            ylim_max = 0.3;
        case "Tintinnida"
            daily_data_classlabel = "Tintinnida";
            class2use_label = "Tintinnida";
            ylim_max = 12;
        case "Tintinnidium mucicola"
            daily_data_classlabel = "Tintinnidium_mucicola";
            class2use_label = "Tintinnidium mucicola";
            ylim_max = 0.6;
        case "Tintinnopsis"
            daily_data_classlabel = "Tintinnopsis";
            class2use_label = "Tintinnopsis";
            ylim_max = 35;
        case "Tontonia appendiculariformis"
            daily_data_classlabel = "Tontonia_appendiculariformis";
            class2use_label = "Tontonia appendiculariformis";
            ylim_max = 3;
        case "Tontonia gracillima"
            daily_data_classlabel = "Tontonia_gracillima";
            class2use_label = "Tontonia gracillima";
            ylim_max = 9;
    end
    %%
    % *Create a figure of CNN and manual data across all years (CNN vs manual)*
    %
    % Dividing by ml_analyzed to get exact counts (conc. by mL)

    % creating the plot
    figure(1), clf, set(gcf, 'position', [120 75 1150 600])
    subplot(2,1,1)
    plot(daily_data.datetime, daily_data.(daily_data_classlabel)./daily_data.ml_analyzed)
    % labeling the plot
    datetick("keeplimits") % adds years to the plot instead of dot date
    xlabel("Year")
    ylabel(['\it' char(class2use_label) '\rm (ml^{-1})'])
    % create the manual annotations graph on top
    hold on
    datetime_bin = datetime(matdate_bin, "ConvertFrom", "datenum"); % change date system
    class_ind = strcmp(class2use_label, class2use); % look for this reference
    plot(datetime_bin, (classcount_bin(:,class_ind)./ml_analyzed_mat_bin(:,class_ind)), "r*")
    ylim([0 ylim_max])
    legend("CNN Auto Classifier", "Manual Annotations", "Location", "eastoutside")
    %%
    % *Create a figure of 2006-2022 as lines across months (seasonal changes)*
    %
    % Code and function from Heidi Sosik, adapted from GitHub for NES-LTER

    var2plot = daily_data.(daily_data_classlabel)./daily_data.ml_analyzed;
    mdate = datenum(daily_data.datetime);
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, var2plot );
    % create the figure
    figure(1)
    subplot(2,2,3)
    plot(yd, y_mat, ".-")
    datetick("x", "m")
    legend(num2str(yearlist'), "Location", "eastoutside")
    ylabel(['\it' char(class2use_label) '\rm (ml^{-1})']) % italicize and superscript
    xlabel("Month")
    %%
    % *Create a tiled figure of all years separate from each other across months
    % (yearly seasonal changes)*

    var2plot = classcount_bin(:,class_ind)./ml_analyzed_mat_bin(:,class_ind);
    [ mdate_mat_manual, y_mat_manual, yearlist_manual, yd_manual ] = timeseries2ydmat(matdate_bin , var2plot );
    figure(2), clf, set(gcf, 'position', [120 75 1150 600]) % position of corner x2, width, height
    T = tiledlayout(4,4);
    % creates the number of plots as long as yearlist
    for ii = 1:length(yearlist)
        nexttile
        plot(yd, y_mat(:,ii), ".-")
        xlim([0 366])
        ylim([0 ylim_max])
        datetick("x", "m")
        title(yearlist(ii))
        hold on
        plot(yd_manual, y_mat_manual(:,ii), "r*")
    end
    ylabel(T, ['\it' char(class2use_label) '\rm (ml^{-1})'], 'fontsize', 16)
    xlabel(T, 'Month', 'fontsize', 16)
    legend("CNN Auto Classifier", "Manual Annotations", "Location", "eastoutside")
    a = annotation('rectangle', [0 0 1 1], 'color', 'w');

    %%
    % *Creates smoothed climatology graph with means and SD (similar to var2plot)*
    %
    % Code and function from Heidi Sosik, adapted from GitHub for NES-LTER


    tr_val = 4;
    [ xmean, xstd ] = smoothed_climatology( y_mat.^(1/tr_val) , 10);
    figure(1)
    subplot(2,2,4)
    plot(yd, y_mat, '.')
    hold on % create mean and SD lines
    plot(yd, xmean.^tr_val, 'k-','linewidth', 3)
    plot(yd, (xmean+xstd).^tr_val, 'k--', 'linewidth', 2)
    plot(yd, (xmean-xstd).^tr_val, 'k--', 'linewidth', 2)
    ylim([0 ylim_max])
    xlim([0 366])
    datetick
    legend(num2str(yearlist'), "Location", "eastoutside")
    ylabel(['\it' char(class2use_label) '\rm (ml^{-1})'])
    xlabel("Month")
    a = annotation('rectangle', [0 0 1 1], 'color', 'w');
    exportgraphics(figure(1), 'Ciliate All Figures.pdf', 'append', true)
    exportgraphics(figure(2), 'Ciliate All Figures.pdf', 'append', true)
    %print(figure(1), [char(class2use_label) '_fig1'], '-dpng')
    %print(figure(2), [char(class2use_label) '_fig2'], '-dpng')

end