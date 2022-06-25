function pulse_freq = generate_pulse(limit1, step_size, limit2, time, Freq, pulse_number, color,Fs)
    pulse = [];
    
    for i = limit1 : step_size : limit2
        pulse(end+1) = 1; %append ones to construct rect
    end

    %concatenating zeros at left and right of the rect to satisfy
    %dimensions and make graph clear
    for i = time
        if(i < limit1) %concatenate zeros to the left of rect
            pulse = cat(2,0,pulse);  
        end
        if(i > limit2) %concatenate zeros to the right of rect
            pulse = cat(2,pulse,0);
        end
    end
    
    %the right limit of first pulse is the same the left limit of the second pulse
    %so, the right limit of first pulse should have value zero while the value will be preserved in the left limit of the second pulse
    pulse(time == limit2) = 0;   
    
    newPulse = pulse;
    plot(time/10^5,newPulse,color) %time/B for plotting (B = 10^5)
    title(['Pulse ', pulse_number, ' in Time Domain']) %plot pulse in time domain
    figure;

    pulse_freq = fftshift(fft(newPulse));  %fourier transform
    plot(Freq,abs(pulse_freq)/Fs,color);  %plot pulse in freq domain
    title(['Pulse ', pulse_number, ' in Freq Domain'])
    figure;
end