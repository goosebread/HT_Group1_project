%Alex Yeh 3/30/2021
%Project Final Report

%testing script

%goal:
%get angles - intended angle, photo angle, acc calibrated angle
%need photo angle data still

%plots accelerometer measured angle vs intended angle
%manual correction is used for flexion angle signs (negative)
%zero drift from not level rest position is corrected for

%trendline/correlation could be implemented in future

try

%acc calibration values
[acc_up,~,~,~]=loadData("acc_up.txt",1000,0,10,2);
[acc_down,~,~,~]=loadData("acc_down.txt",1000,0,10,2);
[gval,gzero]=gcalibrate(acc_up,acc_down);

iangles=[-60,-40,-20,0,20,40,60];
afiles=["f60.txt","f40.txt","f20.txt","f0.txt","e20.txt","e40.txt","e60.txt"];
cangles=iangles;

for i=1:length(afiles)
    %not the most efficient. im loading the emg data anyways i guess
    [a1,ef1,ee1,t1]=loadData(afiles(i),1000,0,15,1);
    [a1,ef1,ee1]=calibrateData(a1,ef1,ee1,gval,gzero);
    
    x=mean(a1)/9.81;
    if x*x>=1
        x=1;
        fprintf("oops, %i",i);
    end
    cangles(i)=acosd(x);
end


figure('NumberTitle', 'off', 'Name', "angles_corrected");  
hold on

%invert first 4 measurements (f prefixed files)
for i=1:4
    cangles(i)=-cangles(i);
end

%correct for zero drift
zero_drift=cangles(4);
cangles=cangles-zero_drift;

scatter(iangles,cangles);
title("acc angles corrected");
%im sure theres a correlation function somewhere if needed for further analysis. its not too bad to
%calculate tho

xlabel("intended angle (deg)");
ylabel("measured angle (deg)");



    
    
catch exception
    throw(exception)             
end