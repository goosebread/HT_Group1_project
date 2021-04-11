%Alex Yeh 3/30/2021
%Project Final Report

%plots n sets of data
%

%takes in arrays for dataFiles and titles
%all files must have the same sampling rate and time duration
%graphs the signals in time and frequency domains

%doesn't actually cut data before start time, just hides it
function spectrogramMany(dataFiles,n,sr,stime,etime,titles,figtitle)
    datamV=zeros(etime*sr,n);%time*sr points per set, n sets of data
    for i=1:n
        %open file
        fid=fopen(dataFiles(i));
        
        %loop through file
        r=1;
        while (~feof(fid)&&r<=etime*sr)
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
    
    %remove extra data at start
    datamV = datamV(stime*sr+1:etime*sr,:);

    %time in seconds
    time_s = (stime*sr:etime*sr-1)./sr;
    
    %butterworth bandstop filter for 60Hz power line noise
    [b,a] = butter(4,[59.5/(sr/2) 60.5/(sr/2)],'stop');
    %180 noise
    [b2,a2] = butter(4,[179.5/(sr/2) 180.5/(sr/2)],'stop');
    %filtered data
    fdata=filter(b2,a2,filter(b,a,datamV));
        
    figure('NumberTitle', 'off', 'Name', figtitle);  
    hold on
    
    for i=1:n
        
        subplot(n,1,i);
        plot_spectrogram(fdata(:,i),sr,stime)
        
        xlabel('Time (s)')
        ylabel('Frequency (Hz)')
        title(append(titles(i)," Spectrogram"))
        %xlim([stime,etime]);
              
    end
end