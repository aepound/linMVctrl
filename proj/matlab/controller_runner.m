function out=controller_runner(in,P)

K = place(P.A, P.B, [-10 -20 -15+5i -15-5i]);

out = - K * (in + 6.16 * [P.thetad; 0; P.phid; 0]);