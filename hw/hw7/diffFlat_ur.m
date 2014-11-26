function out=diffFlat_ur(in,P)
g=P.g;
upr=in(9:11)-[0;0;g];
upsir=in(8);
ur=[upr;upsir];

out=ur;

