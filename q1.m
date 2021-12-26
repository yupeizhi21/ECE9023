noise = randn(1,10000); % Generate one realization of a white Gaussian random process, N(0,1). Duration: 10000 samples.
histogram(noise,"Normalization","pdf")
axis([-3 3 0 0.5])
xRange =linspace(-3,3,1000); %1000 points linearly spaced between -3 to 3.
theoreticalPDF = pdf('Normal',xRange,0,1); % pdf is a function in the statistics and machine learning toolbox.
hold;plot(xRange,theoreticalPDF,'R');hold;
legend('PDF Estimate','PDF Theory')
xlabel('X');ylabel('f_{X}(x)')
[noisePSD,w] = pwelch(noise,512,256,'centered');%512 sample window, 50% overlap, centered at $\omega$ = 0.
plot(w,2*pi*noisePSD); % 2*pi scaling is needed to properly scale S(w).
xlabel('\omega');ylabel(['S_{noise}(\omega)'])
hold;plot(w,ones(1,length(noisePSD)),'g');hold;
legend('PSD estimate','PSD Theory')

close all;clear;clc;
wn = rand(1,1000);
wnoise = (wn - mean(wn))/std(wn);
figure
histogram(wnoise,"Normalization","pdf")
sigma = var(wn)
axis([-3 3 0 0.5])
xRange =linspace(-3,3,1000); %1000 points linearly spaced between -3 to 3.
theoreticalPDF = pdf('Normal',xRange,0,1); % pdf is a function in the statistics and machine learning toolbox.
hold;plot(xRange,theoreticalPDF,'R');hold;
legend('PDF Estimate','PDF Theory')
xlabel('X');ylabel('f_{X}(x)')
Fs = 1;
[wnoisePSD,F] = pwelch(wnoise,512,256,'centered');
wnoisePSD_th = abs((fft(wn).^2)/length(fft(wn)))
semilogx(10*log(wnoisePSD_th))
hold on 
plot(log2(F(2:end)),10*log10(wnoisePSD_th),'g')
xlabel('log_2(Hz)');ylabel('dB')
title('White Uniform Noise')
grid on
legend('White Uniform Noise PSD estimate','White Uniform Noise PSD Theory')
hold;


close all;clear;clc;
pn = pinknoise(10000);
pnoise = (pn - mean(pn))/std(pn);
figure
histogram(pnoise,"Normalization","pdf")
sigma = var(pn)
axis([-3 3 0 1.2])
xRange =linspace(-3,3,1000); %1000 points linearly spaced between -3 to 3.
theoreticalPDF = pdf('Normal',xRange,0,1); % pdf is a function in the statistics and machine learning toolbox.
hold;
plot(xRange,theoreticalPDF,'R')
hold;
legend('PDF Estimate','PDF Theory')
xlabel('X');ylabel('f_{X}(x)')
Fs = 1;
[pnoisePSD,F] = pwelch(pnoise,512,256,256,Fs);
pnoisePSD_th = 1./F(2:end);
plot(log2(F(2:end)),10*log10(pnoisePSD(2:end)))
hold on 
plot(log2(F(2:end)),10*log10(pnoisePSD_th),'g')
xlabel('log_2(Hz)');ylabel('dB')
title('Pink Noise')
grid on
legend('Pink Noise PSD estimate','Pink Noise PSD Theory')
hold;

pnoisePSD = [];
numprocess =100;
for k = 1:numprocess
    pn = pinknoise(10000);
    pnoise = (pn - mean(pn))/std(pn);
    [pnoisePSD,F] = pwelch(pnoise,512,256,256,Fs);
    pnoisePSD = [pnoisePSD noisePSDOnce];
end
