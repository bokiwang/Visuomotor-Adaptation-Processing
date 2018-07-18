% Computing peak velocity from raw data
% Project: tDCS and visuomotor adaptation
% June 7, 2018
% Boki Wang
% --------------------
% read in data files from .exp file from the Motion Monitor
% -------------- How to ----------
%   Make sure that the file directory is added to Matlab directories
%   In the dialogue window, select "all files"
%   Select the right .exp file
% -------------- end ---------------.
% 
%%
clear all 

% read
start_path = 'D:\Data\tDCS and visuomotor adaptation\Boki Pilot';
filename = uigetfile(start_path);
% Import Data
% Data from the motion monitor are tab delimited; 
delimiterIn = '\t';     % \t for tab
headerlinesIn = 9;      % each .exp file always has 9 headerlines/rows
A = importdata(filename, delimiterIn, headerlinesIn);

% display info for inspection
% disp([A.textdata(9,:)]);
varnames = A.textdata(9,:);

%%

% data info
fs = 100.251

% Biofeedback tell us about the visual stimulation. Or where the target appears. 
% ... this can be used to decide trial onset and offset; 

% Performance can be inferred from Home, t1, t2, and t3 for no adaptation
% ... on Home, t1_rotated30 etc for 30 degree perturbation
% ... on Home, t1_rotated45 etc for 45 degree perturbation
% Home = 1 happens whenever the hand reaches the home target, and so on.

%% get variables
% get resultant velocity from A, 11th column
velocity = A.data(:,11);
biofbX = A.data(:,16); %Biofeedback x and y
biofbY = A.data(:,17);
% If targets are hit
Home = A.data(:, 22);
T1 = A.data(:,23);
T2 = A.data(:,24);
T3 = A.data(:,25);

%% Chunk out time series according to which target appears
appears_T1 = (biofbX == -0.1157); % is Biofeedback showing Target 1
appears_T2 = (biofbY == 0.18);
appears_T3 = (biofbX == 0.1157);
appears_targets = appears_T1 | appears_T2 | appears_T3; % overall indices for targets

appears_Home = ~ appears_targets;% Biofeedback for the Home target

idx_targets_disappears = find(appears_targets(1:end-1)==1 & appears_targets(2:end) == 0); % find the index of when 
idx_targets_appears = find(appears_targets(1:end-1)==0 & appears_targets(2:end) == 1); 

% find indices for the beginning and end of time window for T1
idx_T1_disappears = find(appears_T1(1:end-1)==1 & appears_T1(2:end) == 0); 
idx_T1_appears = find(appears_T1(1:end-1)==0 & appears_T1(2:end) == 1); 

idx_T2_disappears = find(appears_T2(1:end-1)==1 & appears_T2(2:end) == 0); 
idx_T2_appears = find(appears_T2(1:end-1)==0 & appears_T2(2:end) == 1); 

idx_T3_disappears = find(appears_T3(1:end-1)==1 & appears_T3(2:end) == 0); 
idx_T3_appears = find(appears_T3(1:end-1)==0 & appears_T3(2:end) == 1); 

%% 
% the number of indices for T3 ends indicates total number of reaches
% the number of in2out indices may be one more than out2in because of how
% priyanka did the experiment
numoftrials = length(idx_T3_disappears);

%trial 
% to find the start point for outward reach to T1
V_START = .001;    % velocity needs to be below .001m/s to qualify as start 
V_END = .03;       % velocity needs to be below .03m/s to qualify as end
v_out = velocity( idx_T1_appears(1)+1 : idx_T1_disappears(1) ); % outward reach velocity
is_v_low = (v_out < V_START);                 
if_hit_home = Home( idx_T1_appears(1)+1 : idx_T1_disappears(1) ); 

% find indices for points that suffice the critia
indices = find(is_v_low & if_hit_home);  % index for variable v, not for velocity
                                            % transformation to velocity,
                                            % use "idx_T1_starts(1) +
                                            % idx_potential_start"
                                            % name as IDX_... for the
                                            % overall velocity profile
% If more than one index, use local minimum as start/end point    
if length(indices) > 1 % identify the minimum velocity and use it as end
    idxs = find(v_out == islocalmin(v_out));
    if length(idxs) > 1  % if more than 1 local minima, use the last one
        idxl_out_start = idxs(end);
    else
        idxl_out_start = idxs;
    end
else
    idxl_out_start = indices;   % idxl: index for a local time window
end

v_out(idxl_out_start) == velocity(idx_T1_appears(1)+idxl_out_start)
idx_outStarts = idx_T1_appears(1)+idxl_out_start;
%%
% to find the start point for inward reach from T1, which is also the end
% point for outward reach to T1
v_in = velocity( idx_T1_disappears(1)+1 : idx_T2_appears(1) );
is_vin_low = (v_in < V_END); % velocity below .03 m/s
if_hit_target = T1( idx_T1_disappears(1)+1 : idx_T2_appears(1) ); 

indices = find(is_vin_low & if_hit_target);

if length(indices) > 1 % identify the minimum velocity and use it as end
    idxs = find(v_in == islocalmin(v_in));
    if length(idxs) > 1  % if more than 1 local minima, use the last one
        idxl_in_start = idxs(end);
    else
        idxl_in_start = idxs;
    end
else
    idxl_in_start = indices;
end

v_in(idxl_in_start) == velocity(idx_T1_disappears(1)+idxl_in_start)
idx_inStarts = idx_T1_disappears(1)+idxl_in_start;
%% find maximum v during a reach btw out_start and in_start
[vml, idxl_vm] = max( velocity(idx_outStarts:idx_inStarts) );
idx_vmax = idxl_vm + idx_outStarts -1;   % make sure local index translates to global index correctly
velocity(idx_vmax);
%% plot out. see if that makes sense in plots
tempv = velocity(1:idx_T1_appears(2)); % for a whole trial

close all

plot(tempv)
hold on
plot( idx_T1_disappears(1)+idxl_in_start, velocity(idx_T1_disappears(1)+idxl_in_start), '*' )
hold on
plot( idx_T1_appears(1)+idxl_out_start, velocity(idx_T1_appears(1)+idxl_out_start), '*' )
hold on
% add maximums
plot( idx_vmax, velocity(idx_vmax), '*' )
%%
figure
plot(velocity(idx_outStarts:idx_inStarts))
hold on 
plot (idxl_vm, vml, '*' )