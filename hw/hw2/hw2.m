%{
\documentclass{article}
\input{commonheader}
\usepackage{comment}
\usepackage{enumitem}


\newenvironment{matlabc}{}{}
\newenvironment{octavec}{}{}
\excludecomment{matlabc}
%\newenvironment{matlabv}{\verbatim}{\endverbatim}
%\newenvironment{octavev}{\verbatim}{\endverbatim}


% ******** For code: ******************
\usepackage{listings}
%\usepackage[usenames,dvipsnames]{color}
% ******** Define the language: *******
\lstdefinelanguage{matlabfloz}{%
	alsoletter={...},%
	morekeywords={% 						% keywords
	break,case,catch,continue,elseif,else,end,for,function,global,%
	if,otherwise,persistent,return,switch,try,while,...,
        classdef,properties,methods},%
	comment=[l]\%,% 						% comments
	morecomment=[l]...,% 					% comments
	morestring=[m]',%   						% strings 
}[keywords,comments,strings]%
\lstdefinestyle{matlab}{language=matlabfloz,							
		keywordstyle=\color[rgb]{0,0,1},					
		commentstyle=\color[rgb]{0.133,0.545,0.133},	% comments
		stringstyle=\color[rgb]{0.627,0.126,0.941},	% strings
		numbersep=3mm, numbers=left, numberstyle=\tiny% number style
}
% ******** Set the style: **************
\lstset{style=matlab}

\begin{matlabc}
%}
% Start some Matlabe startup stuffs:
clear all
close all

% Record version of MATLAB/Octave
a = ver('octave');
if length(a) == 0
    a = ver('matlab');
end
fid = fopen('vers.tex', 'w');
fprintf(fid, [a.Name ' version ' a.Version]);
fclose(fid);

% Record computer architecture.
fid = fopen('computer.tex', 'w');
fprintf(fid, ['\\verb+' computer '+']);
fclose(fid);

% Record date of run.
fid = fopen('date.tex', 'w');
fprintf(fid, datestr(now, 'dd/mm/yyyy'));
fclose(fid);

%{
\end{matlabc}
\title{ECE 6320: Homework 2}             
\author{Andrew Pound}
%\date{\input{date.tex}}

\begin{document}
\maketitle

Sorry, I didn't get to making the figures... Maybe next time. 

\section{Problem 1}\label{sec:prob1}
Consider the inverted pendulum in Figure 1 . The equation of motion
can be written as
\begin{figure}[h!]
  \centering
  {\Huge Put in a figure here...}
  \caption{Inverted Pendulum}
  \label{fig:1}
\end{figure}
\begin{equation}
\label{eq:eqnMot}
 ml^2 \thetaddot = mgl \sin \theta - b\thetadot + T 
\end{equation} 
where $T$ denotes the applied torque at the base and $g$ is the
gravitational acceleration. For this system assume the input and
output to the system are the signals $u$ and $y$ defined as $T =
sat(u)$, $y = \theta$ where ``sat'' denotes the unit-slope saturation
function that truncates $u$ at $+1$ and $-1$.
\begin{enumerate}[label=(\alph*)]
\item 
 Linearize this system around the equilibrium point for which
$\theta = 0$.  
\item[] Ok, first, let's set out some definitions.
  \begin{equation}
    \begin{split}
      \xdot &= f(x,u)\\ y &= g(x,u)
    \end{split}
  \end{equation}
is our nonlinear system.  Let our state be
\begin{equation}
  x =
  \begin{bmatrix}
    \theta \\ \thetadot
  \end{bmatrix},
\end{equation}
and our equation of motion is given by equation \ref{eq:eqnMot} above.
Taking the derivative of our state, we get
\begin{equation}
  \xdot =
  \begin{bmatrix}
    \thetadot \\ \thetaddot
  \end{bmatrix}
  =
  \begin{bmatrix}
    \thetadot \\ 
    \frac{g}{l}\sin(\theta) - \frac{b}{ml^2}\thetadot +
    \frac{1}{ml^2}T(u) 
  \end{bmatrix} = f(x,u).
\end{equation}
In addition, our output equation is
\begin{equation}
  y = \theta.
\end{equation}

Now, when we do the linearization around an equilbrium point, we will
obtain equations of the form
\begin{equation}
  \begin{split}
    \dot{\delta x} &= A \delta x + B \delta u\\
    \delta y &= C \delta x + D \delta u,
  \end{split}
\end{equation}
where
\begin{align}
  A &= \left.\partiald{f}{x}\right|_{(\xbar,\ubar)} & 
  B &= \left.\partiald{f}{u}\right|_{(\xbar,\ubar)} &
  C &= \left.\partiald{g}{x}\right|_{(\xbar,\ubar)} & 
  D &= \left.\partiald{g}{u}\right|_{(\xbar,\ubar)},  
\end{align}
and $\xbar = x^{eq}$, and $\ubar=u^{eq}$.
So for this system, we get
\begin{equation}\label{eq:mats}
  \begin{split}
      A &= \left.\partiald{f}{x}\right|_{(\xbar,\ubar)} 
        =
        \left[\left(\partiald{f_i}{x_j}\right)_{ij}\right|_{(\xbar,\ubar)} 
        =
        \begin{bmatrix}
          0 & 1 \\ \frac{g}{l}\cos(\bar{\theta}) & \frac{-b}{ml^2}
        \end{bmatrix} \\
      B &= \left.\partiald{f}{u}\right|_{(\xbar,\ubar)} 
       =
       \left[\left(\partiald{f_i}{u_j}\right)_{ij}\right|_{(\xbar,\ubar)} 
       =
       \begin{bmatrix}
         0 \\ \frac{1}{ml^2}\partiald{T(u)}{u}
       \end{bmatrix} \\
  C &= \left.\partiald{g}{x}\right|_{(\xbar,\ubar)} 
  =
  \left[\left(\partiald{g_i}{x_j}\right)_{ij}\right|_{(\xbar,\ubar)}  
  =
  \begin{bmatrix}
    1 & 0
  \end{bmatrix} \\
  D &= \left.\partiald{g}{u}\right|_{(\xbar,\ubar)}
  =
  \left[\left(\partiald{g_i}{u_j}\right)_{ij}\right|_{(\xbar,\ubar)}  
  = 0.
  \end{split}
\end{equation}
The derivative of the $T(u)$ is 
\begin{equation*}
  \partiald{T(u)}{u} = \upsilon(u) = 
  \begin{cases}
    1 & -1 < u < 1\\
    0 & \text{otherwise}.
  \end{cases}
\end{equation*}

Ok, now for $\bar{\theta} = 0$,
We get the system
\begin{equation}
  \begin{split}
    \dot{\delta x} &= 
    \begin{bmatrix}
      0 & 1 \\ \frac{g}{l} & \frac{-b}{ml^2}
    \end{bmatrix}
    \delta x + 
    \begin{bmatrix}
    0 \\ \frac{\upsilon(u)}{ml^2}
    \end{bmatrix}
    \delta u\\
    \delta y &= 
    \begin{bmatrix}
      1 & 0
    \end{bmatrix}
    \delta x.
  \end{split}
\end{equation}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\item 
 Linearize this system around the equilibrium point for which $\theta
 = \pi$ (Assume that the pendulum is free to rotate all the way to
 this configuration without hitting the table).
\item[] Plugging in $\theta = \pi$ into equation \ref{eq:mats}, we get
\begin{equation}
  \begin{split}
    \dot{\delta x} &= 
    \begin{bmatrix}
      0 & 1 \\ \frac{-g}{l} & \frac{-b}{ml^2}
    \end{bmatrix}
    \delta x + 
    \begin{bmatrix}
    0 \\ \frac{\upsilon(u)}{ml^2}
    \end{bmatrix}
    \delta u\\
    \delta y &= 
    \begin{bmatrix}
      1 & 0
    \end{bmatrix}
    \delta x.
  \end{split}
\end{equation}

\item 
Linearize the system around the equilibrium point for which $\theta =
\frac{\pi}{4}$. 
\item[] And finally, pluggin in $\theta = \pi/4$ into equation
  \ref{eq:mats}, we obtain
\begin{equation}
  \begin{split}
    \dot{\delta x} &= 
    \begin{bmatrix}
      0 & 1 \\ \frac{g\sqrt{2}}{2l} & \frac{-b}{ml^2}
    \end{bmatrix}
    \delta x + 
    \begin{bmatrix}
    0 \\ \frac{\upsilon(u)}{ml^2}
    \end{bmatrix}
    \delta u\\
    \delta y &= 
    \begin{bmatrix}
      1 & 0
    \end{bmatrix}
    \delta x.
  \end{split}
\end{equation}

\end{enumerate}

\section{Problem 2}

A UAV flying in plane and constant altitude has linear velocity $v$
and angular velocity $\omega$ can be modeled by the nonlinear system 
\begin{equation*}
  \begin{split}
    \pdot_x &= v \cos \theta,\\    
    \pdot_y &= v \sin \theta,\\
    \thetadot&=\omega
  \end{split}
\end{equation*}
where $(p_x , p_y )$ denote the position of UAV in the horizontal
plane and $\theta$ is the UAVs orientation. Regard this a system with
input $u := \left[\begin{smallmatrix}v&
    \omega\end{smallmatrix}\right]^T \in \Rbb^2$ . 
\begin{enumerate}[label=(\alph*)]
\item 
Construct a state-space model for this system with state
\begin{equation}
  x = 
  \begin{bmatrix}
    x_1\\  x_2\\ x_3
  \end{bmatrix}= 
  \begin{bmatrix}
    p_x \cos \theta + (p_y - 1) \sin \theta\\
    -p_x \sin \theta + (p_y - 1) \cos \theta\\
    \theta
  \end{bmatrix}
\end{equation}
and output $y = \left[\begin{smallmatrix} x_1 &
    x_2\end{smallmatrix}\right]^T \in \Rbb^2$. 
\item[]
Well, we will start by computing the derivative of $x$
\begin{equation}
  \begin{split}
    \xdot &=
    \begin{bmatrix}
      \pdot_x\cos(\theta) - p_x\sin(\theta)\thetadot +
      \pdot_y\sin(\theta) + p_y\cos(\theta)\thetadot +
      \cos(\theta)\thetadot  \\
     -\pdot_x\sin(\theta) - p_x\cos(\theta)\thetadot +
      \pdot_y\cos(\theta) - p_y\sin(\theta)\thetadot +
      \sin(\theta)\thetadot  \\
      \thetadot
    \end{bmatrix}\\
    &= 
    \begin{bmatrix}
      v\cos(\theta)\cos(\theta) - p_x\sin(\theta)\omega +
      v\sin(\theta)\sin(\theta) + p_y\cos(\theta)\omega +
      \cos(\theta)\omega  \\
     -v\cos(\theta)\sin(\theta) - p_x\cos(\theta)\omega +
      v\sin(\theta)\cos(\theta) - p_y\sin(\theta)\omega +
      \sin(\theta)\omega  \\
      \omega
    \end{bmatrix}\\
    &=
    \begin{bmatrix}
      v\left(\cos^2(\theta) + \sin^2(\theta)\right) +
      \left(-p_x\sin(\theta) + p_y\cos(\theta)+
      \cos(\theta)\right)\omega  \\
     - \left(p_x\cos(\theta) + p_y\sin(\theta) - 
      \sin(\theta)\right)\omega  \\
      \omega
    \end{bmatrix}\\
    &=
    \begin{bmatrix}
      v + x_2\omega\\ -x_1\omega \\ \omega
    \end{bmatrix}\\
    &= f(x,u)\\
    y &=
    \begin{bmatrix}
      x_1 \\ x_2
    \end{bmatrix}\\
    &= g(x,u).
  \end{split}
\end{equation}
We can then find the statespace as
\begin{align}\label{eq:xdot}
    \xdot  &= f(x,u) = 
    \begin{bmatrix}
      v + x_2\omega\\ -x_1\omega \\ \omega
    \end{bmatrix} 
    & x &=
    \begin{bmatrix}
      x_1 \\ x_2 \\ x_3
    \end{bmatrix} \\
    y &= g(x,u) = 
    \begin{bmatrix}
      x_1 \\ x_2
    \end{bmatrix}
    & u &= 
    \begin{bmatrix}
      v \\ \omega
    \end{bmatrix}
\end{align}
\item 
Compute a local linearization for this system around the equilibrium
point $x^{eq} = 0$ and $u^{eq} = \theta$.
\item[]
A local linearization around a equilibrium point $(x^{eq},u^{eq})$ can
be found by
\begin{align}
  A &=
  \left[\left(\partiald{f_i}{x_j}\right)_{ij}\right|_{x^{eq},u^{eq}} = 
  \left[\begin{matrix}
    0 & \omega & 0 \\
    -\omega & 0 & 0 \\
    0 & 0 & 0 
  \end{matrix}\right|_{x^{eq},u^{eq}} 
& B &= 
  \left[\left(\partiald{f_i}{u_j}\right)_{ij}\right|_{x^{eq},u^{eq}} = 
  \left[\begin{matrix}
    1 & x_2 \\
    0 & -x_1 \\
    0 & 1 
  \end{matrix}\right|_{x^{eq},u^{eq}} \\
  C &= 
  \left[\left(\partiald{g_i}{x_j}\right)_{ij}\right|_{x^{eq},u^{eq}} =
  \left[\begin{matrix}
    1 & 0 & 0\\ 0 & 1 & 0
  \end{matrix}\right|_{x^{eq},u^{eq}}
& D &= 
  \left[\left(\partiald{g_i}{x_j}\right)_{ij}\right|_{x^{eq},u^{eq}} = 
  0.
\end{align}

Thus, plugging in our values for $\omega,v$, and $x$, we get
\begin{align}
  \dot{\delta x} &=
  \begin{bmatrix}
    0 & 0 & 0 \\
    0 & 0 & 0 \\
    0 & 0 & 0 
  \end{bmatrix}\delta x + 
  \begin{bmatrix}
    1 & 0  \\
    0 & 0  \\
    0 & 1  
  \end{bmatrix}\delta u \\
  \delta y &= 
  \begin{bmatrix}
    1 & 0 & 0 \\
    0 & 1 & 0 \\
  \end{bmatrix}\delta x.
\end{align}
\item 
Show that $\omega(t) = v(t) = 1$, $p_x (t) = \sin t$, $p_y = 1 - \cos t$, and
$\theta(t) = t, \forall \: t \ge 0$ is a solution to the system.
\item[]
Plugging these values into our formula for $x$, we get
\begin{equation}
  x =
  \begin{bmatrix}
    \sin(t)\cos(t) - \cos(t)\sin(t)\\
    -\sin^2(t) - \cos^2(t)\\
    t
  \end{bmatrix}
  =
  \begin{bmatrix}
    0 \\ -1 \\ t
  \end{bmatrix}.
\end{equation}
Then, taking the derivative of this with respect to $t$, we get
\begin{equation}
  \xdot = \frac{d}{dt}  \begin{bmatrix}
    0 \\ -1 \\ t
  \end{bmatrix} =   \begin{bmatrix}
    0 \\ 0 \\ 1
  \end{bmatrix}.
\end{equation}
Ok, now let's plug in the values for the trjectory into the equation
\ref{eq:xdot} for $\xdot$ (from above)
\begin{equation}
  \xdot = \begin{bmatrix}
      v + x_2\omega\\ -x_1\omega \\ \omega
    \end{bmatrix}
    = \begin{bmatrix}
      0 + 0\cdot 1\\ -0\cdot 1 \\ 1
    \end{bmatrix}
    = \begin{bmatrix}
    0 \\ 0 \\ 1
  \end{bmatrix}.
\end{equation}
\item 
 Show that a local linearization of this system around this trajectory
$( \omega(t) = v(t) = 1\text{, } p_x (t) = \sin t\text{, } p_y =
1-\cos t\text{, and }\theta(t) = t,\: \forall \: t \ge 0)$
results in an Linear Time Invariant (LTI) system.
\item[]
Simlar to above with the linearization around the equilibrium point,
we take derivatives to find the linearization around the trajectory
specified. 
We obtain the matrices
\begin{align}
  A &=
  \left[\left(\partiald{f_i}{x_j}\right)_{ij}\right|_{x^{sol},u^{sol}} = 
  \left[\begin{matrix}
    0 & \omega & 0 \\
    -\omega & 0 & 0 \\
    0 & 0 & 0 
  \end{matrix}\right|_{x^{sol},u^{sol}} 
& B &= 
  \left[\left(\partiald{f_i}{u_j}\right)_{ij}\right|_{x^{sol},u^{sol}} = 
  \left[\begin{matrix}
    1 & x_2 \\
    0 & -x_1 \\
    0 & 1 
  \end{matrix}\right|_{x^{sol},u^{sol}} \\
  C &= 
  \left[\left(\partiald{g_i}{x_j}\right)_{ij}\right|_{x^{sol},u^{sol}} =
  \left[\begin{matrix}
    1 & 0 & 0\\ 0 & 1 & 0
  \end{matrix}\right|_{x^{sol},u^{sol}}
& D &= 
  \left[\left(\partiald{g_i}{x_j}\right)_{ij}\right|_{x^{sol},u^{sol}} = 
  0.
\end{align}
Now we can plug in the trajectory and we will get the system
\begin{align}
  \dot{\delta x} &=
  \begin{bmatrix}
    0 & 1 & 0 \\
    -1 & 0 & 0 \\
    0 & 0 & 0 
  \end{bmatrix}\delta x + 
  \begin{bmatrix}
    1 & -1 \\
    0 & 0  \\
    0 & 1  
  \end{bmatrix}\delta u \\
  \delta y &= 
  \begin{bmatrix}
    1 & 0 & 0 \\
    0 & 1 & 0 \\
  \end{bmatrix}\delta x,
\end{align} 
which is an LTI, because the equations are linear and all
the coefficient matrices are not time varying.
\end{enumerate}






\section{Problem 3}
Consider the inverted pendulum in Figure 1
\begin{enumerate}[label=(\alph*)]
\item 
 Assume that you can control the system in torque, i.e., that the
control input is $u = T$.

Design a feedback linearization controller (after feedback
linearization use a simple PID controller) to derive the pendulum to
the up right position. Use the following values for the parameters: 
$l = 1m, m = 1kg, b = 0.1N m^{-1} s^{-1}$, and $g =9.8ms^{-2}$. Modify
\emph{InvertedPendulum.zip} to show that your controller works. Remember
that the \emph{InvertedPendulum.zip} is a simulation for a inverted
pendulum 
on a cart and you can still use it for a inverted pendulum by just
giving zero input to the cart. You can also create your own simulator
in Matlab-Simulink to show your work.  
\item[]

The equation of motion is
\begin{equation}
  ml^2\thetaddot = mgl\sin(\theta) + b\thetadot + T,
\end{equation}
which gives
\begin{equation}
  \thetaddot = \frac{g}{l}\sin(\theta) - \frac{b}{ml^2}\thetadot +
  \frac{1}{ml^2}T.
\end{equation}
We want $\frac{1}{ml^2}T$ to be able to cancel out all the terms of
on the right hand of the equation above.  Thus, our $T$ wil be
\begin{equation}
  T = ml^2\left(\frac{-g}{l}\sin(\theta) + \frac{b}{ml^2}\thetadot
    +u_{lin}\right). 
\end{equation}
Now if we use a PID controller for the linear input portion of $T$,
then we can stick that in and we'll get 
\begin{equation}
  T = ml^2\left(\frac{-g}{l}\sin(\theta) + \frac{b}{ml^2}\thetadot
     - k_p\theta - k_d\thetadot \right).
\end{equation}

I set this up in the \emph{InvertedPendulum} files.  The parameters
given wer in the file 

{\singlespacing
\lstinputlisting{param.m}
} 

I also found it necessary to modify the pendulum.m file in the
following ways:

{\singlespacing
\lstinputlisting[firstline=57,lastline=58,firstnumber=57]{pendulum.m}
\lstinputlisting[firstline=69,lastline=71,firstnumber=69]{pendulum.m}
\lstinputlisting[firstline=102,lastline=120,firstnumber=102]{pendulum.m}
}
I also modified the simulink model, by adding in a PID controller with
the PID parameters in paralell with the controller specified in the
file controller.m:
{\singlespacing
\lstinputlisting{controller.m}
}

I had difficulties getting the drawPendulum to work, so I just dumped
the output to the workspace and plotted $\theta$ from there.  The plot
is shown in figure \ref{fig:prob3}.

\begin{matlabc}
%}

% Setup the same parameters:
param

% Load in the data from the simulation
load thetaout.mat
d = theta_out.data;
d = d(1:10:end);

f1 = figure;
try
    plot(theta_out)
catch ME
    plot(d)
    xlabel('Sample')
end
ylabel('\theta')
grid on

% Output to .eps and .pdf:
print(f1, '-depsc2', 'theta.eps')
system('ps2pdf -dEPSCrop theta.eps')

%{
\end{matlabc}

\begin{figure}
  \centering
  \includegraphics[width=.8\linewidth]{theta}
  \caption{The $\theta$ measurement as output from the simulation.}
  \label{fig:prob3}
\end{figure}


\item 
Assume now that the pendulum is mounted on a cart and that
you can control the cart's jerk, which is the derivative of its
acceleration $a$. In this case, 
$T = -mla \cos(\theta), \dot{a} = u$. Design the feedback linearization
controller for the new system.Show your work in using  
\emph{InvertedPendulum.zip} (use parameters in 
\emph{param.m}).
\item[]
  We begin by substituting the above expression for $T$ into the
  equation of motion to get
  \begin{equation}
    \begin{split}
      \thetaddot &= \frac{g}{l}\sin(\theta) - \frac{b}{ml^2}\thetadot
      + \frac{T}{ml^2}\\
      &=  \frac{g}{l}\sin(\theta) - \frac{b}{ml^2}\thetadot
      + \frac{mla\cos(\theta)}{ml^2}\\
      &=  \frac{g}{l}\sin(\theta) - \frac{b}{ml^2}\thetadot
      + \frac{a}{l}\cos(\theta).
    \end{split}
  \end{equation}
Now, let's define a state vector and let $v = \thetaddot$, and thus,
$\vdot = \dddot{\theta}$.  Taking a derivative of $v$ to get $\vdot$,
we obtain
\begin{equation}\label{eq:eq10}
  \vdot = \frac{g}{l}\sin(\theta)\thetadot - \frac{b}{ml^2}\thetaddot 
  - \frac{\dot{a}}{l}\cos(\theta) + \frac{a}{l}\sin(\theta)\thetadot
\end{equation}
Now, we are given that we can control the jerk, i.e. we can control
$\dot{a}$. So let $u = \dot{a}$, and then compensating for all the
``nonlinear'' terms in the equations of motion, we get an $\dot{a}$
that looks like
\begin{equation}
  u = \dot{a} = g\tan(\theta) \thetadot -
  \frac{b}{ml}\frac{\thetaddot}{\cos(\theta)}
  + a\tan(\theta)\thetadot - \frac{l}{\cos(\theta)}u_{lin}.
\end{equation}
The first three terms cancel out everything else in equation
\ref{eq:eq10}, leaving
\begin{equation}
  \vdot = u_{lin}.
\end{equation}
\end{enumerate}

\end{document}
%}
