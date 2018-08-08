function PlotAndExplore(T1out, T2out, T3out, numoftrials)
% some early stage plots

close all

fs = 100.251;
% position data
figure
for i = 1:numoftrials
    plot(T1out.pos_cell{i}(:,1), T1out.pos_cell{i}(:,2),'blue')
    hold on
    plot(T2out.pos_cell{i}(:,1), T2out.pos_cell{i}(:,2),'green')
    plot(T3out.pos_cell{i}(:,1), T3out.pos_cell{i}(:,2),'magenta')
    xlabel('x')
    ylabel('y')
    title('Trajectory and Peak Velocity Vectors')
    % plot peak velocity by Quiver plots
    %   peak velocity has to be .10 times real size
    quiver( T1out.pos_atpeak(i,1), T1out.pos_atpeak(i,2), ...
        T1out.vvec_atpeak(i,1)/100, T1out.vvec_atpeak(i,2)/100,...
        'Color', 'k','LineWidth',2,'MaxHeadSize',3);
    quiver( T2out.pos_atpeak(i,1), T2out.pos_atpeak(i,2), ...
        T2out.vvec_atpeak(i,1)/100, T2out.vvec_atpeak(i,2)/100,...
        'Color', 'k','LineWidth',2,'MaxHeadSize',3);
    quiver( T3out.pos_atpeak(i,1), T3out.pos_atpeak(i,2), ...
        T3out.vvec_atpeak(i,1)/100, T3out.vvec_atpeak(i,2)/100,...
        'Color', 'k','LineWidth',2,'MaxHeadSize',3);
end
%%
% velocity
figure
% T1
for i = 1:numoftrials
    nf = length(T1out.vel_cell{i});
    t= 0: 1/fs : (nf-1)/fs;
    subplot(2,1,1)
    plot(t, T1out.vel_cell{i}(:,1),'blue')
    title('x position')
    hold on
    subplot(2,1,2)
    plot(t,T1out.vel_cell{i}(:,2),'blue')
    title('y position')    
    hold on
    xlabel('Time')
    ylabel('Velocity')
end

% resultant velocity
figure
% T1
for i = 1:numoftrials
    nf = length(T1out.resultntvel_cell{i});
    t= 0: 1/fs : (nf-1)/fs;
    plot(t, T1out.resultntvel_cell{i}','blue')
    title('resultant velocity profile for T1')
    hold on
    xlabel('Time')
    ylabel('Velocity')
end


% end
end