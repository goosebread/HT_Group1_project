%Alex Yeh 4/7/2021
%Project Final Report
% 
% for i=1:3
%     feature_extract("u",i);
% end
% for i=1:3
%     feature_extract("m",i);
% end
output_read(["u","m"]);

%run output_read after



% sr=1000;%1000 Hz sample rate
% 
% stime=4;%30 second samples
% etime=14;
% 
% %time =15;
% 
% %part 1
% efiles=["e_f.txt","e_e.txt","e_r.txt","e_u.txt","e_p.txt","e_s.txt"];
% categories=["Flexion","Extension","Radial Deviation","Ulnar Deviation","Pronation","Supination"];
% 
% ffiles=["f_f.txt","f_e.txt","f_r.txt","f_u.txt","f_p.txt","f_s.txt"];
% 
% 
% %graphMany(efiles,3,sr,stime,etime,["Control 1 Pinch","CTS 1 Pinch","Control 2 Pinch"])
% spectrogramMany(efiles,6,sr,stime,etime,categories,"Extensor Carpi Ulnaris")
% spectrogramMany(ffiles,6,sr,stime,etime,categories,"Flexor Carpi Radialis")
% 
% 
% 


