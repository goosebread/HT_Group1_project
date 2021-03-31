%Alex Yeh 3/30/2021
%Project Final Report

%calibrates acc data to m/s^2
%calibrates emg data to mV

function [acc,emg1,emg2]=calibrateData(r_acc,r_emg1,r_emg2,gval,gzero)
%calibrate acc data
acc=(r_acc-gzero)*9.81/gval;

%calibrate emg data
emg1=adcTomV(r_emg1);
emg2=adcTomV(r_emg2);

end



