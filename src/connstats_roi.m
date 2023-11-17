function connstats_roi(varargin)

warning('off','MATLAB:table:RowsAddedExistingVars');

% Quit if requested (for extracting CTF in docker image)
if nargin>0 & strcmp(varargin{1},'quit')
    exit
end

% Inputs
P = inputParser;
addOptional(P,'matrix_csv','/INPUTS/Z_removegm.csv')
addOptional(P,'out_dir','/OUTPUTS')
addOptional(P,'seed_roi','DMN_LatPar_L')
parse(P,varargin{:});
disp(P.Results)
matrix_csv = P.Results.matrix_csv;
seed_roi = P.Results.seed_roi;
out_dir = P.Results.out_dir;


%% Read connectivity matrix from conncalc
%     https://github.com/baxpr/conncalc
C = readtable(matrix_csv,'ReadRowNames',true);

% And extract/parse ROI names. ROIs are named as r????_<network>_<region>
keeprow = nan;
rois = table(C.Properties.VariableNames','VariableNames',{'roi'});
for h = 1:height(rois)
    q = strsplit(rois.roi{h},'_');
    rois.num{h,1} = q{1};
    rois.label{h,1} = strjoin(q(2:end),'_');
    if strcmp(rois.label{h,1},seed_roi)
        keeprow = h;
        break
    end
end
if isnan(keeprow)
    warning('ROI %s not found in connectivity matrix: extracting for ALL regions',seed_roi);
    seed_roi = 'all';
end


%% Individual edges

% Get them all if requested
if strcmp(seed_roi,'all')
    result = table();
    for k1 = 1:size(C,1)-1
        for k2 = k1+1:size(C,2)
            rname = C.Row{k1}(7:end);
            cname = C.Properties.VariableNames{k2}(7:end);
            result.([rname '_' cname]) = C{k1,k2};
        end
    end

else

    result = table();
    for k = 1:size(C,2)
        if k==keeprow, continue, end
        rname = C.Row{keeprow}(7:end);
        cname = C.Properties.VariableNames{k}(7:end);
        result.([rname '_' cname]) = C{keeprow,k};
    end

end


%% Save to file
writetable(result,fullfile(out_dir,'stats.csv'));


%% Exit
if isdeployed
    exit
end
