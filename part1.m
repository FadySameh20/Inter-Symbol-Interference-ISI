%Part 1 ISI LAB
close all;
clear all;
clc;

B=100*10^3; % bandwidth of band limited channel //used in band limit channel function
time=0:0.01:10; %random time
T=2/B; %duration of square pulse
Fs = 2700000; %assumed fs 
Fn = Fs/2; % to plot in both sides // left& right
Freq = linspace(-Fn, Fn, numel(time)); %freq axis

pulse1_freq = generate_pulse(0, 0.01, 2, time, Freq, '1', 'r',Fs);%calling generate_pulse function to generate first pulse
filtered_time_pulse1 = filter_pulse(pulse1_freq, '1', 'r', Freq, B,  time, 1,Fs);%calling filter_pulse function to filter first pulse using ideal filter

pulse2_freq = generate_pulse(2, 0.01, 4, time, Freq, '2', 'b',Fs); %calling generate_pulse function to generate second pulses
filtered_time_pulse2 = filter_pulse(pulse2_freq, '2', 'b', Freq, B,  time, 1,Fs);%calling filter_pulse function to filter second pulse using ideal filter


plot(time/10^5,filtered_time_pulse1,'r') % plotting filtered first pulse in time domain
hold on;
plot(time/10^5,filtered_time_pulse2,'b')  % plotting filtered second pulse in time domain
title('Pulses 1&2 filtered in Time Domain')%both first and second pulse together
figure;

sum_filtered_time_pulses = filtered_time_pulse1+filtered_time_pulse2; % adding both filtered pulses
plot(time/10^5, sum_filtered_time_pulses, 'g') % plotting both filtered pulses in time domain
title('Sum of Pulses 1&2 filtered in Time Domain')
figure;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


r = 1; %rolloff factor
f0 = (B)/(1+r); %6 db bw of filter
f_delta = B - f0; % difference between absolute BW and f0 // difference between f0 and f1

%Raised cosine rolloff Nequist filtering equation in time domain 
raised_cos_time = 2 .* f0 .*((sin(2 .* pi .* f0 .* (time/10^5))) ./ (2 .* pi .* f0 .* (time/10^5))) .* ((cos(2 .* pi .* f_delta .* (time/10^5))) ./ (1 - (4 .* f_delta .* (time/10^5)).^2)); 

%handling nan & infinity values
infIndices = find(isinf(raised_cos_time));
nanIndices= find(isnan(raised_cos_time));
if ~isempty(infIndices)
    for i=infIndices
        raised_cos_time(i)=(raised_cos_time(i+1)+raised_cos_time(i-1))/2;
    end
end
if ~isempty(nanIndices)
    
    for i=nanIndices
        if i==1
            raised_cos_time(i)=0;
        else
            raised_cos_time(i)=(raised_cos_time(i+1)+raised_cos_time(i-1))/2;
        end
    end
end

raised_cos_Freq = fftshift(real(fft(raised_cos_time))); %converting raised cos to frequency domain

raised_cos_Freq=raised_cos_Freq/max(real(raised_cos_Freq));%normalization 

plot(time/10^5,raised_cos_time) %plotting raised cosine filter in time domain 
title('Raised Cosine in Time Domain')
figure;

plot(Freq,raised_cos_Freq) %plotting raised cosine filter in frequency domain 
title('Raised Cosine in Freq Domain')
figure;

RC_filtered_time_pulse1 = filter_pulse(pulse1_freq, '1 RC', 'r', Freq, B, time, 2,Fs, raised_cos_Freq);%calling filter_pulse function to filter first pulse using raised cosine filter
RC_filtered_time_pulse2 = filter_pulse(pulse2_freq, '2 RC', 'b', Freq, B, time, 2,Fs, raised_cos_Freq);%calling filter_pulse function to filter second pulse using raised cosine filter


plot(time/10^5,RC_filtered_time_pulse1,'r')% plotting filtered first pulse in time domain
hold on;
plot(time/10^5,RC_filtered_time_pulse2,'b')% plotting filtered second pulse in time domain
title('Pulses 1&2 RC filtered in Time Domain')
figure;

RC_sum_filtered_time_pulses = RC_filtered_time_pulse1 + RC_filtered_time_pulse2;
plot(time/10^5, RC_sum_filtered_time_pulses, 'g')
title('Sum of Pulses 1&2 RC filtered in Time Domain')
