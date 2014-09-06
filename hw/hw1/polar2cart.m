function X=polar2cart(uu)
 r= uu(1);
 theta= uu(2);

phi=uu(3);

X=zeros(3,1);
X(1)=r*sin(theta)*cos(phi);
X(2)=r*cos(theta)*cos(phi);
X(3)=r*sin(phi);