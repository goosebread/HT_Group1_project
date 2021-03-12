%Alex Yeh 3/5/2021
%Project Interim Report

%plots n sets of data
%Assumes BITalino EMG raw data/uses adcTomV. Must be modified to support other
%calibration methods

%takes in arrays for dataFiles and titles
%all files must have the same sampling rate and time duration
%graphs the signals in time and frequency domains
function spectrogramMany(dataFiles,n,sr,time,titles)
    datamV=zeros(time*sr,n);%time*sr points per set, n sets of data
    for i=1:n
        %open file
        fid=fopen(dataFiles(i));
        
        %loop through file
        r=1;
        while (~feof(fid)&&r<=time*sr)
            txtLine = fgetl(fid);

            %ignore headers that start with '#'
            if ~strncmpi(txtLine,'#',1)
              C=strsplit(txtLine);
              %bitalino raw data on 6th col
              %converts from raw data to mV
              datamV(r,i)=adcTomV(str2double(C(6)));
              r=r+1;
            end
        end
    fclose(fid);
    end  
    
    %time in seconds
    time_s = (0:time*sr-1)./sr;
    
    %butterworth bandstop filter for 60Hz power line noise
    [b,a] = butter(4,[59.5/(sr/2) 60.5/(sr/2)],'stop');
    %180 noise
    [b2,a2] = butter(4,[179.5/(sr/2) 180.5/(sr/2)],'stop');

        
    for i=1:n
        
        % Code from EECE2520
        % Plot time-domain original signal and its corresponding spectrogram in one
        % plot.  First we plot the time-domain signal.      

        
        %filtered data
        fdata=filter(b2,a2,filter(b,a,datamV));
        
        figure
        hold on
        subplot(2,1,1)
        plot(time_s,fdata(:,i));
        xlabel('Time (s)')
        ylabel('Voltage (mV)')
        ylim([-2,2]);
        title(titles(i))
        xlim([0 time_s(end)]);
        position_dim1=get(gca,'Position');   %Position of this subplot needed to line up with spectrogram
        
        % Plot normalized spectrogram image of the original time-domain signal.  The
        % spectrogram is obtained by running-average short-time Fourier transform.
        
        subplot(2,1,2)
        plot_spectrogram(fdata(:,i),sr)
        position_dim2=get(gca,'Position');
        set(gca,'Position',[position_dim1(1) position_dim2(2) position_dim1(3) position_dim1(4)]);
        title(append(titles(i)," Spectrogram"))
              
    end
end