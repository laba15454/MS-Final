%[abo,fs]=wavread(y); 
abo=y;
ab1=abo(1,:); %取單聲道
%ab1=ab1-mean(ab1);
NFFT = 2^nextpow2(L);
ab2=fft(ab1,NFFT); %傅立葉
%ab2(1:5000)=0;
ab3=[zeros(1,880),ab2(1:NFFT)];  %調整基頻

ab4=real(ifft(ab3,NFFT)); %反傅立葉

ab2=ab2/L;
ab3=ab3/L;
f = Fs/2*linspace(0,1,NFFT/2+1);


subplot(4,1,1);  plot(ab1(1:1000));
subplot(4,1,2);  plot(ab4(1:1000));
subplot(4,1,3);  plot(f,2*abs(ab2(1:NFFT/2+1)));
subplot(4,1,4);  plot(f,2*abs(ab3(1:NFFT/2+1)));

%plot(f(1:length(f)),ab3(1:NFFT/2+1));

sound(ab4,fs);

%{
% Next power of 2 from length of y
Y = fft(y,NFFT)/L;% [zeros(1,NFFT)];
f = Fs/2*linspace(0,1,NFFT/2+1);
length(y)
length(f)
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
%}