function [x, y] = MarkVelocity(Velocity, vpmarker_x, vpmarker_y, biofbX, biofbY)
%------ Visually inspect and mark velocity profile -----------
% Boki Wang
% August 2018
%-------------------------------------------------------------
% Interactive figure to select and change the markers on the velocity
% profile. 
%
% Inputs:
% Velocity: the velocity vector
% vpmarker_x: vector for all the indices of the start and end of each
% reach. WARNING: this variable will be changed as the function is running
% due to figure updates.
% vpmarker_y: vector for all the velocity values of the start and end of
% each reach. WARNING: this variable will be changed as the function is running
% due to figure updates.
% Outputs: 
% vpmarker_x, vpmarker_y. See Inputs. 
% ---------------------- End -----------------------------------


max_idx = length(vpmarker_x);

fig = figure;
ld = linkdata(fig);

% local variables to avoid misconfusion
x = vpmarker_x;
y = Velocity(vpmarker_x);

% assign x and y to base workspace to enable data linking
assignin('base','vpmarker_x',x);
assignin('base','vpmarker_y',y);

plot(Velocity, 'blue')
hold on
hdl = plot(vpmarker_x, vpmarker_y, '*', 'col','red' );  % draw all the starts, and link data
hdl.XDataSource = 'vpmarker_x';
hdl.YDataSource = 'vpmarker_y';

msg = sprintf('Visual inspection of velocity profile');
title(msg)

to_exit = 0;

while ( ~to_exit )
       clear cursor_info
       choice = menu('Select Change if you want to change markers','Change','Double Check','Done');
       fig = gcf;
       
       switch choice
            case 1              
                dcm_obj = datacursormode(fig);
                set(dcm_obj,'DisplayStyle','datatip',...
                'SnapToDataVertex','on','Enable','on', 'UpdateFcn',@datatip_dummy)
                title('Click the point to be edited, then press Return.')
                % Wait while the user does this.
                pause                  
                % Get the data point to be changed
                c_info = getCursorInfo(dcm_obj);
                idx_tochange = c_info.DataIndex
                % need to make sure that index is in the range
                    % 1. idx_tochange belongs within xrange
                    % 2. because the largest idx to change is length(all_starts), and
                    % it's very unlikely that the point selected will have an actual
                    % x_index (that of the velocity profile) that is that small
                if idx_tochange <= 0 | idx_tochange > max_idx          
                    title('Invalid point selection. Select again')
                else
                    title('Point selected. Click on the corrected position, then press Return.')
                    pause
                    % get the right one                    
                    c_info = getCursorInfo(dcm_obj);
                    x(idx_tochange) = c_info.Position(1);
                    title('Data point was successfully updated.')
                    % updating the info. 
                    y = Velocity(x);
                    assignin('base','vpmarker_x',x);
                    assignin('base','vpmarker_y',y);
                    refreshdata(hdl)
                end
           case 2
               [wrong_idx, wrong_starts] = DoubleCheck(x, biofbX, biofbY)
               title('Check command window for any wrong markers.')
           case 3
                close all
                to_exit = 1;
       end                     
end

function output_txt = datatip_dummy(obj,event_obj)
% Display the position of the data cursor
    output_txt=[];
end


end
