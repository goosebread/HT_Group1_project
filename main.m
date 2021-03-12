%Alex Yeh 3/5/2021
%HT Lab 2

sr=1000;%1000 Hz sample rate

stime=5;%30 second samples
etime=35;

time =30;

%part 1
%graphMany(["th_flex.txt","th_ext.txt","th_rad.txt","th_uln.txt","th_pro.txt","th_sup.txt"],6,sr,time,["flex","ext","rad","uln","pro","sup"])

graphMany(["signal_emg_maxim_pinch.txt","u_p.txt","p5.txt"],3,sr,stime,etime,["Control 1 Pinch","CTS 1 Pinch","Control 2 Pinch"])
spectrogramMany(["signal_emg_maxim_pinch.txt","u_p.txt","p5.txt"],3,sr,time,["Control 1 Pinch","CTS 1 Pinch","Control 2 Pinch"])

%graphMany(["m_h2.txt","u_h2.txt","u_h3.txt"],3,sr,time,["maxim hold","unnas hold","unnas hold2"])
%spectrographMany(["m_h2.txt","u_h2.txt","u_h3.txt"],3,sr,time,["maxim hold","unnas hold","unnas hold2"])

graphMany(["m_h2.txt","u_h3.txt","a_h3.txt"],3,sr,stime,etime,["Control 1 Hold","CTS 1 Hold","Control 2 Hold"])
spectrogramMany(["m_h2.txt","u_h3.txt","a_h2.txt"],3,sr,time,["Control 1 Hold","CTS 1 Hold","Control 2 Hold"])





%part 2
%graphMany(["th_pinch.txt","th_fist.txt","th_typing.txt"],3,sr,time,["pinch","fist","typing"])