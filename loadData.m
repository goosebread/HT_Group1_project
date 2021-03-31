%Alex Yeh 3/30/2021
%Project Final Report

%emg1 is flexion data
%emg2 is extension data
%acc is accelerometer data
%time is the vector of time measurements in seconds

%dataFile is a txt file for BITalino measurements
%sr is sample rate, stime is start time(seconds), etime is end time(seconds)
%format = 1 is for experimental data, format = 2 is for accelerometer calibration data

function [acc,emg1,emg2,time]=loadData(dataFile,sr,stime,etime,format)

if format==1
    col_acc=7;
    col_emg1=13;
    col_emg2=6;
elseif format==2
    col_acc=13;
    col_emg1=6;
    col_emg2=12;
else
    ME = MException('Invalid format parameter');
    throw(ME);
end

%empty arrays
acc=zeros((etime-stime)*sr,1);
emg1=zeros((etime-stime)*sr,1);
emg2=zeros((etime-stime)*sr,1);

%open file
fid=fopen(dataFile);

%ignore headers that start with '#'
txtLine = fgetl(fid);
while strncmpi(txtLine,'#',1)
    txtLine = fgetl(fid);
end

%skip data before stime*sr
for r=1:stime*sr
    fgetl(fid);
end

%collect data until etime*sr
r=1;
while (~feof(fid)&&r<=(etime-stime)*sr)
    %load row into a string
    row=strsplit(fgetl(fid));
    
    %store data
    acc(r)=str2double(row(col_acc));
    emg1(r)=str2double(row(col_emg1));
    emg2(r)=str2double(row(col_emg2));

    r=r+1;
end
   
%time in seconds
time = ((stime*sr:etime*sr-1)./sr)';
    
fclose(fid);
end  
    
    