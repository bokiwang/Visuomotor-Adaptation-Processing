function filtered_data = ApplyFilter(raw_data, fc, figuretitle)
% ------------- apply filter to raw data -------- 
% Boki
% August 2018
% -----------------------------------------------
% Use zero-lag 10th order butterworth filter on data and show visualization
%
% Inputs: raw_data; cutoff frequency; figure title
% Output: filtered_data 
%
% --------------- End ---------------------------

fs = 100.251;
nf = length(raw_data);
t= 0: 1/fs : (nf-1)/fs;

% lowpass filter
wn = [fc/(fs/2)];
[B,A] = butter(10,wn,'low');
filtered_data = filtfilt(B,A,raw_data);

% figure
% plot([filtered_data, raw_data]);
% legend(['Filterd @ ', num2str(fc), 'Hz'],'Raw Data')
% title(figuretitle)

end
