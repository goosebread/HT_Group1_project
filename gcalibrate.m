%Alex Yeh 3/30/2021
%Project Final Report

%gives magnitude of g and the zero acceleration value
%takes in raw data of gravity acting when board is facing up 
%and when board is facing down
function [gval,gzero]=gcalibrate(acc_up,acc_down)
    g1=mean(acc_up);
    g2=mean(acc_down);
    gzero=(g1+g2)/2;
    gval=(g1-g2)/2;
end