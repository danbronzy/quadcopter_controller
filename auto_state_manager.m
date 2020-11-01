% Way more boring version of interactive_state_manager. Takes in a question
% number of waypoints. Starts an idle copter on the ground at [0;0;0;0],
% moves to hover at the height = 0.5m, hovers for 5 seconds,
% tracks the waypoints, hovers for 5 seconds at the desintation, lands and
% then turns off

function auto_state_manager(questionNumber)
    clc
    close all
   
    fprintf("Executing state tracking for question %i\n", questionNumber)
    
    %start at idle  on the ground under the first waypoint
    strt = idleState([0;0;0;0]);
    strt = strt.execute();%execute idle (does nothing)
    
    %takeoff to hover at the height of 0.5
    hov1 = strt.takeoff(0.5);
    hov1 = hov1.execute();%hovers for 5 seconds in place
    
    %Tracking a set of waypoints
    trk = hov1.track(questionNumber);
    hov2 = trk.execute();%execute the tracking and back to hover
    
    %hover at destination
    hov2 = hov2.execute();
    
    %land to idle and turnoff
    fin = hov2.land();
    fin = fin.execute();%does nothing
    done = fin.turn_off();
    done.execute();% does nothing
    
end