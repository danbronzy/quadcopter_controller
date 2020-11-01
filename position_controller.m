function [F, acc] = position_controller(current_state, desired_state, params, question)

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
%   desired_state.pos = [x; y; z], 
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
%   F: u1 or thrust
%
%   acc: will be stored as desired_state.acc = [xdotdot; ydotdot; zdotdot]
%
%************  POSITION CONTROLLER ************************

% Example PD gains
Kp1 = 17;
Kd1 = 6.6;

Kp2 = 17;
Kd2 = 6.6;

Kp3 = 20;
Kd3 = 9;

K_p = [Kp1; Kp2; Kp3];
K_d = [Kd1; Kd2; Kd3];

% Calculate errors
e_xyz = current_state.pos - desired_state.pos;
ed_xyz = current_state.vel - desired_state.vel;
edd_xyz = -K_p.*e_xyz - K_d.*ed_xyz;

b = [0,0,1];

% Calculate new desired accelerations with pd controller 
acc = edd_xyz + desired_state.acc;

% Calculate total thrust by taking the last term of this accel, with some
% changes
F = params.mass * b * (params.gravity + edd_xyz + acc);

end
