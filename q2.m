% Read the audio files“m01ae.wav”, “w01ae.wav”, “w01ih.wav”, and “w01uw.wav”
[y1,fs1]=audioread('m01ae.wav');
[y2,fs2]=audioread('w01ae.wav');
[y3,fs3]=audioread('w01ih.wav');
[y4,fs4]=audioread('w01uw.wav');
% Fourier Transform of discrete data points
x1 = fft(y1);
x2 = fft(y2);
x3 = fft(y3);
x4 = fft(y4);
arcoeffs1 = aryule(y1,4)
arcoeffs2 = aryule(y2,4)
arcoeffs3 = aryule(y3,4)
arcoeffs4 = aryule(y4,4)

nrealiz = 25;

noisestdz = rand(1,nrealiz)+0.5;

randnoise = randn(1024,nrealiz);
noisevar = zeros(1,nrealiz);

for k = 1:nrealiz
    y1 = filter(1,A,noisestdz(k) * randnoise(:,k));
    y2 = filter(1,A,noisestdz(k) * randnoise(:,k));
    y3 = filter(1,A,noisestdz(k) * randnoise(:,k));
    y4 = filter(1,A,noisestdz(k) * randnoise(:,k));
    [arcoeffs1,noisevar(k)] = aryule(y1,4);
    [arcoeffs2,noisevar(k)] = aryule(y2,4);
    [arcoeffs3,noisevar(k)] = aryule(y3,4);
    [arcoeffs4,noisevar(k)] = aryule(y4,4);
end
figure(1)
hold on
plot(noisestdz.^2,noisevar,'*')
title('Noise Variance')
xlabel('Input')
ylabel('Estimated')

Y1 = filter(1,A,noisestdz.*randnoise);
Y2 = filter(1,A,noisestdz.*randnoise);
Y3 = filter(1,A,noisestdz.*randnoise);
Y4 = filter(1,A,noisestdz.*randnoise);
[coeffs1,variances] = aryule(Y1,4);
[coeffs2,variances] = aryule(Y2,4);
[coeffs3,variances] = aryule(Y3,4);
[coeffs4,variances] = aryule(Y4,4);

plot(noisestdz.^2,variances,'o')
hold off
legend('Single channel loop','Multichannel','Location','best')

rng default

% Read the audio files“m01ae.wav”, “w01ae.wav”, “w01ih.wav”, and “w01uw.wav”
[y1,fs1]=audioread('m01ae.wav');
[y2,fs2]=audioread('w01ae.wav');
[y3,fs3]=audioread('w01ih.wav');
[y4,fs4]=audioread('w01uw.wav');
% Fourier Transform of discrete data point

[ar1,nvar1,rc1] = aryule(y1,25);
[ar2,nvar2,rc2] = aryule(y2,25);
[ar3,nvar3,rc3] = aryule(y3,25);
[ar4,nvar4,rc4] = aryule(y4,25);


stem(rc1)
conf95 = sqrt(2)*erfinv(0.95)/sqrt(1024);
[X,Y] = ndgrid(xlim,conf95*[-1 1]);
figure(2)
hold on
plot(X,Y,'--r')
title('Reflection Coefficients')

stem(rc2)
conf95 = sqrt(2)*erfinv(0.95)/sqrt(1024);
[X,Y] = ndgrid(xlim,conf95*[-1 1]);
plot(X,Y,'--r')
title('Reflection Coefficients')

stem(rc3)
conf95 = sqrt(2)*erfinv(0.95)/sqrt(1024);
[X,Y] = ndgrid(xlim,conf95*[-1 1]);
plot(X,Y,'--r')
title('Reflection Coefficients')

stem(rc4)
conf95 = sqrt(2)*erfinv(0.95)/sqrt(1024);
[X,Y] = ndgrid(xlim,conf95*[-1 1]);
plot(X,Y,'--r')
hold off
title('Reflection Coefficients')