%Code provided from EECE2520


function plot_spectrogram(signal,Fs)
%This function plots the normalized spectrogram of a signal.
%The input signal is in the time domain.
%'Fs' is the sampling frequency.
% Attention: 'signal' should be real(make it real if not)

[~,s_f,s_t,s_p]=spectrogram(signal,512,512*0.75,2048,Fs);

colmax=max(max(abs(s_p)));

%figure;
imagesc(s_t,s_f,10*log10(s_p/colmax));
axis xy
colormap jet
caxis([-40 -10])
colorbar
%set(gca,'fontsize',18);
title('Signal spectrogram (Normalized)')
xlabel('time (s)');
ylabel('frequency (Hz)');
end

