function [state_dot] = dynamics(params, state, F, M, rpm_motor_dot)
% Input parameters
% 
%   state: current state, will be using ode45 to update
%
%   F, M: actual force and moment from motor model
%
%   rpm_motor_dot: actual change in RPM from motor model
% 
%   params: Quadcopter parameters
%
%   question: Question number
%
% Output parameters
%
%   state_dot: change in state
%
%************  DYNAMICS ************************

mass_coeff = [params.mass * eye(3), zeros(3,3);
              zeros(3,3), params.inertia];
  
rot = state(7:9);
          
omegaCo = [cos(rot(2)), 0, -cos(rot(1)) * sin(rot(2));
           0, 1, sin(rot(1));
           sin(rot(1)), 0, cos(rot(1)) * cos(rot(2))];
       
omega = omegaCo * state(10:12);
          
vel_term = [zeros(3,1);
            cross(omega, params.inertia * omega)];

phi = rot(1);
theta = rot(2);
psi = rot(3);
 
forces = [F * (cos(phi) * cos(psi) * sin(theta) + sin(phi) * sin(psi));
          F * (cos(phi) * sin(theta) * sin(psi) - cos(psi) * sin(phi));
          F*cos(theta)*cos(phi) - params.mass*params.gravity;
          M];

a_alpha = mass_coeff\(forces - vel_term);

state_dot = zeros(16,1);
state_dot(1:3) = state(4:6);%linear velocities

state_dot(4:6) = a_alpha(1:3);%linear accel
state_dot(7:9) = state(10:12);%angular velocities
state_dot(10:12) = a_alpha(4:6);%angular accel
state_dot(13:16) = rpm_motor_dot;

end