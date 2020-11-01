%% Interactive finite state machine
% With a few superficial changes to the main function (still works
% normally), this function is capable of managing an interactive instance
% of the quadcopter, where input commands are used to transition the copter
% between states in the finite state machine. The transitions are defined
% within the state classes. Assumes that all transitions are occuring at
% stable and static (i.e. no velocities, accelerations, roll, pitch).
%
% On every iteration of the loop:
%   1. Prints the current state
%   2. Prints the current orientation (x,y,z,psi)
%   3. Prints the available transitions from this state
%   4. Executes the states action
%   5. If the execution didn't change the state, then it waits for 
%   user input on which transition to conduct
%   6. Conducts the requested state transition
%
% User inputs work as follows:
% If the transition for a given state are the following:
%   currState.turn_off -> offState
%   currState.takeoff(hoverHeight) -> hoverState
%
% Then a collection of valid inputs typed into the command window vervatim include:
%   currState.turn_off
%   currState.turn_off()
%   currState.takeoff(3)
%   currState.takeoff(0.5)
% 
% With the first two turning the quadcopter off (thus ending execution) and
% the latter initiating a movement that brings the quadcopter to z=3 and
% z=0.5 above its current idle location.
%
% Execution of the other transitions between other states works in a
% similar manner. Documentation of the transition arguments is located in
% the equivalently named methods within the class definition for that class
%
% Example execution in the command window is as follows:
% =============Command==========|=================Result===================
%1. interactive_state_manager() |   This starts the state manager
%2. currState.takeoff(2)        |   Brings copter to hover at height 2
%3. currState.track(3)          |   Tracks the waypoints from question 3
%4. currState.track(2)          |   Tracks the waypoints from question 2
%5. currState.land()            |   Lands the copter from hover
%6. currState.turn_off()        |   Completes execution

function interactive_state_manager()
clc
close all
initialLoc = [0;0;0;0]; %x, y, z, psi

% initialize the current state to be idle at the orientation initialLoc
currState = idleState(initialLoc);

%Always looping, waiting for input command or executing a state transition
while (true)
    %Print a header explaining the current state
    fprintf("\n################################\n")
    fprintf("######Current State: %s######\n", currState.description);
    fprintf("################################\n")
    
    %print current orientation
    fprintf("Current Orientation:\n\t x: %d | y: %d | z: %d | psi: %d\n\n",...
        currState.currLoc(1), currState.currLoc(2), currState.currLoc(3), currState.currLoc(4));
    
    %Print transitions available from the current state
    fprintf("==========Available Transitions==========\n========Input Command -> New State=======\n");
    for tra = currState.transitions
        fprintf('   currState.%s -> %s\n',tra(1), tra(2));
    end
    
    %Execute the current state
    fprintf("\n****Executing the current state****\n");
    postExecuteState = currState.execute();
    
    if ~strcmp(class(postExecuteState), class(currState))
        %This means execution caused a state change so dont take any
        %transition commands just yet, continue loop and spell out
        %transisions explicitly
        currState = postExecuteState;
        continue
    elseif (isa(currState,'offState'))
        %if this is an offstate, then stop execution because we are now off
        %Ideally this would happen in offState.execute, but matlab sucks so
        %I can't stop computation from within the non-main function (i
        %think)
        currState = postExecuteState;
        return
    else
        %update the current state to its new location, if there is one
        currState = postExecuteState;
    end
        
    %Await user command
    prompt = "\nEnter a command from above to transition states...\n";
    
    %evaluate command and update current state, repeat loop
    currState = input(prompt);
    
end


end