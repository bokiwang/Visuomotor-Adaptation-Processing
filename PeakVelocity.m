% Project: tDCS and visuomotor adaptation
% Piot data analysis
% Preprocessing from raw data
% August 6, 2018
% Boki Wang
% -------------------------------------------------------------
% read in data files from .exp file from the Motion Monitor
% Filter the data
% Identify the start of each reach. And the time of peak velocity in each.
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

clear delimiterIn headerlinesIn start_path
% display info for inspection
% disp([A.textdata(9,:)]);

%% get variables
% Biofeedback info to derive trial info.
biofbX = A.data(:,16); %Biofeedback x and y
biofbY = A.data(:,17);

% To be filtered
% {'pos_x','pos_y','pos_z','vel_x','vel_y','vel_z','vel_mag','acc_x','acc_y','acc_z','acc_mag'}
raw_data = A.data(:, 5:15);
% filter data
fc = 8; % cutoff freq
filtered_data = ApplyFilter(raw_data, fc, 'all raw data');
% parcel out data
pos_matrix = filtered_data(:,1:3); % position data from [X Y Z]
vel_matrix = filtered_data(:,4:6); 
velocity = filtered_data(:,7);  % this is absolute value of resultant velocity 
acc_matrix = filtered_data(:, 8:10);
acceleration = filtered_data(:,11); % this is resultant acceleration

% get rid of unwanted variables
clear A raw_data
%% Auto find trial starts
[all_starts, numoftrials] = FindAllStartPoints(velocity, biofbX, biofbY);

%% Visual Inspection and mark

% Mark Velocity Profile and double check. 
% set up markers for data linking to update figure
vpmarker_x = all_starts;
vpmarker_y = velocity(all_starts);
% mark 
[x, y] = MarkVelocity(velocity, vpmarker_x, vpmarker_y, biofbX, biofbY);
all_starts = x;
% clear workspace
clear x y vpmarker_x vpmarker_y
% separate reaches
T1_out_starts = all_starts(1:6: 1+(numoftrials-1)*6);
T1_in_starts = all_starts(2:6: 2+(numoftrials-1)*6);
T2_out_starts = all_starts(3:6: 3+(numoftrials-1)*6);
T2_in_starts = all_starts(4:6: 4+(numoftrials-1)*6);
T3_out_starts = all_starts(5:6: 5+(numoftrials-1)*6);
T3_in_starts = all_starts(6:6: 6+(numoftrials-1)*6);
%% DOUBLE CHECK if marked velocity is correct
[wrong_idx, wrong_starts] = DoubleCheck(all_starts, biofbX, biofbY)
% if there are wrong starts, rerun MarkVelocity and remark based on the
% wrong start position
% Then rerun double check until there are no more wrong_starts. 
%% find maximum v during a reach 
[at_maxvel, maxvel] = MaxVel(velocity, all_starts);
% separate reaches
T1_pkout_x = at_maxvel(1:6: 1+(numoftrials-1)*6);
T1_pkin_x = at_maxvel(2:6: 2+(numoftrials-1)*6);
T2_pkout_x = at_maxvel(3:6: 3+(numoftrials-1)*6);
T2_pkin_x = at_maxvel(4:6: 4+(numoftrials-1)*6);
T3_pkout_x = at_maxvel(5:6: 5+(numoftrials-1)*6);
T3_pkin_x = at_maxvel(6:6: 6+(numoftrials-1)*6);


%% Overall check
figure
plot(velocity)
hold on
plot(at_maxvel, maxvel, '*')
plot(all_starts, velocity(all_starts), '*')

%% Save workspace variables
save('pilot_post30_08062018.mat')
    