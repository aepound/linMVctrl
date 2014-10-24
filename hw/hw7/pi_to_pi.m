function angle = pi_to_pi(angle)
%==========================================================================
%This is the code wraps the angle input and keep it between pi_to_pi
%
%09/25/2014: Last modified by Rajikant Sharma
%==========================================================================
i= find(angle<-2*pi | angle>2*pi); % replace with a check
if ~isempty(i) 
%    warning('pi_to_pi() error: angle outside 2-PI bounds.')
    angle(i) = mod(angle(i), 2*pi);
end

i= find(angle>pi);
angle(i)= angle(i)-2*pi;

i= find(angle<-pi);
angle(i)= angle(i)+2*pi;
