function [y2,runtime,iter] =  Hattusha(M,e,rho,eta,THRESHOLD)
y0=e;
x1 = M*e + eta*e;
y1 = x1;
%r = x1;
mu0 = 1;
mu1 = 1/rho;
%THRESHOLD = 1e-6;
residual = 1;
iter = 0;

while (residual > THRESHOLD)	
    mu2 = 2/rho*mu1-mu0;
    y2 = (2*mu1)/(rho*mu2)*M*y1 - (mu0/mu2)*y0 + (2*mu1)/(rho*mu2)*eta*e;
    residual = norm(y2-y1,1);
    mu0= mu1;
    mu1 = mu2;
    y0 = y1;
    y1 = y2;
    iter = iter+1;
end
%iter
end