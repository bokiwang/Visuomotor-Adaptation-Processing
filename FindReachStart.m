function IndexOfStarts = FindReachStart (VelocityArray, LeftBoundaryArray, RightBoundaryArray, NumOfTrials)
% ---------- Find start of each reach -----------
% Boki Wang 
% July 2018
% -----------------------------------------------
% find the minima in data within the left and right boundaries 
% the indices of minumum velocity points are returned 
% to be used as the start for each reach
% 
% Inputs: 
% VelocityArray, LeftBoundaryArray, RightBoundaryArray, NumOfTrials
% Output:
% IndexOfStarts: Numerical Array
% ----------------- end -------------------------

% screw all that. I'm finding the minimum. 

%    is_v_low = (v_out < V_END);
%     if_hit_home = Home( idx_T1_appears(i)+1 : idx_T1_disappears(i) ); 
%     % find indices for points that suffice the critia
%     indices = find(is_v_low & if_hit_home);  % local indices 
%     
%     % if criteria not met, very likely there's an overshoot. don't check for
%     % home
%     if length(indices) == 0   
%         indices = find(is_v_low);
%     end    
%     % If more than one index, use local minimum as start/end point    
%     if length(indices) > 1 

IndexOfStarts = zeros(NumOfTrials,1);  % all out_starts in here for T1

% find the start point for each trial

if length(RightBoundaryArray) == NumOfTrials    % this is the normal condition
    for i = 1:NumOfTrials
        v_out = VelocityArray( LeftBoundaryArray(i)+1 : RightBoundaryArray(i) ); % outward reach velocity
        % identify the minimum velocity, get the index
        idxs = find(v_out == min(v_out));
        if length(idxs) > 1  % if more than 1 local minima, use the last one
            idxl_out_start = idxs(end);
        else
            idxl_out_start = idxs;
        end
        IndexOfStarts(i) = LeftBoundaryArray(i)+idxl_out_start;
    end
elseif length(RightBoundaryArray) == NumOfTrials + 1     % this is for target 3 inward reaches
    for i = 1:NumOfTrials
        v_out = VelocityArray( LeftBoundaryArray(i)+1 : RightBoundaryArray(i+1) ); % outward reach velocity
        % identify the minimum velocity, get the index
        idxs = find(v_out == min(v_out));
        if length(idxs) > 1  % if more than 1 local minima, use the last one
            idxl_out_start = idxs(end);
        else
            idxl_out_start = idxs;
        end
        IndexOfStarts(i) = LeftBoundaryArray(i)+idxl_out_start;
    end
else
    sprintf('Error: Number of trials error. Check how many trials are in this block.')
end

% End of function
end