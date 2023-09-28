f = 3e3; 
df = 5e2;
% fs is the sampling frequency
fs = 10e3;

% Creating a band-pass filter at tinnitus frequency to replicate the Frequency Perception Model
[b , a] = butter(2 , [f-0.5*df ,f+0.5*df]/fs,"bandpass" );
[Mag , phase] = freqz(b,a);

% Creating a array of central frequencies of the notch filter for the video
f = [10 : 200 :fs/5  fs/5 : 20 : fs/2.5 fs/2.5 :200 :fs-100];

 % Band-Width of the Notch filter
BW = 200 ;
l = length(Mag) ;
n = 0 : length(Mag)-1 ;
oscillation = 0.12*sin(2*pi*n*1/512) ;

for i = 1:length(n)
    perception(i) = 1 + abs(Mag(i)) + oscillation(i);
end

% frequency model of perception
perception_real = [ fliplr(perception) perception];

% Creating AWGN
noise = awgn(zeros(1 ,2*l) ,0);
k = 0 : length(perception_real)-1; 

% ringing represents the tinnitus ringing
ringing = 4*sin(2*pi*k*1.51e3/fs);
ringing_fft = fftshift(fft(ringing));

% ring represents the twice FFT of tinnitus ringing
ring = abs(fftshift(fft(ringing_fft)));

% Decreasing the offset of the ring which represents the tinnitus ringing
ring_osc = ring - max(ring)/2;

% Converting the tinnitus ringing into square waves
for i = 1:length(ring_osc);
    if ring_osc(i)>= 0
        ring_square(i) = max(ring_osc);
    else if ring_osc(i)<0
            ring_square(i) = 0;
    end
    end
end

% adjusting the frequency of tinnitus to the ringing frequency
figure(3);
hold on;
plot(abs(fftshift(fft(ringing))));
plot(max(abs(fftshift(fft(ringing))))*perception_real-max(abs(fftshift(fft(ringing)))));
title("Comparing the frequency of Frequency Perception Model to the Tinnitus ringing");
hold off;

% Creating Video Dhwani.avi representing the suppression of tinnitus ringing when the notch is at the rise in the Frequency Perception Model
V = VideoWriter("Dhvani.avi");
open(V);

% Creating the notch filter
for i = 1:length(f)
    [B, A] = iirnotch(f(i)/(fs), BW/(fs/2)) ;
    [notch , phase] = freqz(B , A);
    eq_perception = perception.*(abs(notch))';
    even_eq_perception = [fliplr(eq_perception) eq_perception];
    percieved_ringing_notch = even_eq_perception.*ringing_fft;
    received_ringing = abs(fftshift(fft(percieved_ringing_notch)));
    figure(i+5);
    subplot(2,1,1);
    plot([10000 received_ringing 10000]);
    subplot(2,1,2);
    plot([2.5 eq_perception]);
    % Taking each figure produced to make a video frame by frame
    frame = getframe(gcf);
    writeVideo(V,frame);
end

close(V);





