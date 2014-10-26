%==========================================================================
%This is the quadrotor drawing code given to ECE 6320 Students
%This is used attitide control and position control (6 times)
%
%09/25/2014: Last modified by Rajikant Sharma
%===============================================================================

function drawQuad(uu,P)%,nofigs)

    % process inputs to function
    pn       = uu(1);       % inertial North position     
    pe       = uu(2);       % inertial East position
    pd       = uu(3);           
    u        = uu(4);       
    v        = uu(5);       
    w        = uu(6);       
    phi      = uu(7);       % roll angle         
    theta    = uu(8);       % pitch angle     
    psi      = uu(9);       % yaw angle     
    p        = uu(10);       % roll rate
    q        = uu(11);       % pitch rate     
    r        = uu(12);       % yaw rate    
    t        = uu(13);       % time

    %rotate phi and theta according to psi
    R = [cos(psi), -sin(psi); sin(psi), cos(psi)];
    tmp = R * [phi;theta];
    phi = tmp(1);
    theta = tmp(2);
    
    % define persistent variables 
    persistent fig_quadrotor;
    persistent x;
    persistent traj_handle;
    
   
    
    % first time function is called, initialize plot and persistent vars
    if t<=0.1,
        %        if ~nofigs
        %    reset(1);
            figure(1), clf
        %else
        %    figure(1);
        %    set(1,'Visible','off');
        %end
            
        
        x=[pn;pe;pd];
        %draws quadrotor at initial position
        fig_quadrotor = drawquadrotor(pn,pe,pd,phi,theta,psi, P, [], 'normal');

        hold on
        traj_handle=plot3(pn,pe,pd,'b','linewidth',1.5,'linestyle','--','erasemode','normal');
        axis([-3,3,-3,3,0,2]); % see if it is possible to change the axis and not distort the image
        xlabel('X axis');
        ylabel('Y axis');
        zlabel('Z axis');
        grid on
          view(-44,22)  % set the view angle for figure
       
        
    % at every other time step, redraw base and rod
    else 
        x=[x [pn;pe;pd]];
        drawquadrotor(pn,pe,pd,phi,theta,psi, P, fig_quadrotor);
        set(traj_handle, 'xdata', x(1,:), 'ydata', x(2,:),'zdata',-x(3,:));
        drawnow;
    end
end

  
%=======================================================================
% drawquadrotor
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
function handle = drawquadrotor(pn,pe,pd,phi,theta,psi, P, handle, mode)
  
  % define points on spacecraft
  [V, F, patchcolors] = quadrotorVFC(P);
  
  % rotate spacecraft
  V = rotateVert(V, phi, theta, psi);
  
  % translate spacecraft
  V = translateVert(V, [pn; pe; -pd]);
  
  if isempty(handle),
  handle = patch('Vertices', V, 'Faces', F,...
                 'FaceVertexCData',patchcolors,...
                 'FaceColor','flat',...
                 'EraseMode', mode);
  else
    set(handle,'Vertices',V,'Faces',F);
    drawnow
  end
end

%=======================================================================
% drawpillarsl / draws left pillar
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================

function [V, F, patchcolors]=quadrotorVFC(P)

% Define the vertices (physical location of vertices)
  V = [...
	-P.boxlength P.boxwidth 0;... %1  center box
    -P.boxlength -P.boxwidth 0;... %2
    -P.boxlength -P.boxwidth P.boxheight;... %3
    -P.boxlength P.ystart+P.boxwidth P.zstart+P.boxheight;... %4
	P.boxlength P.ystart+P.boxwidth P.zstart;... %5
    P.boxlength P.ystart-P.boxwidth P.zstart;... %6
    P.boxlength P.ystart-P.boxwidth P.zstart+P.boxheight;... %7
    P.boxlength P.ystart+P.boxwidth P.zstart+P.boxheight;... %8
	-P.boxlength P.ystart+P.armwidth P.zstart+P.boxheight-P.armposition-P.armwidth;... %9 arm left
    -P.boxlength P.ystart-P.armwidth P.zstart+P.boxheight-P.armposition-P.armwidth;... %10
    -P.boxlength P.ystart-P.armwidth P.zstart+P.boxheight-P.armposition+P.armwidth;... %11
    -P.boxlength P.ystart+P.armwidth P.zstart+P.boxheight-P.armposition+P.armwidth;... %12
	-P.boxlength-P.armlength P.ystart+P.armwidth P.zstart+P.boxheight-P.armposition-P.armwidth;... %13
    -P.boxlength-P.armlength P.ystart-P.armwidth P.zstart+P.boxheight-P.armposition-P.armwidth;... %14
    -P.boxlength-P.armlength P.ystart-P.armwidth P.zstart+P.boxheight-P.armposition+P.armwidth;... %15
    -P.boxlength-P.armlength P.ystart+P.armwidth P.zstart+P.boxheight-P.armposition+P.armwidth;... %16
	P.boxlength P.ystart+P.armwidth P.zstart+P.boxheight-P.armposition-P.armwidth;... %17 arm right
    P.boxlength P.ystart-P.armwidth P.zstart+P.boxheight-P.armposition-P.armwidth;... %18
    P.boxlength P.ystart-P.armwidth P.zstart+P.boxheight-P.armposition+P.armwidth;... %19
    P.boxlength P.ystart+P.armwidth P.zstart+P.boxheight-P.armposition+P.armwidth;... %20
	P.boxlength+P.armlength P.ystart+P.armwidth P.zstart+P.boxheight-P.armposition-P.armwidth;... %21
    P.boxlength+P.armlength P.ystart-P.armwidth P.zstart+P.boxheight-P.armposition-P.armwidth;... %22
    P.boxlength+P.armlength P.ystart-P.armwidth P.zstart+P.boxheight-P.armposition+P.armwidth;... %23
    P.boxlength+P.armlength P.ystart+P.armwidth P.zstart+P.boxheight-P.armposition+P.armwidth;... %24
    P.armwidth P.ystart+P.boxlength P.zstart+P.boxheight-P.armposition-P.armwidth;... %25 arm front
    P.armwidth P.ystart+P.boxlength P.zstart+P.boxheight-P.armposition+P.armwidth;... %26
    -P.armwidth P.ystart+P.boxlength P.zstart+P.boxheight-P.armposition+P.armwidth;... %27
    -P.armwidth P.ystart+P.boxlength P.zstart+P.boxheight-P.armposition-P.armwidth;... %28
    P.armwidth P.ystart+P.boxlength+P.armlength P.zstart+P.boxheight-P.armposition-P.armwidth;... %29
    P.armwidth P.ystart+P.boxlength+P.armlength P.zstart+P.boxheight-P.armposition+P.armwidth;... %30
    -P.armwidth P.ystart+P.boxlength+P.armlength P.zstart+P.boxheight-P.armposition+P.armwidth;... %31
    -P.armwidth P.ystart+P.boxlength+P.armlength P.zstart+P.boxheight-P.armposition-P.armwidth;... %32
    P.armwidth P.ystart-P.boxlength P.zstart+P.boxheight-P.armposition-P.armwidth;... %33 back front
    P.armwidth P.ystart-P.boxlength P.zstart+P.boxheight-P.armposition+P.armwidth;... %34
    -P.armwidth P.ystart-P.boxlength P.zstart+P.boxheight-P.armposition+P.armwidth;... %35
    -P.armwidth P.ystart-P.boxlength P.zstart+P.boxheight-P.armposition-P.armwidth;... %36
    P.armwidth P.ystart-P.boxlength-P.armlength P.zstart+P.boxheight-P.armposition-P.armwidth;... %37
    P.armwidth P.ystart-P.boxlength-P.armlength P.zstart+P.boxheight-P.armposition+P.armwidth;... %38
    -P.armwidth P.ystart-P.boxlength-P.armlength P.zstart+P.boxheight-P.armposition+P.armwidth;... %39
    -P.armwidth P.ystart-P.boxlength-P.armlength P.zstart+P.boxheight-P.armposition-P.armwidth;... %40 
    0 P.ystart-P.perimeter P.zstart+P.boxheight;... %41 perimeter
    0 P.ystart-P.perimeter P.zstart+P.boxheight-P.periwidth;... %42
    0 P.ystart+P.perimeter P.zstart+P.boxheight;... %43 
    0 P.ystart+P.perimeter P.zstart+P.boxheight-P.periwidth;... %44
    P.perimeter P.ystart P.zstart+P.boxheight;... %45
    P.perimeter P.ystart P.zstart+P.boxheight-P.periwidth;... %46
    -P.perimeter P.ystart P.zstart+P.boxheight;... %47
    -P.perimeter P.ystart P.zstart+P.boxheight-P.periwidth;... %48
    0 0 P.boxheight+(1/12);... %49 camera
    -1/24 1/12 P.boxheight+(1/12)-(1/32);... %50
    1/24 1/12 P.boxheight+(1/12)-(1/32);... %51
    -1/24 1/12 P.boxheight+(1/12)+(1/32);... %52
    1/24 1/12 P.boxheight+(1/12)+(1/32);... %53
    
  ]*0.3;

% define faces as a list of vertices numbered above
  F = [...
        1, 2, 3, 4;... % left
        5, 6, 7, 8;... % right
        2, 6, 7, 3;... % back 
        1, 5, 8, 4;... % front
        4, 3, 7, 8;... % top
        1, 2, 6, 5;... % bottom
        16, 15, 11, 12;... %left arm
        15, 14, 10, 11;...
        13, 14, 10, 9;...
        13, 9, 12, 16;...
        19, 23, 22, 18;... %right arm
        20, 19, 23, 24;...
        17, 18, 22, 21;...
        17, 21, 24, 20;...
        31, 27, 28, 32;... %front arm
        29, 32, 28, 25;...
        29, 25, 26, 30;...
        31, 27, 26, 30;...
        35, 39, 38, 34;... %back arm
        35, 36, 40, 39;...
        33, 36, 40, 37;...
        34, 37, 38, 34;...
        41, 42, 46, 45;... %perimeter
        45, 46, 44, 43;...
        43, 44, 48, 47;...
        47, 48, 42, 41;...
        49, 50, 51, 49;... %camera
        49, 50, 52, 49;...
        49, 52, 53, 49;...
        49, 51, 53, 49;...
      ];

% define colors for each face    
  myred = [1, 0, 0];
  mygreen = [0, 1, 0];
  myblue = [0, 0, 1];
  myyellow = [1, 1, 0];
  mycyan = [0, 1, 1];

  patchcolors = [...
    mygreen;... % left
    mygreen;... % right
    mygreen;... % back
    myred;... % front
    mycyan;... % top
    mycyan;... % bottom
    myblue;... %left arm
    myblue;...
    myblue;...
    myblue;...
    myblue;... %right arm
    myblue;...
    myblue;...
    myblue;...
    myyellow;... %front arm
    myyellow;...
    myyellow;...
    myyellow;...
    myblue;... %back arm
    myblue;...
    myblue;...
    myblue;... 
    myred;... %perimeter
    myred;...
    myred;...
    myred;...
    myyellow;...%camera
    myyellow;...
    myyellow;...
    myyellow;...
    ];
end


%%%%%%%%%%%%%%%%%%%%%%%not done
function Vert=rotateVert(Vert,phi,theta,psi)
  % define rotation matrix
  R_roll = [...
          1, 0, 0;...
          0, cos(phi), -sin(phi);...
          0, sin(phi), cos(phi)];
  R_pitch = [...
          cos(theta), 0, sin(theta);...
          0, 1, 0;...
          -sin(theta), 0, cos(theta)];
  R_yaw = [...
          cos(psi), -sin(psi), 0;...
          sin(psi), cos(psi), 0;...
          0, 0, 1];
  R = R_roll'*R_pitch'*R_yaw';

  % rotate vertices
  Vert = (R*Vert')';
  
end % rotateVert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by column vector T
%not done
function Vert = translateVert(Vert, T)

  Vert = Vert + repmat(T', size(Vert,1),1);

end % translateVert
