% Creating a notch filter
Fs = 8e3;    % 8 kHz sampling frequency
F01 = 3e3;   % Notch at 1 kHz for Filter 1
BW = 200;    % 500 Hz bandwidth for both filters
[b, a] = iirnotch(F01/(Fs/2), BW/(Fs/2)) ;
[notch , phase] = freqz(b,a);
plot(abs(notch));