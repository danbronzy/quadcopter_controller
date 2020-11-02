function [M] = attitude_controller(state,desired_state,params,question)

% Input parameters
% 
%   current_state: The current state of the robot with the following fields:
%   current_state.pos = [x; y; z], 
%   current_state.vel = [x_dot; y_dot; z_dot],
%   current_state.rot = [phi; theta; psi], 
%   current_state.omega = [phidot; thetadot; psidot]
%   current_state.rpm = [w1; w2; w3; w4];
%
%   desired_state: The desired states are:
%   desired_state.pos = [x; y; z], steam
%   desired_state.vel = [x_dot; y_dot; z_dot],
%   desired_state.rot = [phi; theta; psi], 
%   desired_state.omega = [phidot; thetadot; psidot]
%   desired_state.acc = [xdotdot; ydotdot; zdotdot];
%
%   params: Quadcopter parameters
%
%   question: Question number
% 
% Output parameters
%
%   M: u2 or moment [M1; M2; M3]
%
%************  ATTITUDE CONTROLLER ************************

% normal gains for question 2 and 3
% Kpphi = 190;
% Kdphi = 30;
% 
% Kptheta = 198;
% Kdtheta = 30;
% 
% Kppsi = 80;
% Kdpsi = 17.88;

% modified bad gains for 2 and 3
% Kpphi = 85;
% Kdphi = 10;
% 
% Kptheta = 85;
% Kdtheta = 10;
% 
% Kppsi = 30;
% Kdpsi = 4;

% gain set 1 for question 5
Kpphi = 190;
Kdphi = 30;

Kptheta = 190;
Kdtheta = 30;

Kppsi = 70;
Kdpsi = 18;

% gain set 2 for question 5
% Kpphi = 190;
% Kdphi = 30;
% 
% Kptheta = 190;
% Kdtheta = 30;
% 
% Kppsi = 20;
% Kdpsi = 18;

K_p = [Kpphi; Kptheta; Kppsi];
K_d = [Kdphi; Kdtheta; Kdpsi];

e_rot = state.rot - desired_state.rot;
e_omega = state.omega - desired_state.omega;


M = params.inertia * (-K_p .* e_rot - K_d .* e_omega);
end

