%Alex Yeh 3/5/2021
%HT Lab 2

%plots n sets of data
%Assumes BITalino EMG raw data/uses adcTomV. Must be modified to support other
%calibration methods

%takes in arrays for dataFiles and titles
%all files must have the same sampling rate and time duration
%graphs the signals in time and frequency domains
function graphMany(dataFiles,n,sr,starttime,endtime,titles)

    datamV=zeros(endtime*sr,n);%time*sr points per set, n sets of data
    for i=1:n
        %open file
        fid=fopen(dataFiles(i));
        
        %loop through file
        r=1;
        while (~feof(fid)&&r<=endtime*sr)
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
    
    datamV = datamV(starttime*sr+1:endtime*sr,:);
    time=endtime-starttime;
    
    %butterworth bandstop filter for 60Hz power line noise
    [bs,as] = butter(4,[59.5/(sr/2) 60.5/(sr/2)],'stop');
       %180 noise
    [bs2,as2] = butter(4,[179.5/(sr/2) 180.5/(sr/2)],'stop');
    
           %5hz high pass
    [bh,ah] = butter(4,5/(sr/2),'high');
    
    
    datamV=filter(bs,as,datamV);
    datamV=filter(bs2,as2,datamV);
    datamV=filter(bh,ah,datamV);

    %time in seconds
    time_s = (starttime*sr:endtime*sr-1)./sr;
    
    %frequency data
    dataP=fft(datamV);
    
    %time plots
    figure
    hold on
    for i=1:n
        subplot(n,1,i)
        
        plot(time_s,datamV(:,i))
        xlabel('Time (s)')
        ylabel('Voltage (mV)')
        ylim([-2,2]);
        xlim([starttime,endtime]);
        title(titles(i))
    end
    
    %power spectrum plots
    figure
    hold on
    freq = (0:(time*sr/2))/time;
    for i=1:n
        P1=(dataP(:,i).*conj(dataP(:,i)))/(sr*time);
        
        subplot(n,1,i)
        semilogx(freq,P1(1:sr*time/2+1))
        xlabel('Frequency (Hz)')
        xlim([0 500]);
        %ylim([0,10]);%30,000 for walking
        ylabel('Signal Power')
        title(append(titles(i),' Power Spectrum'))
                
        freq_weights=P1(1:sr*time/2+1)/sum(P1(1:sr*time/2+1));
        avg=sum(freq.*freq_weights');
        
%         second_order_moment=sum((freq.^2).*freq_weights');
%         stdev=sqrt(second_order_moment-avg^2)
%         %stdev=sqrt(var(P1(1:sr*time/2+1)));
%         
%         pband = bandpower(datamV(:,i),sr,[0.7*avg avg]);
%         
%         ptot = bandpower(datamV(:,i),sr,[5 400]);
%         per_power = 100*(pband/ptot)

        legend(['Mean = ' num2str(avg) ' Hz'])

    end
    
    figure
    hold on
    grid on
    for i=1:n
        
        %implement some smoothing with hamming windows, use least squares
        %line to represent data i guess
        
        centroid=spectralCentroid(datamV(:,i),sr,'Window',hamming(round(0.15*sr)),'OverlapLength',round(0.05*sr),'Range',[5,sr/2]);
        %'Window',hamming(round(0.5*sr)),'OverlapLength',round(0.2*sr)
        
        t = linspace(0,size(datamV(:,1),1)/sr,size(centroid,1));
        t=t+starttime;

        
        %5hz low pass to smooth
        %centroid=lowpass(centroid,30,sr);
        %'ImpulseResponse','iir','Steepness',0.95
        
        plot(t,centroid,'x')
        ylabel('Frequency (Hz)')
        xlabel('Time (s)')
        xlim([starttime,endtime]);
        title("Mean Frequency vs Time")

    end
    lsline
    legend(titles)
end