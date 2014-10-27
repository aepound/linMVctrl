besterr = inf;
bestone = 0;


q = [rand(4,1)*2; rand(3,1)*15];
q = q(randperm(7));
r = [rand(2,1)*2; rand(2,1)*10];
r = r(randperm(4));

qperms = [];
rperms = [];

for iter = 1:5
    qp = randperm(7);qperms = [qperms; qp];
    q = q(qp);
    rp = randperm(4);rperms = [rperms; rp];
    r = r(rp);
    
    K = lqr(A,B,diag(q),diag(r));
    try 
        err = trial(K,2);
    catch ME
        keyboard
    end
    errs = [errs err];
    
    if err < besterr
        besterr = err;
        bestone = iter;
    end    
    
end
