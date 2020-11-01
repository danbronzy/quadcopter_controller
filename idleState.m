classdef idleState < abstractState
    properties
        description = "Idle";
        transitions = [["turn_off", "offState"];...
                       ["takeoff(hoverHeight)", "hoverState"];...
                       ["execute", "idleState"]...
                       ]';
    end
    methods
        %Constructor sets the currLoc if one is passed in, calls parent
        %class
        %@param loc: (optional) location to set to currLoc, defaults to
        %[0,0,0,0] defined in abstractState
        function obj = idleState(loc)
            args = {};
            if nargin
                args{1} = loc;
            end
            obj = obj@abstractState(args{:});
        end
        
        %Executing the idleState does nothing
        %@params obj: class instance
        function nextState = execute(obj)
            %Executing idle does nothing
            fprintf("\tIdling (does nothing)\n")
            nextState = obj;
        end
        
        %Transitions the quadcopter from into the off state
        %@param obl: this class instance
        function nextState = turn_off(obj)
            fprintf("\tTransitioning to offState\n")
            nextState = offState(obj.currLoc);
        end
          
        % Transition to stable hover above the current orientation over 5
        % seconds
        % @param obj: this class instance
        % @param hoverHeight: target height at which the copter will hover
        function nextState = takeoff(obj, hoverHeight)
            fprintf("\tTransitioning to hoverState at height %d\n",...
                    hoverHeight);
            targetLoc = obj.currLoc + [0;0;hoverHeight;0];
            
            %form trajectory waypoints
            state_waypoints = struct();
            state_waypoints.waypoints = [obj.currLoc, targetLoc];
            state_waypoints.waypoint_times = [0,5];
            state_waypoints.currLoc = obj.currLoc;
            state_waypoints.showGraphs = false;%don't need to show graphs for this part
            
            %execute a movement from currentLoc to hoverHeight above
            %currentLoc
            finalLoc = main(-1, state_waypoints);
            
            %set the hover state to the final location
            nextState = hoverState(finalLoc);
        end
    end
end