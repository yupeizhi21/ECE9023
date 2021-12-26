%q3
clear;
w1=-5:0.05:5;
w2=-5:0.05:5;

J=zeros(length(w1),length(w2));
for i=1:length(w1)
    for j=1:length(w2)
        J(i,j) = 0.814 - (2.366*w1(i)+2.422*w2(j))+(2.417*w1(i)^2+3.696*w1(i)*w2(j)+2.417*w2(j)^2);
    end
end

figure
surf(w1,w2,J,'EdgeColor','None')
xlabel('w2');ylabel('w1');zlabel('J');title('MMSE error surface');

figure
contour(w1,w2,J);
xlabel('w2');ylabel('w1');title('Contours of the error performance surface');
line([0.256 0.256],[-1 1]);
line([-1 1],[0.305 0.305]);

[u,v]=gradient(J,0.05);
figure
contour(w1,w2,J);hold on;quiver(w1,w2,u,v);hold off;
xlabel('w2');ylabel('w1');title('Contours of the error performance surface and the gradient vectors');