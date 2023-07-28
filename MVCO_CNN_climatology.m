%mvco cnn over time climatology graphs
%count data only
%env data included although unnecessary

%%
%loading in data
%cnn summary data
load('/Volumes/IFCB_products/MVCO/summary_v4/count_group_class.mat')
%manual data
load('/Users/jillianpaquette/Desktop/WHOI Work/count_manual_current_jill_MVCO.mat')
%env data
load('/Users/jillianpaquette/Desktop/WHOI Work/MVCO_Environmental_Tables.mat')

%%
%change summary to timetable
count_mvco_ttable_full = table2timetable(classcount_opt_adhoc_merge,'rowtimes', meta_data.datetime);

%add ml_analyzed
count_mvco_ttable_full.ml_analyzed = meta_data.ml_analyzed;

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

%%
%choose transformation value
tr_val = 4;

%%
%ciliate taxon to change
m_class2plot = 'Mesodinium';

switch m_class2plot
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
count_var2plot = count_env.(classlabel).^(1/tr_val)./count_env.ml_analyzed.^(1/tr_val);
count_mdate = datenum(count_env.days);
[ count_mdate_mat, count_y_mat, count_yearlist, count_yd ] = timeseries2ydmat( count_mdate, count_var2plot );

%create plot
figure
plot(count_yd, count_y_mat, '.')

%add graph details
%change from days of year to months
legend(num2str(count_yearlist'), 'Location', 'eastoutside')
ylim([0 inf])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14);
xlabel('Day of year', 'FontSize', 14)
xlim([0 366])

%%
%cnn data with each year as a separate colored dot + mean/std lines

%climatology function (included above)
    %count_var2plot = count_mvco_ttable_full.(cnn_mvco_classlabel)./count_mvco_ttable_full.ml_analyzed;
    %count_mdate = datenum(count_mvco_ttable_full.Time);
    %[ count_mdate_mat, count_y_mat, count_yearlist, count_yd ] = timeseries2ydmat( count_mdate, count_var2plot );

%create plot
figure
plot(count_yd, count_y_mat, '.')

%mean and std function
[ count_xmean, count_xstd ] = smoothed_climatology( count_y_mat.^(1/tr_val) , 10);

%add on mean and std
hold on
plot(count_yd, count_xmean.^tr_val, 'k-','linewidth', 3)
plot(count_yd, (count_xmean+count_xstd).^tr_val, 'k--', 'linewidth', 2)
plot(count_yd, (count_xmean-count_xstd).^tr_val, 'k--', 'linewidth', 2)

%add graph details
datetick
xlim([0 366])
legend(num2str(count_yearlist'), 'Location', 'eastoutside')
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14);
xlabel('Month', 'FontSize', 14)
ylim([0 inf])