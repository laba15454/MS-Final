Fs = 16000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
%duration=2;
%time=(0:duration*Fs-1)/Fs;
L = Fs*2;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x=sin(2*pi*880*t);
%x=sin(2*pi*440*time);
y=x;
%x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
%y = x + 2*randn(size(t));     % Sinusoids plus noise
plot(Fs*t(1:1000),y(1:1000))
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')
sound(y,Fs);