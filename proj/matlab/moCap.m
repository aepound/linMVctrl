%Playing with the data...

motCap = importdata('Aug210106.txt');

cols = cellfun(@(x) strrep(x,'EricAutoLabel:',''),motCap.colheaders,'uni',false);
cols = cols(3:end);
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

clf(3)

figure(3)
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



%% Let's look now at a few of the time series.

inds = [backWaist fliplr(shoulders)];
clear fh

figure(4)
clf(4)
for iter = 1:size(d,1)
    if ~any(isnan(d(iter,inds,:)))
        if exist('fh','var')
            delete(fh)
        end
        ys = d(iter,inds,2);
        mny = mean(ys);
        xs = d(iter,inds,1);
        mnx = mean(xs);
        zs = d(iter,inds,3);
        mnz = mean(zs);
        fh = fill3(xs - mnx,ys - mny,zs-mnz,'r');
        %if iter == 1
        zlabel('z');zlim([-300 300])
        ylabel('y');ylim([-400 400])
        xlabel('x');xlim([-400 400])
        %end
        pause(.1)
    end
end
    


