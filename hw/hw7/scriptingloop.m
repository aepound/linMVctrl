%% This script will run the simulations to find  good Q and R matrices 

% Clear everything out
clearvars -except traj N
clear functions
% Close down all figures
close all
bdclose('all')

debugging = 0;
nofigs = 0;

%% 

if debugging
% For each trajectory, let's get it set up...
traj = 3;

qr = ones(11,1)*.01;
%q = ones(7,1).*[10 .1 5 10 0.1 .2 1]'; 
%r = ones(4,1).*[.5 .2 7 1]';
%qr = [q;r];

% Run to get all the parameters
[P, P2, A, B, b] = param(qr,1,traj);
disp(P.K)
model = 'QuadControl_TrajectoryControl_I';
load_system(model);
cs = getActiveConfigSet(model);
try
    simout = sim(model,cs);
catch ME
    keyboard
end
% Get the error out:
err = plotStates;
% Close the simulink model:
bdclose(model)
% We need to clear the persistent variable inside of the Trajectory control
% function:
clear TrajControlI_diffFlatness

else % ~debugging ...

%% Let's try some different size things..
% We need to run this cell a few times until we get a q and r that seem like
% they have the desired distribution of sizes...
if ~exist('traj','var')
    traj = 2;
end

q = [rand(4,1)*2; rand(3,1)*15];
q = q(randperm(7));
r = [rand(2,1)*2; rand(2,1)*10];
r = r(randperm(4));
disp(q')
disp(r')


%% The actual iteration:
% Then we can run this cell with the iteration which will cycle through,
% flipping the q and r elements around.  At the end, we can see what
% combination of parameters are giving the best error..

% I guess we could try to code up a gradient descent-type algorithm or a
% simulated annealing iteration to find a good candidate... but this is just
% as easy for now...

% Save off the pertinent variables:
if ~exist('N','var')
    N = 5;
end
qperms = ones(N,length(q));
rperms = ones(N,length(r));
errs   = inf(N,1);
besterr = inf;
% Let's make the figures invisible as the simulations are running...
if nofigs
for fig = 1:5
    figure(fig);
    set(fig,'visible','off');
end
end
for iter = 1:N
    disp(['Trajectory ' num2str(traj) ', iter: ' num2str(iter)])
    if ~mod(iter,min(round(N/4),5))
        % Switch up the q and r everynow and then...
        amps = poissrnd([3, 18, 2, 9])+1;
        props= round(rand(1,2).*[6, 2])+1;
        q = [rand(props(1),1)*amps(1); rand(7-props(1),1)*amps(2)];
        q = q(randperm(7));
        r = [rand(props(2),1)*amps(3); rand(4-props(2),1)*amps(4)];
        r = r(randperm(4));
    end
   
    
    qp = randperm(7);qperms(iter,:) = q(qp);
    q = q(qp);
    rp = randperm(4);rperms(iter,:) = r(rp);
    r = r(rp);
    qr = [q; r];

    % Run to get all the parameters
    [P, P2, A, B, b] = param(qr,1,traj);
    disp(P.K)
    model = 'QuadControl_TrajectoryControl_I';
    load_system(model);
    cs = getActiveConfigSet(model);
    try
        simout = sim(model,cs);
        % Get the error out:
        err2 = plotStates;
        % Close the simulink model:
        bdclose(model)
    
    catch ME
        % Close the simulink model:
        bdclose(model)
        close(1)
        % Set the error infinite...
        err2 = inf;
        if debugging
            keyboard
        end
    end
   
    errs(iter) = err2;
    
    if err2 < besterr 
        besterr = err2;
        bestiter= iter;
    end
    
    % We need to clear the persistent variable inside of the Trajectory control
    % function:
    clear TrajControlI_diffFlatness P
end
close all
%% Error analysis:

[srtd, srti] = sort(errs);

%disp([srtd(1:10) (qperms(srti(1:10),:))])
%disp([srtd(1:10) (rperms(srti(1:10),:))])

%% Once the best is found, Run it again

qr = [qperms(srti(1),:).'; rperms(srti(1),:).'];


[P, P2, A, B, b] = param(qr,1,traj);
disp(P.K)
model = 'QuadControl_TrajectoryControl_I';
load_system(model);
cs = getActiveConfigSet(model);
try
    simout = sim(model,cs);
    % Get the error out:
    [maxPosErr, posRmsErr] = plotStates(1);
    % Close the simulink model:
    bdclose(model)
    
catch ME
    % Close the simulink model:
    bdclose(model)
    % Set the error infinite...
    maxPosErr = inf;
    posRmsErr = inf;
    if debugging
        keyboard
    end
end

% Now I need to output the errors:
tableFileName = [num2str(traj) 'errTable.tex'];

if exist(tableFileName,'file')
    delete(tableFileName)
end
fid = fopen(tableFileName,'wt');
errors_str = sprintf('%0.4g \t& %0.4g \\\\',[maxPosErr, posRmsErr]);
fprintf(fid,'%s',errors_str);
fclose(fid);

% Also need to output the Q and R matrices
qFileName = [num2str(traj) 'Q.tex'];
if exist(qFileName,'file')
    delete(qFileName)
end
fid = fopen(qFileName,'wt');
q_str = sprintf(['%0.4g \t& %0.4g \t& %0.4g \t& %0.4g \t& %0.4g \t& %0.4g ' ...
                    '\t& %0.4g \\\\ \n'],diag(qr(1:7)));
fprintf(fid,'%s',q_str);
fclose(fid);

rFileName = [num2str(traj) 'R.tex'];
if exist(rFileName,'file')
    delete(rFileName)
end
fid = fopen(rFileName,'wt');
r_str = sprintf(['%0.4g \t& %0.4g \t& %0.4g \t& %0.4g \\\\ \n'],diag(qr(8:11)));
fprintf(fid,'%s',r_str);
fclose(fid);

end % if debugging
