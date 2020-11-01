function [F_motor,M_motor,rpm_motor_dot] = motor_model(F,M,motor_rpm,params)

% Input parameters
% 
%   F,M: required force and moment
%
%   motor_rpm: current motor RPM
%
%   params: Quadcopter parameters
%
% Output parameters
%
%   F_motor: Actual thrust generated by Quadcopter's Motors
%
%   M_motor: Actual Moment generated by the Quadcopter's Motors
%
%   rpm_dot: Derivative of the RPM
%
%************ MOTOR MODEL ************************

% Write code here
cT = params.thrust_coefficient;
cQ = params.moment_scale;
d = params.arm_length;
km = params.motor_constant;

mix = [cT, cT, cT, cT;
       0, d*cT, 0, -d*cT;
       -d*cT, 0, d*cT, 0;
       -cQ, cQ, -cQ, cQ];

rpm_des = sqrt(mix\[F;M]);



% Threshold
rpm_des = rpm_des.*(rpm_des>=params.rpm_min & rpm_des <= params.rpm_max) + ...
    (rpm_des<params.rpm_min)*params.rpm_min + (rpm_des>params.rpm_max)*params.rpm_max;

rpm_motor_dot = km * (rpm_des - motor_rpm);

real_stuffs = mix * rpm_des.^2;

F_motor = real_stuffs(1);
M_motor = real_stuffs(2:end);

end
