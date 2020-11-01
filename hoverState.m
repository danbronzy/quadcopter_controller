classdef hoverState < abstractState
    properties
        description = "Hovering";
        transitions = [["land", "idleState"];...
                       ["track(questionNumber)", "trackingState"];
                       ["execute", "hoverState"]...
                       ]';
    end
    methods
        %Constructor sets the currLoc if one is passed in, calls parent
        %class
        %@param loc: (optional) location to set to currLoc, defaults to
        %[0,0,0,0] defined in abstractState
        function obj = hoverState(loc)
            args = {};
            if nargin
                args{1} = loc;
            end
            obj = obj@abstractState(args{:});
        end
        
        %Executing the hover state hovers in place for 5 seconds
        %@params obj: class instance
        function nextState = execute(obj)
            %Executing hover
            fprintf("\tExecuting 5 second hover\n")
            
            %form trajectory
            state_waypoints = struct();
            state_waypoints.waypoints = [obj.currLoc, obj.currLoc];
            state_waypoints.waypoint_times = [0,5];
            state_waypoints.currLoc = obj.currLoc;
            state_waypoints.showGraphs = false;%don't need to show graphs for this part
            
            finalLoc = main(-1, state_waypoints);
            
            %The only thing that changes is currLoc (marginally) so lets
            %just adjust that parameter and pass back this object instead
            %of making a new object from scratch
            obj.currLoc = finalLoc;
            nextState = obj;
        end
        
        %Lands the copter over a period of 5 seconds at its current
        %location and orientation (except z=0)
        %@param obl: this class instance
        function nextState = land(obj)
            fprintf("\tLanding (transitioning to idle state)\n")
            
            targetLoc = obj.currLoc .* [1;1;0;1];
            
            %form trajectory
            state_waypoints = struct();
            state_waypoints.waypoints = [obj.currLoc, targetLoc];
            state_waypoints.waypoint_times = [0,5];
            state_waypoints.currLoc = obj.currLoc;
            state_waypoints.showGraphs = false;%don't need to show graphs for this part
            
            finalLoc = main(-1, state_waypoints);
            
            nextState = idleState(finalLoc);
        end
        
        % Follows waypoints as dictated in lookup_waypoints as they are
        % verbatim i.e. doesn't matter if the current position is nowhere
        % near the first waypoint, its gonna try and fly the original set
        % from its current location
        %
        % @param obj: this class instance
        % @param questionNum: questionNumber of waypoints to follow in
        %   lookup_waypoints
        function nextState = track(obj, questionNumber)
            fprintf("\tTransitioning to trackingState for question number %i\n", questionNumber)
            
            %transition, actual trajectory following happens in
            %trackingState.execute()
            nextState = trackingState(questionNumber, obj.currLoc);
            
        end
          
    end
end