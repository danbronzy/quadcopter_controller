classdef abstractState
    properties (Abstract)
        description;
        transitions;
    end
    properties
        currLoc = [0;0;0;0]; % x,y,z,psi
    end
    methods (Abstract)
        nextState = execute(obj)
    end
    methods
        %Constructor
        %
        % @param loc: orientation [x,y,z,psi] to be initialized at
        function obj = abstractState(loc)
            
            %If argument is given, construct with new currLoc, else use
            %default defined in properties
            if nargin
                obj.currLoc = loc;
            end

        end
    end
end