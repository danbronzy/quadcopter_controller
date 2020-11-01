function trajectory_state = trajectory_planner(question, waypoints, max_iter, waypoint_times, time_step)

% Input parameters
% 
%   question: Which question we are on in the assignment
%
%   waypoints: Series of points in [x; y; z; yaw] format
%
%   max_iter: Number of time steps
%
%   waypoint_times: Time we should be at each waypoint
%
%   time_step: Length of one time_step
%
% Output parameters
%
%   trajectory_sate: [15 x max_iter] output trajectory as a matrix of states:
%   [x; y; z; xdot; ydot; zdot; phi; theta; psi; phidot; thetadot; psidot; xacc; yacc; zacc];
%
%************  TRAJECTORY PLANNER ************************

trajectory_state = zeros(15,max_iter);
% height of 15 for: [x; y; z; xdot; ydot; zdot; phi; theta; psi; phidot; thetadot; psidot; xacc; yacc; zacc];

%We are going to do this with a 5th order time parameterized polonomial
%trajectory
timeVec = 0:time_step:(max_iter - 1)*time_step;
[q, qd, qdd, pp] = quinticpolytraj(waypoints, waypoint_times, timeVec);

% plot trajectory in 3D
% scatter3(q(1,:), q(2,:), q(3,:))

% Set x,y,z  positions
trajectory_state(1:3,:) = q(1:3,:);

% Set x,y,z velocities
trajectory_state(4:6,:) = qd(1:3,:);

% Set x,y,z accelerations
trajectory_state(13:15,:) = qdd(1:3,:);

% Set the yaw(heading) and derivative
trajectory_state(9, :) = q(4,:);
trajectory_state(12,:) = qd(4,:);


end

% current_waypoint_number = 1;
% for iter = 1:max_iter
%     if (current_waypoint_number<length(waypoint_times))
%         if((iter*time_step)>waypoint_times(current_waypoint_number+1))
%             current_waypoint_number = current_waypoint_number + 1;
%         end
%     end
%         
%     trajectory_state(1:3,iter) = waypoints(1:3,current_waypoint_number);
%     trajectory_state(9,iter) = waypoints(4,current_waypoint_number);
%     
% end