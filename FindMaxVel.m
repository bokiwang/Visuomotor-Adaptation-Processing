function [maxvelLoc, maxvelArray] = FindMaxVel (VelocityArray, LeftBoundaryArray, RightBoundaryArray, NumOfTrials)
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

maxvelArray = zeros(NumOfTrials,1);  % all out_starts in here for T1
maxvelLoc = zeros(NumOfTrials,1);
% find the start point for each trial

if length(RightBoundaryArray) == NumOfTrials    % this is the normal condition
    for i = 1:NumOfTrials
        v_out = VelocityArray( LeftBoundaryArray(i)+1 : RightBoundaryArray(i) ); % outward reach velocity
        [maxvelArray(i), maxvelLoc(i)] = max(v_out);
        maxvelLoc(i) = LeftBoundaryArray(i)+ maxvelLoc(i);
    end
    for i = 1:NumOfTrialselseif length(RightBoundaryArray) == NumOfTrials + 1     % this is for target 3 inward reaches

        v_out = VelocityArray( LeftBoundaryArray(i)+1 : RightBoundaryArray(i+1) ); % outward reach velocity
        [maxvelArray(i), maxvelLoc(i)] = max(v_out);
        maxvelLoc(i) = LeftBoundaryArray(i)+ maxvelLoc(i);
    end
else
    sprintf('Error: Number of trials error. Check how many trials are in this block.')
end

% End of function
end