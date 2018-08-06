function [maxvelLoc, maxvelArray] = MaxVel(Velocity, all_starts)
% ------- Find the start of each reach ----------
% Boki Wang 
% July 2018
% -----------------------------------------------
% find the maximum velocity for each reach between each reach start points
% 
% Inputs: 
% VelocityArray, ReachStartArray 
% Output:
% maxvelLoc -- array of indices of every maximum velocity
% maxvelarray -- array of the value of every maximum velocity
% ----------------- end -------------------------

numoftrials = length(all_starts);
maxvelArray = zeros(numoftrials,1);  % initialize
maxvelLoc = zeros(numoftrials,1);

% find the start point for each trial
for i = 1: (numoftrials-1)
    v_out = Velocity( all_starts(i) : all_starts(i+1) );
    [maxvelArray(i), maxvelLoc(i)] = max(v_out);
    % transfer local coordinates into global coordinates
    maxvelLoc(i) = all_starts(i) -1 + maxvelLoc(i);
end

% The last inward reach of T3 just has a start point.So calculate separatly
[maxvelArray(numoftrials), maxvelLoc(numoftrials)] = ...
    max(Velocity( all_starts(end) : end ));
maxvelLoc(numoftrials) = all_starts(end) -1 + maxvelLoc(numoftrials);

  
% End of function
end