function [rot, omega] = attitude_planner(desired_state, params)

% Input parameters
%
%   desired_state: The desired states are:
%   desired_state.pos = [x; y; z], 
%   desired_state.vel = [x_dot; y_dot; z_dot],
%   desired_state.rot = [phi; theta; psi], 
%   desired_state.omega = [phidot; thetadot; psidot]
%   desired_state.acc = [xdotdot; ydotdot; zdotdot];
%
%   params: Quadcopter parameters
%
% Output parameters
%
%   rot: will be stored as desired_state.rot = [phi; theta; psi], 
%
%   omega: will be stored as desired_state.omega = [phidot; thetadot; psidot]
%
%************  ATTITUDE PLANNER ************************
rot = zeros(3,1);

% capture from trajectory planner
psi_d = desired_state.rot(3);
rot(3) = psi_d;

% caluclate phi_d and theta_d
rot(1:2) = 1/params.gravity * [sin(psi_d), -cos(psi_d); cos(psi_d), sin(psi_d)] * desired_state.acc(1:2);

%Use new desired valuest to calculate omega
omegaCo = [cos(rot(2)), 0, -cos(rot(1)) * sin(rot(2));
           0, 1, sin(rot(1));
           sin(rot(1)), 0, cos(rot(1)) * cos(rot(2))];

omega = omegaCo * desired_state.omega;
end

