
% Starting place:
qr = ones(11,1)*.01;
q = ones(7,1).*[10 .1 5 10 0.1 .2 1]'; 
r = ones(4,1).*[.5 .2 7 1]';
qr = [q;r];


best = inf;
count = 0;
for iter = 1:3:10
    
    % Let Q and R be drawn randomly in the direction that seems to work the
    % best
    
    % So we need to come up iwht a random perturbation of the QR vector that
    % and then move in the direction that we want to minimize the error...
    if count > 4
        count = 0;
        qr = best_qr;
        disp('Rebooting...')
    end
    
    
    
    %
    if iter > 1
        dQR = randn(size(qr));
        qr = qr + dQR;
    end
    
    QR = 1./(qr.^2);
    disp(qr')
    try
        err = trial(QR,1);
    catch ME
        keyboard
        err = inf;
    end
    errs(iter) = err;
    if err < best(end)
        disp('New Best...')
        best_qr = qr;
        best = [best err];
        disp(best)
        count = 0;
    else
        count = count+1;
    end
    
end
    
    
