% fs = 10e3;
% k=1;
% n = 0 : 1/fs : k - 1/fs ;
% a = 0.7;
% offset = 2 ;
% 
% for i = 1:length(n)
%     model(i) = offset + (n(i) - a)^2 - 0.6*(n(i)-0.2)^8 - 0.6*(abs(n(i)-0.4))^0.5 + 0.5*n(i)^3 ;
% end
% % model(floor(length(n)/3)) = 
% model_noise = model + 0.004*randn([1 , length(n)]);
% 
% figure(1);
% plot(model);
% 
% figure(2);
% plot(model_noise);
% 
% figure(3);
% plot(-10*log10(model_noise-min(model_noise)+0.001));
% 
% noise = randn([1 , length(n)]);
% oscillation = 0.02*sin(2*pi*1e1*n);
% audio = noise + oscillation ;
% figure(4);
% plot(oscillation); 
% 
% figure(5);
% plot(audio);
% 
% figure(6);
% plot(abs(fftshift(fft(noise))));



%Tinnitus Frequency Model
close all 
Fs = 44100;%Playback fequency of Sound 
t = 0:1/Fs:1 ;
prompt = ('Enter Tinnitus Frequency ( Proper Range Hz )')
f_T = input(prompt);
y = cos(2*pi*(f_T)*t) + randn(1,Fs+1)
%Time domain representation of Tinnitus signal 
figure(1)
plot(t,y)
title("Time Domain representation of Tinnitus Signal")
xlabel("Time")
ylabel("Tinnitus Signal")
Yf = fft(y,1024);
freq = -511*Fs/1024:Fs/1024:512*Fs/1024 ;
figure(2)
plot(freq,fftshift(abs(Yf)))
title("Frequency domain representation of Tinnitus Signal")
xlabel("Frequency")
ylabel("Amplitude")
%AWGN + Ringing  
freq_1 = -511*Fs/1024:Fs/1024:512*Fs/1024 ;
A_f = 1*cos(2*pi*0*freq_1)+0.001*cos(2*pi*(f_T)*freq_1);%Ringing Matched with Tinnitus Frequency
figure(3)
plot(freq_1,A_f)
title("AWGN")
figure(4)
plot(freq_1,((fftshift(abs(Yf))).*(A_f))/10)
title("Showing that the ringing is heard max at Tinnitus Frequency")



