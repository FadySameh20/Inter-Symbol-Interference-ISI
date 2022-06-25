% Part 2
close all;
clear all;
clc;
% number of signals
L = 100;%Number of channel paths
snr = 0:2:30; %Signal To Noise Ratio
BER = zeros(size(snr)); %Generate BER and initialize to Zeros
numError = zeros(size(snr));
% L rows & 1 col
% h is the channel effect
h = randn(L,1);%H holds path effect
h1 = zeros(L,L);%h1 is row L x column L will be used to hold path effect 
% making h1 matrix
index = 1;
%this loop to generate the h1 matrix which holds the channel path effect
for m = 1:L
    j = 1; 
    for k = index:-1:1
        h1(m,j) = h(k);
        j = j + 1;
    end
    index = index +1;
end
%Y=HX+N
invH = inv(h1);%Getting H inverse will be used in restoring X
BER_temp = [];
%This loop is used to iterate through each snr
%inside it an inner loop which is used to get a mean of BER
for i = 1 : length(snr) 
    for j = 1 : 20
        x = randi([0,1],L,1); %Generating random bits
        % multiply x and h
        xh = h1 * x;
        % add noise to x * h
        y = awgn(xh,snr(i),'measured');%measured 
        %is used to measure signal power and apply snr according to it
        % get the received x 
        xRec = invH * (y);
        % decide whether the RX sequence is 1 or 0 by comparing with threshold 0.5
        %xRecSeq = xRec > 0.5;
        %xRecSeq = xRecSeq./max(abs(xRecSeq));
        % calclate number of error and bit error rate for each SNR value
        %BPSK was mentioned in PDF
        %BPSK -1,1
        bpsk=[];
        for k=1:L
            if xRec(k)<=0
                bpsk(end+1)=-1;
            else
                bpsk(end+1)=1;
            end
        end
        numberOfChangedBits=0; %will hold the number of Changed Bits
        
        %xRecSeq = xRec > 0.5;
        %xRecSeq = xRecSeq./max(abs(xRecSeq));
        % calclate number of error and bit error rate for each SNR value
        for k = 1:L
            if bpsk(k) ~= x(k)
                numberOfChangedBits = numberOfChangedBits + 1;
            end
        end
        BER_temp = [BER_temp numberOfChangedBits]; %Concatenate numberOfChangedBits with BER_temp
    end
    BER_temp = BER_temp./(length(bpsk));
    BER(i) = mean(BER_temp);%setting new BER
end
plot(snr,BER); %Plotting with snr
xlabel('SNR');
ylabel('BER');
title('BER curve against SNR');