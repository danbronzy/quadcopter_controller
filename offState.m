classdef offState < abstractState
    properties
        description = "Off";
        transitions = [];%Thing is off so we are gonna stop execution
    end
    methods
        %Constructor sets the currLoc if one is passed in, calls parent
        %class
        %@param loc: (optional) location to set to currLoc, defaults to
        %[0,0,0,0] defined in abstractState
        function obj = offState(loc)
            args = {};
            if nargin
                args{1} = loc;
            end
            obj = obj@abstractState(args{:});
        end
        
        %Executing the off state does nothing
        %@params obj: class instance
        function nextState = execute(obj)
            %Executing off does nothing. Ideally, the program would
            %terminate here, but MATLAB is a big pile of crap so I can't
            %terminate from outside the main function...
            fprintf("\tTurning off\n")
            nextState = obj;
        end
        
    end
end