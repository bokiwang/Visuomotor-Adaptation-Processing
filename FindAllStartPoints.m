function [all_starts, numoftrials] = FindAllStartPoints(velocity, biofbX, biofbY)
% ------------- Find all start points for reaches ---
% Boki Wang
% July 2018
% ---------------------------------------------------
% Based on biofeedback information, auto detect the starting time/index
% for each reach, return an array of indices of all reach starts.
%
% Inputs: 
% velocity -- resultant velocity array after filtering
% Biofeedback X, Biofeedback Y -- Straight from the motion monitor
% user report.
% Outputs: all_starts - an array of indices at which frame the reach starts.  
%
% ------------------ End -------------------------------

thereis_T1 = (biofbX == -0.1157); % There is Biofeedback showing Target 1 when value=1
thereis_T2 = (biofbY == 0.18);
thereis_T3 = (biofbX == 0.1157);
thereare_targets = thereis_T1 | thereis_T2 | thereis_T3; % overall indices for targets

% find indices/time points for the beginning and end of time window for T1
idx_T1_disappears = find(thereis_T1(1:end-1)==1 & thereis_T1(2:end) == 0); 
idx_T1_appears = find(thereis_T1(1:end-1)==0 & thereis_T1(2:end) == 1); 
idx_T2_disappears = find(thereis_T2(1:end-1)==1 & thereis_T2(2:end) == 0); 
idx_T2_appears = find(thereis_T2(1:end-1)==0 & thereis_T2(2:end) == 1); 
idx_T3_disappears = find(thereis_T3(1:end-1)==1 & thereis_T3(2:end) == 0); 
idx_T3_appears = find(thereis_T3(1:end-1)==0 & thereis_T3(2:end) == 1); 

%% Locate the minimum in data and use it as start point for each reach
% % to find the start point for outward reach to T1, T2, T3 separately

% the number of indices for T3 disappearances indicates the total number of 
% reaches. Because priyanka end each block manually 
% sometimes Priyanka will have participants do one more reach and then stop
% the trial. 
numoftrials = length(idx_T3_disappears);
% if she didn't let participants do one more reach
if length(idx_T3_disappears) == length(idx_T1_appears)
        % add the last point of the series as index to idx_T1_appears
        % so that in the FindReachStart function, it can distinguish T3
        % inward reaches
        idx_T1_appears(end+1)=length(velocity);
end
    
% Get start points for all reaches
    % The start point for outreach for T1 has to be between when T1 appears 
    % and when T1 disappears.
T1_out_starts = FindReachStart (velocity, idx_T1_appears, idx_T1_disappears, numoftrials);
    % Similiarly, the start point for inreach from T1 exists bewteen when T1
    % disappears and when T2 appears
T1_in_starts = FindReachStart (velocity, idx_T1_disappears, idx_T2_appears, numoftrials);
    % Goes on for all targets.
T2_out_starts = FindReachStart (velocity, idx_T2_appears, idx_T2_disappears, numoftrials);
T2_in_starts = FindReachStart (velocity, idx_T2_disappears, idx_T3_appears, numoftrials);
T3_out_starts = FindReachStart (velocity, idx_T3_appears, idx_T3_disappears, numoftrials);
T3_in_starts = FindReachStart (velocity, idx_T3_disappears, idx_T1_appears, numoftrials);

%% Visually Inspect/Mark 
all_starts = [T1_out_starts; T1_in_starts; T2_out_starts; T2_in_starts; ...
    T3_out_starts; T3_in_starts]; 
all_starts = sort(all_starts);

end