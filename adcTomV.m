%Alex Yeh 3/5/2021
%HT Lab 2

%Converts BITalino raw digital data to mV
%transfer function available on BITalino website
%https://bitalino.com/storage/uploads/media/electromyography-emg-user-manual.pdf
function m=adcTomV(value)
    %default parameters
    n=10;%10 bit sampling resolution
    VCC=3.3;%3.3V operating voltage for bitalino
    GEMG=1009;%gain
    
    %this equation is written to be easy to read
    %it could be optimized for better computing time
    m=(1000*VCC/GEMG)*(value/pow2(n)-0.5);    
end