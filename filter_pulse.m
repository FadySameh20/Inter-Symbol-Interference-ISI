function filtered_time_pulse = filter_pulse(pulse_freq, pulse_number, color, Freq, B, time, type, Fs,raised_cos_Freq)
    filteredNewPulseFreq = pulse_freq;
    if type == 1  % filter pulse using bandlimitied filter, B = 100 kHz
        filteredNewPulseFreq(Freq > B) = 0;
        filteredNewPulseFreq(Freq < -B) = 0;
    else  %filter pulse using raised cosine filter      
        filteredNewPulseFreq = filteredNewPulseFreq.*raised_cos_Freq;  %conv in time = multiplication in frequency
    end
    plot(Freq,abs(filteredNewPulseFreq)/Fs,color)  %plot filtered pulse in Freq domain
    title(['Pulse ', pulse_number, ' filtered in Freq Domain'])
    figure;

    filtered_time_pulse = ifft(ifftshift(filteredNewPulseFreq));  %inverse fourier transform
    plot(time/10^5,abs(filtered_time_pulse),color)  %plot filtered pulse in Time domain
    title(['Pulse ', pulse_number, ' filtered in Time Domain'])
    figure;
end