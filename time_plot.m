%Alex Yeh 3/30/2021
%Project Final Report

%testing script

%plots first 10 seconds of signals in time domain
try
    %enter filename here
    dataFile="e60.txt";
    format=1;
    
    %acc calibration values
    [acc_up,~,~,~]=loadData("acc_up.txt",1000,0,10,2);
    [acc_down,~,~,~]=loadData("acc_down.txt",1000,0,10,2);
    [gval,gzero]=gcalibrate(acc_up,acc_down);
    
    [a1,ef1,ee1,t1]=loadData(dataFile,1000,0,15,format);
    [a1,ef1,ee1]=calibrateData(a1,ef1,ee1,gval,gzero);
    
    %time domain analysis
    figure('NumberTitle', 'off', 'Name', "full_range");
    hold on
    
    subplot(3,1,1)
    plot(t1,a1)
    xlabel('Time (s)');
    ylabel('acc (m/s2)');
    title("acc");
    
    subplot(3,1,2)
    plot(t1,ef1)
    xlabel('Time (s)');
    ylabel('Voltage (mV)');
    title("Flexion");
    
    subplot(3,1,3)
    plot(t1,ee1)
    xlabel('Time (s)');
    ylabel('Voltage (mV)');
    title("Extension");
    
    
catch exception
    throw(exception)
end