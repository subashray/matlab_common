clear all;
dirname = '~pwjones/glab/data/lgmd_vc/processed/minis/';
cc_fname = '090508_1-92_mini.mat';
%vc_fname = '090508_1_1-78_mini.mat';
%vc_fname = '090501_1-37_mini.mat';
%vc_fname = '071211_1-20_mini.mat';
%vc_fname = '071211_1-33_mini.mat';
vc_fname = '071004_1_3-53_mini.mat';
vc_fname = '071206_1-43_mini.mat';
% load the files
cc = load([dirname cc_fname]);
cc = cc.handles;
vc = load([dirname vc_fname]);
vc = vc.handles;

% a little adaptation for mat files that have minis from multiple files
if (isfield(cc, 'prev') && length(cc.prev) > 0)
    [cc.minis, cc.miniSlopes, cc.miniHeights] = returnAllMinis(cc);
    cc.numMinis = sum([cc.prev.numMinis]) + cc.numMinis;
end
if (isfield(vc, 'prev') && length(vc.prev) > 0)
    [vc.minis, vc.miniSlopes, vc.miniHeights] = returnAllMinis(vc);
    vc.numMinis = sum([vc.prev.numMinis]) + vc.numMinis;
end

% exclude minis that somehow have positive heights
includei = find(vc.miniHeights < 0);
vc.miniHeights = vc.miniHeights(includei);
vc.minis = vc.minis(:,includei);
vc.miniSlopes = vc.miniSlopes(:,includei);
nexcluded = vc.numMinis - length(includei);
disp(sprintf('Excluded %i minis in the analysis', nexcluded));
vc.numMinis = length(includei);

%plot the stuff
figure;
ah = axes; hold on;
%[cc_handle, cc_hist, cc_bins]  = plotVectorDistribution(ah, cc.miniHeights, .1,  'b');
%set(cc_handle,'BarWidth',1, 'EdgeColor', 'b');
[vc_handle, vc_hist, vc_bins]  = plotVectorDistribution(ah, vc.miniHeights, .1,  'k');
set(vc_handle,'BarWidth',1, 'EdgeColor', 'k');
xlabel('Spontaneous Event Amplitude (nA)', 'Fontsize', 18);
ylabel('Number of events','Fontsize', 18);
vc_medHeight = median(vc.miniHeights);
vc_meanHeight = mean(vc.miniHeights);
plot([vc_medHeight vc_medHeight], [0 max(vc_hist)+5], '--', 'Color', [.5 .5 .5]);
text(vc_medHeight + .05, max(vc_hist)+2, sprintf('Median = %f', vc_medHeight));
text(vc_medHeight + .05, max(vc_hist)+5, sprintf('Mean = %f', vc_meanHeight));
xl = get(gca, 'xlim');
text(xl(2) - .4, max(vc_hist)+2, sprintf('n = %i events', vc.numMinis));
set(ah, 'tickdir', 'out', 'Fontsize', 16);