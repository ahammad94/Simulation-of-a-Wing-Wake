# Simulation-of-a-Wing-Wake
Matlab code that solves for the  flow feld in the wake of an elliptically loaded wing

## Files
### loadedWingFlow File
>This file contains code that sets up the plane boundary and the inital vortices.

### velocity File
>This file contains code that determines velocities at any given point, provided the vortex locations and their strengths. This file uses the vortex points provided to find the speed (u,v) at certain points. Also an element of random wind direction and random wind speed is added that affects each point during calculation. A wall is also added at y=0 to simulate the ground. 

## Process
>Start by finding the locations of the vortex points on the wing. Then distribute among them gamma such that they all have equal gamma values. The next step is to continously use the Runga-Kutta 4 method to approximate new locations for each vortex as time progresses. In this continous loop, the plane object moves upwards and thus initializes new vortex planes. These vortex planes are then included in the next iteration of calculations. To be able to inspect the motion of the inital vertex plane, there exists a line of green tracers that move around due to the vortex points. They do not have any gamma values and those do not contribute to the rotation, they are only effected by the vortex points around it.
