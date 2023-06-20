%dylan lat long cruise

% define lon range (change to what you want):
minlon = -70.93; % boundary closer to negative infinity, should be negative for NES
maxlon = -70.83; % boundary closer to positive infinity, should be negative for NES

% define lat range
%L2 = 41.03
L2minlat = 40.98;
L2maxlat = 41.08;

%L5 = 40.5133
L5minlat = 40.4633;
L5maxlat = 40.5633;

%L9 = 40.0983
L9minlat = 40.0483;
L9maxlat = 40.1483;

%L11 = 39.7733
L11minlat = 39.7233;
L11maxlat = 39.8233;

% IFCB meta-data:
metaT =  webread('https://ifcb-data.whoi.edu/api/export_metadata/NESLTER_transect', weboptions('Timeout', 120));

% bins in longitude & latitude range, + underway only:
%mybins = metaT(metaT.longitude >= minlon & metaT.longitude <= maxlon, 'pid');
% mybins = metaT(metaT.longitude >= minlon & metaT.longitude <= maxlon & ...
%     metaT.latitude >= L2minlat & metaT.latitude <= L2maxlat | ...
%     metaT.latitude >= L5minlat & metaT.latitude <= L5maxlat | ...
%     metaT.latitude >= L9minlat & metaT.latitude <= L9maxlat | ...
%     metaT.latitude >= L11minlat & metaT.latitude <= L11maxlat, 'pid');
 
mybins = metaT(metaT.longitude >= minlon & metaT.longitude <= maxlon & ...
      metaT.latitude >= L11minlat & metaT.latitude <= L11maxlat, 'pid');

% write to csv:
writetable(mybins, 'allcruises_binsonL11.csv');