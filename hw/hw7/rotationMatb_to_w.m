function Rb_w=rotationMatb_to_w(phi,theta,psi)


Rb_w=[...
         cos(theta)*cos(psi) sin(phi)*sin(theta)*cos(psi)-cos(phi)*sin(psi)...
         cos(phi)*sin(theta)*cos(psi)+sin(phi)*sin(psi);...
         cos(theta)*sin(psi) sin(phi)*sin(theta)*sin(psi)+cos(phi)*cos(psi)...
         cos(phi)*sin(theta)*sin(psi)-sin(phi)*cos(psi);...
         -sin(theta) sin(phi)*cos(theta) cos(phi)*cos(theta)];
