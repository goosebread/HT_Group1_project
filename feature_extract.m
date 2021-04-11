%Alex Yeh 4/7/2021
%Project Final Report

%Performsfeature extraction on raw BITalino measurements

%output is separate txt file for further processing

%num=[1,2,3] -> [palm down, palm up, sideways]
%subject=u -> unnas
function feature_extract(subject,num)
group=append(subject,"_",num2str(num));
sr=1000;
stime=0;
etime=10;

if (subject=="m")
    format=3;
else
    format=1;%depends on which order the bitalinos were connected
end

%intended angles to try
int_ang=[-80:20:80];

%no f80 in unnas group 2 due to physical limitations
%e80-b in maxim group 3 file got lost
if num==2
    int_ang=int_ang(2:end);
end

%3 identical trials per data
trials=["a","b","c"];

ending = strings(1,length(int_ang));
%hard coding file paths
for i=1:length(int_ang)
    if int_ang(i)>0
        ending(i)=append("e",num2str(int_ang(i)),".txt");
    else
        ending(i)=append("f",num2str(-int_ang(i)),".txt");
    end
end

%output file
fid=fopen(append(group,"_output.txt"),'w');
fprintf(fid,'#trial\t angle\t calculated angle\t flexion power\t extension power\n');
%add header line?

%acc calibration values
[acc_up,~,~,~]=loadData("acc_up.txt",1000,0,10,2);
[acc_down,~,~,~]=loadData("acc_down.txt",1000,0,10,2);
[gval,gzero]=gcalibrate(acc_up,acc_down);

%butterworth bandstop filter for 60Hz power line noise
[b,a] = butter(4,[59.5/(sr/2) 60.5/(sr/2)],'stop');
%180 noise
[b2,a2] = butter(4,[179.5/(sr/2) 180.5/(sr/2)],'stop');


%experimental data
for t=1:length(trials)
    for ia=1:length(int_ang)
        
        %hard coded file paths
        datafile=append(subject,"/",group,"/",group,trials(t),"_",ending(ia));
        
        %check for valid file, skip if necessary
        f=fopen(datafile);
        if (f==-1)
            break;
        else
            fclose(f);
        end
        
        %load data
        [acc,f_emg,e_emg,~]=loadData(datafile,sr,stime,etime,format);
        [acc,f_emg,e_emg]=calibrateData(acc,f_emg,e_emg,gval,gzero);
        
        %calculated angle using accelerometer
        switch(num)
            case 1
                x=mean(acc)/9.81;
                if x*x>=1
                    fprintf("oops, %d,%i,%i",x*x,t,ia);
                    x=1;
                end
                cal_ang=acosd(x);
            case 2
                x=-mean(acc)/9.81;
                if x*x>=1
                    fprintf("Warning: recalibrate accelerometer, %d,%i,%i\n",x*x,t,ia);
                    x=1;
                end
                cal_ang=acosd(x);
            case 3
                cal_ang=0;%zero correlation when accelerometer axis is orthogonal to gravity
            otherwise
                throw("invalid group number");
        end
                
        %filter out power line noise
        f_emg=filtfilt(b2,a2,filtfilt(b,a,f_emg));
        e_emg=filtfilt(b2,a2,filtfilt(b,a,e_emg));
        
        %total power calculations
        fpower=bandpower(f_emg,sr,[0 sr/2]);
        epower=bandpower(e_emg,sr,[0 sr/2]);
        
        %output to file
        fprintf(fid,'%i %i %d %d %d\n',t,int_ang(ia),cal_ang,fpower,epower);
    end
end

%close output file
fclose(fid);
end