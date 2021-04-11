%Code provided from EECE2520


function plot_spectrogram(signal,Fs,delay)
%This function plots the normalized spectrogram of a signal.
%The input signal is in the time domain.
%'Fs' is the sampling frequency.
% Attention: 'signal' should be real(make it real if not)

[~,s_f,s_t,s_p]=spectrogram(signal,256,256*0.75,2048,Fs);

%colmax=max(max(abs(s_p)));
colmax=0.001;
%(color in dbm or dbu?)

%figure;
imagesc(s_t+delay,s_f,10*log10(s_p/colmax));
axis xy
colormap jet
caxis([-40 -10])
c = colorbar;
c.Label.String = 'Power Density (dB)';
%set(gca,'fontsize',18);
% title('Signal spectrogram (Normalized)')
% xlabel('time (s)');
% ylabel('frequency (Hz)');
end

