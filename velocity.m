function [u,v,psi]=velocity(x,y,gamma,xv,yv,sigma)
%Randomizing the magnitude fo th wind
c=rand*50;
%Randomizing th direction of the wind
dir=2*(rand-0.5);
U_wind = dir*c*x;
V_wind = dir*c*y;
%Computing NV
NV=length(gamma);
%Delcaring variables
u=0;
v=0;
for i=1:NV
    %Find the distance squared between a point and vortex 
    r2=(x-xv(i)).^2+(y-yv(i)).^2;
    r = sqrt(r2);
    %Find all the points closer that are a distance sigma to vortex
    %Set those points distance to sigma^2
    r2(r2(:)<sigma^2) = sigma^2;
    %Calculate u and v
    u=u-gamma(i)/2/pi*(y-yv(i))./r2;
    v=v+gamma(i)/2/pi*(x-xv(i))./r2;
    psi=-gamma(i)/2/pi*log(r);
    % if we have a ground plane at y=0:
    r2=(x-xv(i)).^2+(y+yv(i)).^2;
    r2(r2(:)<sigma^2) = sigma^2;
    u=u+gamma(i)/2/pi*(y+yv(i))./r2;
    v=v-gamma(i)/2/pi*(x-xv(i))./r2;
end
%Wind contribution
u = u + U_wind;
v = v + V_wind;