% Analyze to get dependent variables

% WARNING: clear all workspace variable before execute this file. 

% store as struct? T1 T2 T3? 
% For one subject, each condition is stored in a different struct
    % Baseline. -> T1out. -> (vel_cell, pos_cell, dirError_array, etc).
    %          -> T2out. -> (vel_cell, pos_cell, dirError_array, etc).
    %          -> T3out. -> (vel_cell, pos_cell, dirError_array, etc).
    % pre30. -> T1out. -> ...
    %      . -> .......
    % adapt45. -> blablabla
   
% Start of code
% Set-up values
T1out.angle = atand( 0.13788/(-0.1157) );
T2out.angle = 90;
T3out.angle = atand( 0.13788/0.1157 );
% decompose pos, vel, acc matrices into cells per reach.
%   omit inward trials for now. 
pos_cell = cell(numoftrials,1);
vel_cell = cell(numoftrials,1);
acc_cell = cell(numoftrials,1);

pos_atpeak = zeros(numoftrials,3);
vvec_atpeak = zeros(numoftrials,3);
vmag_atpeak = zeros(numoftrials,1);
vangle_atpeak = zeros(numoftrials,1);

resultntvel_cell = cell(numoftrials, 1);
for i = 1:numoftrials
    % pos_cell. Each element is n-by-3 array
    T1out.pos_cell{i,1} = pos_matrix( T1_out_starts(i):T1_in_starts(i),: );
    T2out.pos_cell{i,1} = pos_matrix( T2_out_starts(i):T2_in_starts(i),: );
    T3out.pos_cell{i,1} = pos_matrix( T3_out_starts(i):T3_in_starts(i),: );
   
    % vel_cell. Each element is n-by-3 array
    T1out.vel_cell{i,1} = vel_matrix( T1_out_starts(i):T1_in_starts(i),: );
    T2out.vel_cell{i,1} = vel_matrix( T2_out_starts(i):T2_in_starts(i),: );
    T3out.vel_cell{i,1} = vel_matrix( T3_out_starts(i):T3_in_starts(i),: );
    
    % acc_cell. Each element is n-by-3 array
    T1out.acc_cell{i,1} = acc_matrix( T1_out_starts(i):T1_in_starts(i),: );
    T2out.acc_cell{i,1} = acc_matrix( T2_out_starts(i):T2_in_starts(i),: );
    T3out.acc_cell{i,1} = acc_matrix( T3_out_starts(i):T3_in_starts(i),: );
    
    % location at peak velocity. n-by-3 array indicating [x y z]
    T1out.pos_atpeak(i,:) = pos_matrix( T1_pkout_x(i),:);
    T2out.pos_atpeak(i,:) = pos_matrix( T2_pkout_x(i),:);
    T3out.pos_atpeak(i,:) = pos_matrix( T3_pkout_x(i),:);
 
    % xy-projection angle of position at peak velocity. In degrees. N-by-1
    T1out.pangle_atpeak(i,1) = atand( T1out.pos_atpeak(i,2)/T1out.pos_atpeak(i,1) );
    T2out.pangle_atpeak(i,1) = atand( T2out.pos_atpeak(i,2)/T2out.pos_atpeak(i,1) );
    T3out.pangle_atpeak(i,1) = atand( T3out.pos_atpeak(i,2)/T3out.pos_atpeak(i,1) );
    
    % velocity vector at peak velocity. n-by-3 array indicating [vx vy vz]
    T1out.vvec_atpeak(i,:) = vel_matrix( T1_pkout_x(i),:);
    T2out.vvec_atpeak(i,:) = vel_matrix( T2_pkout_x(i),:);
    T3out.vvec_atpeak(i,:) = vel_matrix( T3_pkout_x(i),:);
    
    % peak velocity magnitude. Each n-by-1
    T1out.vmag_atpeak(i,1) = velocity( T1_pkout_x(i),:);
    T2out.vmag_atpeak(i,1) = velocity( T2_pkout_x(i),:);
    T3out.vmag_atpeak(i,1) = velocity( T3_pkout_x(i),:);
    
    % peak velocity direction in degrees. Each n-by-1
    T1out.vangle_atpeak(i,1) = atand( T1out.vvec_atpeak(i,2)/T1out.vvec_atpeak(i,1) );
    T2out.vangle_atpeak(i,1) = atand( T2out.vvec_atpeak(i,2)/T2out.vvec_atpeak(i,1) );
    T3out.vangle_atpeak(i,1) = atand( T3out.vvec_atpeak(i,2)/T3out.vvec_atpeak(i,1) );
    
    % resultant velocity. 16-by-1 cell
    T1out.resultntvel_cell{i,1} = velocity( T1_out_starts(i): T1_in_starts(i) )';
    T2out.resultntvel_cell{i,1} = velocity( T2_out_starts(i):T2_in_starts(i) )'; 
    T3out.resultntvel_cell{i,1} = velocity( T3_out_starts(i):T3_in_starts(i) )'; 
end

%% plots
PlotAndExplore(T1out, T2out, T3out, numoftrials)
%% save and clear workspace
% first condition - save. others - change name and append

post30.T1 = T1out;
post30.T2 = T2out;
post30.T3 = T3out;

%save('Pilot01_FirstLevel.mat','baseline')
save('Pilot01_FirstLevel.mat','post30','-append')
clear all
