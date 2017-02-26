syms a b x;
%Finding the initial location of the vertices 
gamma = 4*(1 - x^2)^(1/2);
dgamma=diff(gamma,x);
intgamma=int((x-a)*dgamma,'x','a','b');
intgamnum=@(a,b)eval(intgamma);
NV = 20;
xs = zeros(1,NV);
tracersX = [-1,-0.5, -0.25,0,0.25,0.5,1];
tracersY = [1,1,1,1,1,1,1];
planeX = [1,0,-1,0];
planeY = [1,1.1,1,1];
planeVelocity = 200;
xvRight= zeros(1,NV-1);
xv=zeros(1,2*NV);
for i=2:NV+1    
    xs(i)=sqrt(1-(sqrt(1-xs(i-1)^2)-1/NV)^2);
end
for i=1:NV
    %Finding the vortex location based on each xstar
    xvRight(i)=xs(i)-NV/4*intgamnum(xs(i),xs(i+1));
end
xvLeft = (-fliplr(xvRight));
xv = [xvLeft xvRight];
xvInitial = [xv];
%Setting initial y location of each vertex to 1
yv = ones(1,2*NV);
gammaValues = ones(1,NV*2);
for i=1:NV
    gammaValues(i) = -4/NV;
end
for i=NV+1:2*NV
    gammaValues(i) = 4/NV;
end
gammaTracerValues = zeros(1:5);
gammaValuesInitial = gammaValues;
xx=linspace(-4,4,75);
yy=linspace(0,5,50);
[x, y]=meshgrid(xx,yy);
NT = 500;
sigma = 0.01;
dt = 0.0005;
vidObj = VideoWriter('result.avi');
open(vidObj);
for n=1:NT
        t=(NT-1)*dt;
        clf
        hold on
        fill(planeX,planeY,'y');
        %plot(xv,yv,'b');
        plot(tracersX,tracersY,'gs');
        plot(tracersX,tracersY,'g');
        plot(xv,yv,'r.');
        axis([-4,4,0,5]);
        %[uMesh, vMesh, psiMesh]=velocity(x,y,gammaValues,xv,yv, sigma);
        %quiver(x,y,uMesh,vMesh);
        % to make a movie save each frame:
        M(:,NT)=getframe;
        writeVideo(vidObj,M(:,NT));
        hold  off
        %Re calculating the location of the vertices
       [u1, v1] = velocity(xv,yv, gammaValues, xv,yv,sigma);
       [ut1, vt1] = velocity(tracersX,tracersY, gammaValues, xv,yv,sigma);
       x1 = xv + u1*dt/2;
       y1 = yv + v1*dt/2;
       xt1 = tracersX + ut1*dt/2;
       yt1 = tracersY + vt1*dt/2;
       [u2, v2] = velocity(x1,y1,gammaValues, xv,yv,sigma);
       [ut2, vt2] = velocity(xt1,yt1,gammaValues, xv,yv,sigma);
       x2 = xv + u2*dt/2;
       y2 = yv + v2*dt/2;
       xt2 = tracersX + ut2*dt/2;
       yt2 = tracersY + vt2*dt/2;
       [u3, v3] = velocity(x2,y2,gammaValues, xv,yv,sigma);
       [ut3, vt3] = velocity(xt2,yt2,gammaValues, xv,yv,sigma);
       x3 = xv + u3*dt;
       y3 = yv + v3*dt;
       xt3 = tracersX + ut3*dt;
       yt3 = tracersY + vt3*dt;
       [u4, v4] = velocity(x3,y3,gammaValues, xv,yv,sigma);
       [ut4, vt4] = velocity(xt3,yt3,gammaValues, xv,yv,sigma);
       xv = (xv)+(dt/6).*(u1+2*u2+2*u3+u4);
       yv = (yv)+(dt/6).*(v1+2*v2+2*v3+v4);
       tracersX = (tracersX)+(dt/6).*(ut1+2*ut2+2*ut3+ut4);
       tracersY = (tracersY)+(dt/6).*(vt1+2*vt2+2*vt3+vt4);
       planeY = planeY + planeVelocity*dt;
       if (n<50)
           newXV = xvInitial;
           newYV = ones(1,2*NV)*planeY(1);
           xv =[xv newXV];
           yv =[yv newYV];
           gammaValues=[gammaValues gammaValuesInitial];
       end
       for i=1:length(tracersX)-1
          r2=(tracersX(i)-tracersX(i+1)).^2+(tracersY(i)-tracersY(i+1)).^2;
          if r2>0.1
            tracersX = [tracersX(1:i) (tracersX(i)+tracersX(i+1))/2 tracersX(i+1:end)];
            tracersY = [tracersY(1:i) (tracersY(i)+tracersY(i+1))/2 tracersY(i+1:end)];
          end
       end
   %Recalculating the speeds on the mesh cause by the new locations of the
   %vortexis
    %let t denote time
end
close(vidObj);
