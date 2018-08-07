function [wrong_idx, wrong_starts] = DoubleCheck(all_starts, biofbX, biofbY)
% check if the starts are valid:

thereis_T1 = (biofbX == -0.1157); % There is Biofeedback showing Target 1 when value=1
thereis_T2 = (biofbY == 0.18);
thereis_T3 = (biofbX == 0.1157);
thereare_targets = thereis_T1 | thereis_T2 | thereis_T3; % overall indices for targets

% find all target swtiches
% idx_T1_disappears = find(thereis_T1(1:end-1)==1 & thereis_T1(2:end) == 0); 
% idx_T1_appears = find(thereis_T1(1:end-1)==0 & thereis_T1(2:end) == 1); 
% idx_T2_disappears = find(thereis_T2(1:end-1)==1 & thereis_T2(2:end) == 0); 
% idx_T2_appears = find(thereis_T2(1:end-1)==0 & thereis_T2(2:end) == 1); 
% idx_T3_disappears = find(thereis_T3(1:end-1)==1 & thereis_T3(2:end) == 0); 
% idx_T3_appears = find(thereis_T3(1:end-1)==0 & thereis_T3(2:end) == 1); 
% idx_target_swithces = [idx_T1_disappears' idx_T1_appears' idx_T2_disappears' idx_T2_appears' idx_T3_disappears' idx_T3_appears']';
% idx_target_swithces = sort(idx_target_swithces);
idx_switches = find( (thereare_targets(1:end-1)==1 & thereare_targets(2:end) == 0) ...
    | (thereare_targets(1:end-1)==0 & thereare_targets(2:end) == 1) );

is_correct = zeros(length(all_starts),1);
% check if start point lies between two switch points. 
for i = 1:length(all_starts)-1
    if all_starts(i) > idx_switches(i) & all_starts(i) < idx_switches(i + 1) 
        is_correct(i) = 1;  % value = 1 if the start point is logically correct 
    end
end

% in case all_starts and idx_swithces have the same length
if length(all_starts) == length(idx_switches)
    if all_starts(end) > idx_switches(end)
        is_correct(end) = 1;
    end
else    % always all_starts has one less element than idx_switches
    if all_starts(end) > idx_switches(end - 1) & all_starts(end) < idx_switches(end)
        is_correct(end) = 1;
    end
end

% find wrong starts points
wrong_idx = find( is_correct==0 );
wrong_starts = all_starts ( wrong_idx );

% end of function
end

