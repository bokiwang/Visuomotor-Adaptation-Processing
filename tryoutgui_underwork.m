%%
vrange = [1:T1_out_starts(3)];
vtemp = velocity(vrange);
xrange = [1:length(all_starts)];
max_idx = length(xrange);
fig = figure;
ld = linkdata(fig);

msg = sprintf('Visual inspection of velocity profile');
title(msg)

x = all_starts(xrange);
y = velocity(all_starts(xrange));
plot(velocity, 'blue')
hold on
hdl = plot(x, y, '*', 'col','red' );  % draw all the starts, and link data
hdl.XDataSource = 'x';
hdl.YDataSource = 'y';
test_val = 0;

m = uimenu(fig, 'Text', 'Visual Inspection');
mitem1 = uimenu(m,'Text','Change', 'MenuSelectedFcn',@Change_callback);
mitem2 = uimenu(m, 'Text', 'Done', 'MenuSelectedFcn',@Done_callback);


function Change_callback(KeyPressFcn,max_idx,velocity,x,y,hObj,event)
    
    choice = 'Change'
    fig = gcf;
    dcm_obj = datacursormode(fig);
    set(dcm_obj,'DisplayStyle','datatip',...
        'SnapToDataVertex','on','Enable','on', 'UpdateFcn',@datatip_dummy)
    title('Click the point to be edited, then press Return.')
                % Wait while the user does this.
                pause                  
                % Get the data point to be changed
                c_info = getCursorInfo(dcm_obj);
                idx_tochange = c_info.DataIndex;

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
                    y = velocity(x);
                    assignin('base','vpmarker_x',x);
                    assignin('base','vpmarker_y',y);
                    refreshdata(hdl)
                end
end

function Done_callback(fig, KeyPressFcn)
    choice = 'Done';
end