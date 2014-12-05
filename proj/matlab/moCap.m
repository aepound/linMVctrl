%Playing with the data...
close all 
clear all

%% ACCAD OSU data ( *.txt format)
% This was the first motion captuer data that I found.

motCap = importdata('../data/accad/Aug210106.txt');

cols = cellfun(@(x) strrep(x,'EricAutoLabel:',''),motCap.colheaders,'uni',false);
cols = cols(3:end);
% Funny: Apparently the name of the guy running is Eric... :)

% Extract the time
t = motCap.data(:,2);

data = motCap.data(:,3:end);
data(data == data(end)) = nan;

d = cat(3,data(:,1:3:end),data(:,2:3:end),data(:,3:3:end));
c = cat(3,cols(:,1:3:end),cols(:,2:3:end),cols(:,3:3:end));
%%

dprime = squeeze(d(end-10,:,:));
figure,
for iter= 1:length(dprime)
    plot3(dprime(iter,1),dprime(iter,2),dprime(iter,3),'*')
    hold on 
end

%% Plot the whole time series...


dl = d(:,3:20,:);
dr = d(:,21:39,:);

% The indices of the different markers placed on the runner:
% (Painstakingly found by Andrew by trial and error plotting and 
%  deciphering of the cryptic labels!)
forehead = [7 26];  
backhead = [4 23];
ankles = [3 21];
elbows = [6 25];
knees  = [12 31];
shins  = [14 33];
toes   = [17 36];
thighs = [16 35];
backWaist = backhead+1;   % Back waist
frontWaist = knees - 2;   % Front waist
heels = frontWaist + 1;   % Heel
middleFoot = knees + 1;   % Middle foot
shoulders = shins + 1;    % Shoulders
foreArm = frontWaist - 1;
fingers = foreArm - 1;
upperArm = toes+1; 
wristA = upperArm + 1;
wristB = wristA + 1;
sternum = [40];
back_stern = [41];
clavicle = [2];
neck = [1];


% Plot the motion of the back over time.
figure(3)
clf(3)
for iter= 1:size(d,2)
    if any(iter == backWaist)
        plot3(d(:,iter,1),d(:,iter,2),d(:,iter,3),'b')
%    elseif any(iter == frontWaist)
%        plot3(d(:,iter,1),d(:,iter,2),d(:,iter,3),'b.-')
    elseif any(iter == shoulders)
        plot3(d(:,iter,1),d(:,iter,2),d(:,iter,3),'r-')
%    elseif  any(iter == sternum)
%        plot3(d(:,iter,1),d(:,iter,2),d(:,iter,3),'m.-')        
    elseif  any(iter == back_stern)
        plot3(d(:,iter,1),d(:,iter,2),d(:,iter,3),'m-')
%    elseif any(iter == clavicle)
%        plot3(d(:,iter,1),d(:,iter,2),d(:,iter,3),'g.-')
    end
    hold on 
end



%% Take a look at the back as it is moving through time.
% Let's look now at a few of the time series.

%inds1 = [backWaist fliplr(shoulders)];
inds1 = [backWaist back_stern];
arminds = [back_stern back_stern; shoulders; elbows; wristA];
leginds = [backWaist; knees; ankles; toes];

clear fh

plotarmslegs = 1;
cmap = jet(size(d,1));
norms = [];

figure(5)
clf(5)
for iter = 50:size(d,1)
    if ~any(isnan(d(iter,inds1,:)))
        if exist('fh','var')
            delete(fh)
        end
        ys = d(iter,inds1,2);
        mny = mean(ys);% 0; %
        xs = d(iter,inds1,1);
        mnx = mean(xs);% 0; %
        zs = d(iter,inds1,3);
        mnz = mean(zs);
        
        x0 = xs - mnx;
        y0 = ys - mny;
        z0 = zs - mnz;
        fh = fill3(x0,y0,z0,'r');
        hold on, grid on
        G = [x0; y0; z0]';
        [u, s, v] = svd(G,0);
        
        norm_len = 300;
        unormal = v(:,end); unormal = unormal./norm(unormal);
        normal = unormal*.5*norm_len*-sign(unormal(1));
        
        norms = [norms unormal];
        
        ph = plot3([0 normal(1)]',[0 normal(2)]',[0 normal(3)]',...
                'Color',cmap(iter,:),'linewidth',2);       
        
            
        if plotarmslegs
            if exist('armhandle','var') && all(ishandle(armhandle))
                delete(armhandle)
            end
            if exist('leghandle','var') && all(ishandle(leghandle))
                delete(leghandle)
            end
                
            larm = bsxfun(@minus,squeeze(d(iter,arminds(:,1),:)),[mnx mny mnz]);
            rarm = bsxfun(@minus,squeeze(d(iter,arminds(:,2),:)),[mnx mny mnz]);
            
            lleg = bsxfun(@minus,squeeze(d(iter,leginds(:,1),:)),[mnx mny mnz]);
            rleg = bsxfun(@minus,squeeze(d(iter,leginds(:,2),:)),[mnx mny mnz]);
            
            armhandle = plot3([larm(:,1) rarm(:,1)]...
                             ,[larm(:,2) rarm(:,2)]...
                             ,[larm(:,3) rarm(:,3)]...
                             ,'Color','g'...
                             ,'linewidth',2);
                         
            leghandle = plot3([lleg(:,1) rleg(:,1)]...
                             ,[lleg(:,2) rleg(:,2)]...
                             ,[lleg(:,3) rleg(:,3)]...
                             ,'Color','g'...
                             ,'linewidth',2);
                  
        end
            
            
        
        %if iter == 1
        zlabel('z');zlim([-900 300])
        ylabel('y');ylim([-500 500])
        xlabel('x');xlim([-500 500])
        %end
        pause(.1)
    end
end
    

if ~plotarmslegs
    pause
    delete(fh)
end

%%  MoCapClub data ( *.c3d format)
% Should we see about some of the other motion capture files?
%

datadir = '../data/mocapclub/Game_Package_c3d';
fname = [datadir '/Jog_1.c3d'];
%fname = [datadir '/Run_1.c3d'];
%fname = [datadir '/Run_2.c3d'];

%datadir = '../data/mocapclub/Miscellaneous_Motions_c3d';
%fname = [datadir '/ActorB_Run.c3d'];
%fname = [datadir '/ActorB_Run_2.c3d'];
%fname = [datadir '/ActorG_Run.c3d'];

%datadir = '../data/mocapclub/Circus_Package_c3d';
%fname = [datadir '/Human_Run_DW.c3d'];


[Markers,VideoFrameRate,AnalogSignals,AnalogFrameRate, ...
    Event,ParameterGroup,CameraInfo,ResidualError]=readc3d(fname);


%%
markerlbls = ParameterGroup.Parameter(9).data;

rshoulder = strmatch('RShoulder',markerlbls);
lshoulder = strmatch('LShoulder',markerlbls);
rhip      = strmatch('RightHip',markerlbls,'exact');
lhip      = strmatch('LeftHip',markerlbls,'exact');
%if isempty(rhip)
    rhip      = strmatch('RBackWaist',markerlbls,'exact');
    lhip      = strmatch('LBackWaist',markerlbls,'exact');
%end


lelbow    = strmatch('LeftElbow',markerlbls,'exact');
relbow    = strmatch('RightElbow',markerlbls,'exact');
lwrist    = strmatch('LeftWrist',markerlbls,'exact');
rwrist    = strmatch('RightWrist',markerlbls,'exact');

if isempty(lelbow)
    lelbow    = strmatch('LOuterElbow',markerlbls,'exact');
    relbow    = strmatch('ROuterElbow',markerlbls,'exact');
    lwrist    = strmatch('LHand',markerlbls,'exact');
    rwrist    = strmatch('RHand',markerlbls,'exact');
end

lknee     = strmatch('LeftKnee',markerlbls,'exact');
rknee     = strmatch('RightKnee',markerlbls,'exact');
lankle    = strmatch('LeftAnkle',markerlbls,'exact');
rankle    = strmatch('RightAnkle',markerlbls,'exact');
if isempty(lknee)
    lknee     = strmatch('LOuterKnee',markerlbls,'exact');
    rknee     = strmatch('ROuterKnee',markerlbls,'exact');
    lankle    = strmatch('LAnkle',markerlbls,'exact');
    rankle    = strmatch('RAnkle',markerlbls,'exact');
end    
ltoes     = strmatch('LToe',markerlbls,'exact');
rtoes     = strmatch('RToe',markerlbls,'exact');

spine    = strmatch('TopSpine',markerlbls,'exact');


arminds2 = [spine spine; lshoulder rshoulder; lelbow relbow; lwrist rwrist];
leginds2 = [lhip rhip; lknee rknee; lankle rankle; ltoes rtoes];

disp('size of data:')
disp(size(Markers))
%%
clear fh

%inds = [lshoulder rshoulder rhip lhip];
inds = [spine rhip lhip];

cmap = jet(size(Markers,1));
figure(1)
clf(1)

staystill = 1;
plotarmslegs = 1;

norms = [];

mxnx = [-300 300];
mxny = [-200 200];
mxnz = [-300 300];
for iter = 1:size(Markers,1)
    if ~all(any(isnan(Markers(iter,inds,:))))
        if exist('fh','var')
            if staystill
                delete(fh)
                axis equal
            end
        end
        ys = Markers(iter,inds,2);
        mny = 0; %mean(ys);
        xs = Markers(iter,inds,1);
        mnx = 0; %mean(xs);
        zs = Markers(iter,inds,3);
        mnz = mean(zs);
        
        if staystill
            mny = mean(ys);
            mnx = mean(xs);
        end        
        
        
        
        x0 = xs - mnx;
        y0 = ys - mny;
        z0 = zs - mnz;
        fh = fill3(x0,y0,z0,'r');
        hold on, grid on
        G = [x0; y0; z0]';
        [u, s, v] = svd(G,0);
        
        norm_len = 300;
        normal = v(:,end); unormal = normal./norm(normal);
        normal = unormal*.5*norm_len*-sign(unormal(1));
        
        norms = [norms unormal];
        
        ph = plot3([0 normal(1)]',[0 normal(2)]',[0 normal(3)]',...
                'Color',cmap(iter,:),'linewidth',2);       
        
            
        if plotarmslegs
            if exist('armhandle2','var') && all(ishandle(armhandle2))
                delete(armhandle2)
            end
            if exist('leghandle2','var') && all(ishandle(leghandle2))
                delete(leghandle2)
            end
                
            larm = bsxfun(@minus,squeeze(Markers(iter,arminds2(:,1),:)),[mnx mny mnz]);
            rarm = bsxfun(@minus,squeeze(Markers(iter,arminds2(:,2),:)),[mnx mny mnz]);
            
            lleg = bsxfun(@minus,squeeze(Markers(iter,leginds2(:,1),:)),[mnx mny mnz]);
            rleg = bsxfun(@minus,squeeze(Markers(iter,leginds2(:,2),:)),[mnx mny mnz]);
            
            armhandle2 = plot3([larm(:,1) rarm(:,1)]...
                             ,[larm(:,2) rarm(:,2)]...
                             ,[larm(:,3) rarm(:,3)]...
                             ,'Color','g'...
                             ,'linewidth',2);
                         
            leghandle2 = plot3([lleg(:,1) rleg(:,1)]...
                             ,[lleg(:,2) rleg(:,2)]...
                             ,[lleg(:,3) rleg(:,3)]...
                             ,'Color','g'...
                             ,'linewidth',2);
                  
        end
        
        %if iter == 1
        zlabel('z');zlim([-1200 500])
        ylabel('y');%
        xlabel('x');%
        
        if staystill
            ylim([-600 600])
            xlim([-600 600])
        end
        
        %end
        %zlim(mxnz);
        %ylim(mxny);
        %xlim(mxnx);
%        mxnx = [min(xl(1),mxnx(1)), max(xl(2),mxnx(2))]; 
%        mxny = [min(yl(1),mxny(1)), max(yl(2),mxny(2))]; 
%        mxnz = [min(zl(1),mxnz(1)), max(zl(2),mxnz(2))]; 
        
        pause(.1)
    end
end

%%

a = sqrt(sum(norms(1:2,:).^2));
phi   = atan2(norms(3,:),a);
theta = atan(norms(2,:)./norms(1,:));

figure,
subplot(2,1,1)
plot(theta./pi*180),title('\theta')

subplot(2,1,2)
plot(abs(phi/pi*180)),title('\phi')


%% CMU data ( *.amc format)
% This has anumber of different subjects with (possibly) numerous datasets
% for each subject

% Specify a subject: 1 - 5
subiter = 3;
% Specify a run/dataset:
dataset = 3;

subjects = [ 2 9 16 35 58];
subject = sprintf('%0.2d',subjects(subiter));

datadir = [ '../data/cmu/subjects/' subject ];
dd = dir([datadir '/*.c3d']); dd(1:3) = [];
if dataset > length(dd)
    error('Wrong dataset...')
end

fname = [datadir filesep dd(dataset).name];

%[M, S] = amc_to_matrix(fname);

[Markers,VideoFrameRate,AnalogSignals,AnalogFrameRate, ...
    Event,ParameterGroup,CameraInfo,ResidualError]=readc3d(fname);

markerlbls = ParameterGroup.Parameter(9).data;




%%

% Let's look at just the waist motion, assuming that we'll be stratpping
% the "rocket" to the person at approximately the waist.

hips = [lhip rhip]; data = Markers;
hips = backWaist;   data = d;

lxypts = squeeze(data(:,hips(1),1:2));
rxypts = squeeze(data(:,hips(2),1:2));


figure,plot(lxypts(:,1),lxypts(:,2))
hold on
plot(rxypts(:,1),rxypts(:,2),'g')


