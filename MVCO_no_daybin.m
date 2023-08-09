%mvco without day binning
%no env

%%
%loading in data
%mvco cnn summary data
load('/Volumes/IFCB_products/MVCO/summary_v4/count_group_class.mat');
%mvco manual data
load('/Users/jillianpaquette/Desktop/WHOI Work/count_manual_current_jill_MVCO.mat');

%%
%change summary to timetable
mvco2 = table2timetable(classcount_opt_adhoc_merge,'rowtimes', meta_data.datetime);

%add ml_analyzed
mvco2.ml_analyzed = meta_data.ml_analyzed;

%remove pid
mvco2.pid = [];    

%remove imaginary samples
mvco2(mvco2.ml_analyzed < 0, :) = [];

%removed daybinning

%%
%choose transformation value
tr_val = 4;

%%
%mvco seasons
mvco2.month = month(mvco2.Time);

%mvco seasons: specified months
mvco_summer_ind = find(mvco2.month == 6 ...
    | mvco2.month == 7 ...
    | mvco2.month == 8);
mvco_fall_ind = find(mvco2.month == 9 ...
    | mvco2.month == 10 ...
    | mvco2.month == 11);
mvco_winter_ind = find(mvco2.month == 12 ...
    | mvco2.month == 1 ...
    | mvco2.month == 2);
mvco_spring_ind = find(mvco2.month == 3 ...
    | mvco2.month == 4 ...
    | mvco2.month == 5);

%%
%day function
doy = day(mvco2.Time, 'dayofyear');
mvco2.year = year(mvco2.Time); 

%%
%ciliate taxon to change
class2plot = 'Strombidium morphotype 1';

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
%gscatter using doy for "climatology"
%create plot
figure
gscatter(doy, mvco2.(classlabel)./mvco2.ml_analyzed, mvco2.year);

%add graph details
%change from days of year to months
legend('Location', 'eastoutside')
ylim([0 inf])
ylabel(['\it' class2use_label '\rm Count (ml^{-1})'], 'FontSize', 14);
xlabel('Day of year', 'FontSize', 14)
xlim([0 366])