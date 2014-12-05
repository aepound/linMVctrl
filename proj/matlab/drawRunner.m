function drawRunner(u,P)

% Process inputs to function
theta    = u(1);
thetadot = u(2);
phi      = u(3);
phidot   = u(4);
t        = u(5);

% 
persistent back_handle
persistent norm_handle
persistent fig_handle
persistent desired_dir

if t == 0
    fig_handle = figure;
    desired_dir = P.desired([1 3]);
    
    % First Let's plot where the rocket is pointing.
    thrust = [0 0; 
    
    
    
else % Then just update the picture...
    
    
end







end