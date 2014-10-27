function out = trial(QR,tag)

if nargin < 2
    tag = 1;
end
%[P P2 A B b] = param;
param
%Q = QR(1:7,1:7);
%R = QR(1:4,8:11);
%P.Q = Q'*Q;%diag(QR(1:7));
%P.R = R'*R;%diag(QR(8:11));
switch tag
  case 1
    Q = diag(QR(1:7));
    R = diag(QR(8:11));
    P.K = lqr(A,B,Q,R);
  case 2
    P.K = QR;
end
disp(P.K)
model = 'QuadControl_TrajectoryControl_I';
load_system(model);
%hws = get_param(bdroot,'modelWorkspace');
%hws.assignin('P',P);
cs = getActiveConfigSet(model);
try
    simout = sim(model,cs);
catch ME
    keyboard
end
out = plotStates;


