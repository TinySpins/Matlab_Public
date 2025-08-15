% swisstrace_trim_activiticurve.m

% Written by Christian Østergaard Mariager, June 2025

% This function trims out unwanted data from activity curves acquired 
% using a Swisstrace Twilite Three bloodsampler system

% Assumptions:
% 1) all data was acquired using a time resolution of 1 second, i.e. one datapoint per second
% 2) data was acquired using Swisstrace Twilite Three equipment
% 3) there are minor samplings present in the data in addition to the initial decay
% 4) the data has been corrected in PMOD's correction module

% Inputs:   
% activitycurve = path to .crv file containing the corrected activity data (corrected coincidences)
% minor_samplings = number of minor samplings after the main activity peak, if there are any 'extra' samplings due to error these should be included too
% duration = duration of the minor samplings in seconds, default = 40
% allowed_deviation = how many seconds minor samplings are allowed to deviate from expected duration, default = 18

% Outputs:
% A plot showing the results of the data trimming
% A new PMOD compatible .crv file with the trimmed data

function swisstrace_trim_activitycurve(activitycurve, minor_samplings, duration, allowed_deviation)
    
    % input variable checks
    defaults.duration = 40;
    defaults.allowed_deviation = 18;
    defaultNames = fieldnames(defaults);
    for nInputName = 1:numel(defaultNames)
        variableName = defaultNames{nInputName};
        if ~exist(variableName,'var')
            eval([variableName,'=','defaults.(variableName);']);
        end  
    end  

    % load data
    curves = tdfread(activitycurve);

    % label data
    curves_fields = fieldnames(curves);
    coincidences = curves.(curves_fields{2}); % kBq/cc
    time = curves.(curves_fields{1}); % seconds

    % smooth data
    coincidences_smooth = smoothdata(coincidences,'sgolay');

    % detect peak and initial decay curve
    [peak,idx_peak] = max(coincidences);
    trim = 5; % remove last 5 seconds off initial decay
    ipt.initial_decay = findchangepts(coincidences(idx_peak:end),MaxNumChanges=1,Statistic="rms");
    ipt.initial_decay = ipt.initial_decay + idx_peak - trim;

    % detect minor samplings after the initial decay
    n = minor_samplings*2;
    curve_offset = ipt.initial_decay(end) + 15; % add 15 seconds to offset to get away from initial decay
    ipt.minor_samplings = findchangepts(coincidences(curve_offset:end),MaxNumChanges=n,Statistic="rms");
    ipt.minor_samplings = ipt.minor_samplings + curve_offset;

    % minor sampling rejections if window too wide/narrow
    expected_duration = duration; % seconds
    allowed_deviation = 18; % seconds

    if mod(length(ipt.minor_samplings), 2) == 0 % if there is an even number of changepoints
        detected_durations = diff(reshape(ipt.minor_samplings,[2,length(ipt.minor_samplings)/2])); % seconds
    else % if there is an odd number of changepoints
        warning('Odd number of changepoints detected. Processing may fail!')
        ipt.minor_samplings(end) = []; % try removing the last detected changepoint
        detected_durations = diff(reshape(ipt.minor_samplings,[2,length(ipt.minor_samplings)/2])); % seconds
    end
    
    filter_idx = detected_durations < expected_duration+allowed_deviation & detected_durations > expected_duration-allowed_deviation;
    minor_samplings = reshape(ipt.minor_samplings,[2,length(ipt.minor_samplings)/2]);
    minor_samplings_filtered = minor_samplings(repmat(filter_idx,2,1));
    minor_samplings_filtered_arranged = reshape(minor_samplings_filtered,2,length(minor_samplings_filtered)/2);

    % minor sampling rejections low value correction
    % if window larger than 30 seconds, shave off the lowest points from
    % both ends until we get to 30 second window
    for k1 = 1:length(minor_samplings_filtered_arranged)
        working_window = minor_samplings_filtered_arranged(:,k1);
        window_length = diff(working_window);
        final_length = 30;
        if window_length > 30 % seconds
            for k2 = 1:(window_length-final_length) % for every window length too long
                    window_leading_value = squeeze(coincidences(working_window(1)));
                    window_trailing_value =squeeze(coincidences(working_window(2)));
                    window_ends = [window_leading_value, window_trailing_value];
                    [val,min_idx] = min(window_ends);
                    if min_idx == 1
                        working_window(1) = working_window(1) + 1;
                    else
                        working_window(2) = working_window(2) - 1;
                    end      
            end
        else % do nothing
        end

        minor_samplings_corrected(:,k1) = working_window;

    end
    
    % find means, medians
    for k3 = 1:length(minor_samplings_corrected)

        means(k3) = mean(coincidences(minor_samplings_corrected(1,k3):minor_samplings_corrected(2,k3)));
        medians(k3) = median(coincidences(minor_samplings_corrected(1,k3):minor_samplings_corrected(2,k3)));

    end

    % plot progress
    fig1 = figure;
    plot(time,coincidences)
    hold on
    plot(time,coincidences_smooth,'k')
    xline(time(ipt.initial_decay(end)),'--r',{'End of initial decay'})
    plot(time(idx_peak),coincidences(idx_peak),'*r')
    xline(time(ipt.minor_samplings),'--g')
    xline(time(minor_samplings_filtered),'--m')
    
    % plot results
    fig2 = figure;
    plot(time,coincidences,'--k')
    hold on
    plot(time(1:ipt.initial_decay),coincidences(1:ipt.initial_decay),'.r')
    for k9 = 1:length(minor_samplings_corrected)
        plot(time(minor_samplings_corrected(1,k9):minor_samplings_corrected(2,k9)),...
            coincidences(minor_samplings_corrected(1,k9):minor_samplings_corrected(2,k9)),'.r')
    end
    xline(time(minor_samplings_corrected(:)),'--m')
    for k10 = 1:length(minor_samplings_corrected)
        line([time(minor_samplings_corrected(1,k10)-10) time(minor_samplings_corrected(2,k10)+10)],...
            [means(k10) means(k10)], 'LineWidth',3);
        %line([time(minor_samplings_corrected(1,k10)-10) time(minor_samplings_corrected(2,k10)+10)],...
        %    [medians(k10) medians(k10)], 'Color', 'red', 'LineWidth',3);
    end
    
    % save a trimmed PMOD compatible .crv file
    target_file = readtable(activitycurve,'FileType','text',"VariableNamingRule","preserve");
    deletions = [];
    trim = [ipt.initial_decay;minor_samplings_corrected(:);size(target_file,1)];
    for k11 = 1:2:((length(minor_samplings_corrected)+1)*2)
        lines = trim(k11):1:trim(k11+1);
        deletions = [deletions,lines];
        lines = [];
    end
    target_file([deletions],:) = [];
    [path,fname,ext]=fileparts(activitycurve);
    target_path = [path '/' fname '_trimmed.crv'];
    writetable(target_file,target_path,'Delimiter','\t','WriteVariableNames',true,'FileType','text');

end

