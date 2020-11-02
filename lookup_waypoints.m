function [waypoints, waypoint_times] = lookup_waypoints(question)
%
% Input parameters
%
%   question: which question of the project we are on 
%      Possible arguments for question: 2, 3, 5, 6.2, 6.3, 6.5, 7, 9, 10
%
% Output parameters
%
%   waypoints: of the form [x; y; z; yaw]
% 
%   waypoint_times: [1 x n] vector of times where n is the number of waypoings, 
%   represents the seconds you should be at each respective waypoint
%
%************ LOOKUP WAYPOINTS ************************

% Write code here
if question == -1
    %Should never get here, this is a dummy value passed into main main
    %when the state_waypoints paramater should be populated and used
    %instead
    error("Populate state_waypoint structure to pass into main")
elseif question == 2
    waypoints = [0 0.1 0.2 0.3; 0 0 0 0; 0.5 0.5 0.5 0.5; 0 0 0 0];
    waypoint_times = [0 2 4 6];
elseif question == 3
    waypoints = [0 0 0 0; 0 0 0 0; 0 1.0 1.0 0; 0 pi/2 pi/2 0];
    waypoint_times = [0,2, 4, 6];
elseif question == 5.1
    waypoints = [0 0; 0 0; .1 .1; 0 0];
    waypoint_times = [0,5];
elseif question == 5.2
    waypoints = [0 0; 0 0; .1 .1; deg2rad(15) deg2rad(15)];
    waypoint_times = [0,5];
elseif question == 8
    waypoints = [[0, 0, 1, 0], [2, 1, 1, 0], [0, 2, 1, 0], [-2, 1, 1, 0]];
    waypoint_times = [0,2,4,6];
end

end
