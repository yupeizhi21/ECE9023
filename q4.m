a1 = -1.9;
a2 = 0.95; 
var = 1;
r2 = -(var*a2)/(1+(((a1.^2)-a1*(a2.^2))/(1+a2))-(a2.^2))
r1 = -(a1/(1+a2))*r2
r0 = var - a1*r1-a2*r2
R = [r0 r1;r1 r0]
eig(R)
lambda = eig(R)
[V,Q]=eig(R)
egionspeard = max(lambda)/min(lambda)


%coloring filter coefficient
a=0.1;
data_length=5000;
mu_lms=[0.003 0.01 0.1];
Ne = 10;
M = 5;

e_ensemble=zeros(length(mu_lms),data_length);

for k=1:3
    for j=1:Ne
    
        %generate the input sequence.
        x1=randn(1,data_length);

        %generate v(n)
        v=sqrt(0.0001)*randn(1,data_length);

        %input signal
        u=filter(1,[1 a],x1);
        u=u/std(u);

        %desired input,d.
        d=u;
        %initialization for the LMS algorithm.
        lms_weights=zeros(3,length(u)+1);
        

        % implementation of the sample-by-sample LMS algorithm.
        for ii=3:length(u)
            % bring new input sample
            uvec=u(ii:-1:ii-3+1)'; % uVector = [u(n) u(n-1) ... u(n-M+1)]';

            %calculate the error
            e(ii)=d(ii)-lms_weights(:,ii)'*uvec;

            %update weights
            lms_weights(:,ii+1)=lms_weights(:,ii)+mu_lms(k)*uvec*e(ii);
        end
    
        % generate the ensemble-averaged error.
        e_ensemble(k,:)=e_ensemble(k,:)+e.^2;
    end
    figure
    plot(lms_weights');
    title(['The convergence parameter \mu = ' num2str(mu_lms(k))]);
end;

e_ensemble=e_ensemble/Ne;
figure
plot(1:length(e),10*log10(e_ensemble));
xlabel('Time (samples)');ylabel('MSE (dB)');
H2 = line([1 length(e)],[-40 -40]);
set(H2,'Color',[0 1 0]);

legend(['\mu = ' num2str(mu_lms(1))], '\mu = 0.01', '\mu = 0.1','MSE - Optimal');
10*log10(mean(e_ensemble(:,4000:5000)'))