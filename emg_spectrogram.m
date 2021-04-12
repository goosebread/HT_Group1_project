%Alex Yeh 3/30/2021
%Project Final Report

%testing script

%plots the spectrograms of the flexion and extension emg data 
%at various hand angles. Good for visualizing the data

try
    
subject=    
    group=
    trial=
    
%sample rate
sr=1000;

%acc calibration values
[acc_up,~,~,~]=loadData("acc_up.txt",sr,0,10,2);
[acc_down,~,~,~]=loadData("acc_down.txt",sr,0,10,2);
[gval,gzero]=gcalibrate(acc_up,acc_down);


afiles=["m/m_1/m_1c_f80.txt","m/m_1/m_1c_f60.txt","m/m_1/m_1c_f40.txt","m/m_1/m_1c_f20.txt","m/m_1/m_1c_f0.txt","m/m_1/m_1c_e20.txt","m/m_1/m_1c_e40.txt","m/m_1/m_1c_e60.txt","m/m_1/m_1c_e80.txt"];
atitles=["f80","f60","f40","f20","f0","e20","e40","e60","e80"];

%butterworth bandstop filter for 60Hz power line noise
[b,a] = butter(4,[59.5/(sr/2) 60.5/(sr/2)],'stop');
%180 noise
[b2,a2] = butter(4,[179.5/(sr/2) 180.5/(sr/2)],'stop');
    
figure('NumberTitle', 'off', 'Name', "EMG Spectrograms");  
hold on
    
for i=1:length(afiles)
    %not the most efficient. im loading the emg data anyways i guess
    [a1,ef1,ee1,t1]=loadData(afiles(i),sr,0,15,3);
    [a1,ef1,ee1]=calibrateData(a1,ef1,ee1,gval,gzero);
    
    %filter out power line noise
    ef1=filter(b2,a2,filter(b,a,ef1));
    ee1=filter(b2,a2,filter(b,a,ee1));

    subplot(length(afiles),2,2*i-1);
    plot_spectrogram(ef1',sr,0)

    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title(append(atitles(i)," Flexion"));
     
    subplot(length(afiles),2,2*i);
    plot_spectrogram(ee1,sr,0)

    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title(append(atitles(i)," Extension"));
    
end
   
catch exception
    throw(exception)             
end