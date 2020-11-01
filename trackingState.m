classdef trackingState < abstractState
    properties
        description = "Tracking";
        transitions = [["execute", "hoverState"]...
                        ]';
        questionNum;
    end
    methods
        %Constructor sets the currLoc if one is passed in, calls parent
        %class
        %@param loc: (optional) location to set to currLoc, defaults to
        %[0,0,0,0] defined in abstractState
        function obj = trackingState(questionNum, loc)
            args = {};
            if nargin == 1
                qn = questionNum;
            elseif nargin == 2
                qn = questionNum;
                args{1} = loc;
            end

            obj = obj@abstractState(args{:});
            
            obj.questionNum = qn;
            
        end
        
        %Executing the trackingState tracks the prescribed set of waypoints
        %@params obj: class instance
        function nextState = execute(obj)
            %Executing idle does nothing
            fprintf("\tExecuting waypoint tracking for question number %i\n", obj.questionNum)
            
            %lookup associated waypoints
            [wps, wpts] = lookup_waypoints(obj.questionNum);
            
            %generate trajectory
            state_waypoints = struct();
            state_waypoints.waypoints = wps;
            state_waypoints.waypoint_times = wpts;
            state_waypoints.currLoc = obj.currLoc;
            state_waypoints.showGraphs = true;%These are the fun graphs!
            
            finalLoc = main(-1, state_waypoints);
            
            %We are transitioning back to a hover state
            nextState = hoverState(finalLoc);
        end
          
    end
end