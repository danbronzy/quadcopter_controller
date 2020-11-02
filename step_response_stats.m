% helpr function for question 5, finds the 90% rise time and the 10%
% settling time for a step response. The following assumptions are made on
% the inputs:
%   The input errors are already normalized to a unit step response (error
%       starts at 1 and trends towards 0)
%   ts and errs are the same shape
%   there is at least one value in the arrays

function [rise_time, settling_time, mp_overshoot] = step_response_stats(ts, errs)

%absolute error
errAbs = abs(errs);

%where is this error within 10% of the goal value
lane = (errAbs <= .1);

%Rise time is the time it takes to get to within 10% of the error
rise_time = min(ts(lane));

%settling time is the last time that it was outside of this lane
settling_time = max(ts(~lane));

mp_overshoot = 0;

%shortcut to determine signed-ness of the initial error value
initSide = errs(1)/errAbs(1); 

%error values on the other side of 0 from the initial error
otherside = (-initSide .* errs) >= 0;

%If it ever did overshoot, what value?
if any(otherside)
    mp_overshoot = -initSide * max(errAbs(otherside));
end 
    
end