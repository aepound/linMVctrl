%{
\documentclass{article}
\input{../hw6/commonheader}
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
	morekeywords={% 					% keywords
	break,case,catch,continue,elseif,else,end,for,function,global,%
	if,otherwise,persistent,return,switch,try,while,...,
        classdef,properties,methods},%
	comment=[l]\%,% 					% comments
	morecomment=[l]...,% 					% comments
	morestring=[m]',%   					% strings 
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
\title{ECE 6320: Homework 8}
\author{Andrew Pound}
%\date{\input{date.tex}}

\begin{document}
\maketitle

\section{Problem 1}
Consider a communication satellite of mass m orbiting around the
earth. The altitude of the satellite is specified by $r(t)$,
$\theta(t)$, and $\phi(t)$ as shown. The orbit can be controlled by
three orthogonal thrusts; $u_r$ , $u_\theta (t)$, and $u_\phi (t)$. If
you remember you have already computed the exact nonlinear equations
in homework 1. You can refresh your memory 
by looking equation (2.47) on page 36 in Chen. One solution which
corresponds to a circular orbit is given by
\begin{equation*}
  x0 (t) =
  \begin{bmatrix}
    r_0 & 0 &\omega_0t &\omega_0 &0 &0 
  \end{bmatrix}.
\end{equation*}

Around this solution (use the linearized state-space).

\subsection{The linearized system}
The full nonlinear system equations are given (from hw 1) as
\begin{equation}
  \begin{split}
  \ddot{r} &= r\phidot^2 + r\cos^2(\phi)\thetadot^2 - \frac{GM}{r^2} + 
  \frac{u_r}{m}\\
    \ddot{\phi}  &= 
    - 2\frac{\rdot}{r}\phidot 
    - \cos(\phi)\sin(\phi)\thetadot^2 
    + \frac{u_\phi}{mr}\\
  \thetaddot & = 
  2\frac{\sin(\phi)}{\cos(\phi)}\phidot\thetadot 
  -2\frac{\rdot}{r}\thetadot 
+ \frac{u_\theta}{mr\cos(\phi)}.
  \end{split}
\end{equation}


The linearized system around the given trajectory is given in Example
2.9 in the Checn book.  It is
\begin{align*}
  A &=
  \begin{bmatrix}
    &0           &1        &0 &0       &0     &0\\
    &3\omega_0^2 &0        &0 &2\omega_0r_0 &0     &0\\
    &0           &0        &0 &1       &0     &0\\
    &0           &\frac{-2\omega_0}{r_0} &0 &0       &0     &0\\
    &0           &0        &0 &0       &0     &1\\
    &0           &0        &0 &0       &-\omega_0^2 &0
  \end{bmatrix}
  & B &= 
  \begin{bmatrix}
    0            &0            &0\\
    \frac{1}{m}  &0            &0\\
    0            &0            &0\\
    0            &\frac{1}{mr_0}  &0\\
    0            &0            &0\\
    0            &0            &\frac{1}{mr_0}
  \end{bmatrix}\\
  C&=
  \begin{bmatrix}
    1 &0 &0 &0& 0& 0\\
    0 &0 &1 &0& 0& 0\\
    0 &0 &0 &0& 1& 0
  \end{bmatrix}
\end{align*}

\begin{matlabc}
%}
%% Setting up the linearized system.
syms w0 r0 m;
A = [ 0 1 0 0 0 0 ;...
      3*w0^2 0 0 2*w0*r0 0 0; ...
      0 0 0 1 0 0; ...
      0 -2*w0/r0 0 0 0 0; ...
      0 0 0 0 0 1; ...
      0 0 0 0 -w0^2 0];

B = [  0   0        0; ...
       1/m 0        0; ...
       0   0        0;...
       0   1/(m*r0) 0; ...
       0   0        0; ...
       0   0        1/(m*r0)];

C = [ 1 0 0 0 0 0; ...
      0 0 1 0 0 0; ...
      0 0 0 0 1 0];
% A function to compute the controllability matrix:
contMat = @(A,B) [B A*B A^2*B A^3*B A^4*B A^5*B];
%{
\end{matlabc}


\begin{enumerate}[label={(\alph*)}]
\item Is the system controllable when all the thrusters can be used? 
\item[]
  We first build the controllability matrix:
{\singlespacing
\begin{lstlisting}
%}
Con = contMat(A,B);
if exist('prob1a1.txt','file')
  delete('prob1a1.txt');
end
if exist('prob1a0.txt','file')
  delete('prob1a0.txt');
end
rank1 = double(rank(Con));
if rank1 == 6
  fid = fopen('prob1a1.txt','wt');
else
  fid = fopen('prob1a0.txt','wt');
end
fprintf(fid,'%d',rank1);
fclose(fid);
disp(rank1)

%{
\end{lstlisting}}
The output from the rank command is shown below.
{\singlespacing
\IfFileExists{prob1a0.txt}{\lstinputlisting{prob1a0.txt}}
{\lstinputlisting{prob1a1.txt}}  
}
Thus, the system is \emph{not}
controllable.

\item Is the system controllable when thruster $u_\phi$ cannot be
  used?
\item Is the system controllable when thruster $u_\theta$ cannot be
  used? 
\item Is the system controllable when thruster $u_r$ cannot be used? 
\item Is the system controllable when thruster $u_\phi$ and $u_\theta$
  cannot be used?
\end{enumerate}




\section{Problem 2}\label{sec:prob1}

The cart carrying the inverted pendulum is driven by an electric motor.
Assume that the motor drives one pair of the wheels of the cart, so that
the whole cart, pendulum and all, becomes the load on the motor. The
differential equations of this system are written as
\begin{equation*}
  \begin{split}
    \xddot + \frac{k^2}{Mr^2R}\xdot + \frac{mg}{M}\theta 
    &= \frac{k}{MRr}e \\
    \thetaddot - \left(\frac{M+m}{Ml}\right)g\theta -
    \frac{k^2}{Mr^2Rl}\xdot 
    &= \frac{k}{MRrl}e
  \end{split}
\end{equation*}
where $k$ is the motor torque constant, $R$ is the motor resistance, 
$r$ is the ratio of motor torque to linear force applied to the cart
($\tau = rf$), and $e$ is the voltage applied to the motor. Let the
state vector and input be defined $\xbf = [x, \dot{x},
\theta,\thetadot]^T$  and $u = e$. 
 \begin{enumerate}[label={(\alph*)}]
 \item Find the A and B matrices of the state space
 \item[] The first thing is to rearrange the equations as 
\begin{equation*}
  \begin{split}
    \xddot &=- \frac{k^2}{Mr^2R}\xdot - \frac{mg}{M}\theta 
    + \frac{k}{MRr}e \\
    \thetaddot &= \left(\frac{M+m}{Ml}\right)g\theta +
    \frac{k^2}{Mr^2Rl}\xdot 
    + \frac{k}{MRrl}e.
  \end{split}
\end{equation*}
The we can stack these to form
\begin{equation*}
  \begin{split}
    \xbf =
    \begin{bmatrix}
      \xdot \\ \xddot \\ \thetadot \\ \thetaddot
    \end{bmatrix}
    &=
    \begin{bmatrix}
      0 & 1 & 0 & 0\\
      0 & \frac{-k^2}{Mr^2R} & \frac{-mg}{M} & 0\\
      0 & 0 & 0 & 1\\
      0 & \frac{k^2}{Mr^2Rl} & \frac{M+m}{Ml}g & 0
    \end{bmatrix}
    \begin{bmatrix}
      x \\ \xdot \\ \theta \\ \thetadot
    \end{bmatrix}
 + 
 \begin{bmatrix}
   0 \\ \frac{k}{MRr} \\ 0 \\ \frac{k}{MRrl}
 \end{bmatrix}e.
  \end{split}
\end{equation*}

 \item Is the system controllable?
 \item[]


{\singlespacing
\begin{lstlisting}
%}
%% Problem 2.
m = 0.1; 
M = 1;
l = 1;
g = 9.8;
k = 1;
R = 100;
r = 0.02;

syms m M l g k R r;

contMat = @(A,B) [B A*B A^2*B A^3*B];

A = [ 0 1 0 0;...
      0 -k^2./(M*r^2*R) -m*g/(M) 0;...
      0 0 0 1;
      0 k^2/(M*r^2*R*l) (M+m)/(M*l)*g 0];

B = [ 0; k/(M*R*r); 0; k/(M*R*r*l)];

Con = contMat(A,B);
if exist('prob2b1.txt','file')
  delete('prob2b1.txt');
end
if exist('prob2b0.txt','file')
  delete('prob2b0.txt');
end
rank2 = double(rank(Con));
if rank2 == 6
  fid = fopen('prob2b1.txt','wt');
else
  fid = fopen('prob2b0.txt','wt');
end
fprintf(fid,'%d',rank2);
fclose(fid);
disp(rank2)

%{
\end{lstlisting}}
The rank of the controllability matrix is 
\IfFileExists{./prob2b1.txt}{\input{prob2b1.txt}}{\input{prob2b0.txt}}.
Thus the system is \IfFileExists{./prob2b0.txt}{\emph{not}}{}
controlable. 
 \end{enumerate}
The following numerical data can be used if would rather use numbers
then letters:
$m = 0.1kg$, $M = 1.0kg$, $l = 1.0m$, $g = 9.8ms^{-2}$, $k = 1V$, $R =
100\Omega$,  
and $r = 0.02m$.


\section{Problem 3}

State-space equations of a double-effect evaporator is given as
\begin{equation*}
\begin{bmatrix}
\xdot_1 \\ \xdot_2\\ \xdot_3 \\ \xdot_4 \\ \xdot_5
\end{bmatrix}
 = 
\begin{bmatrix}
0 &-.00156 &-.0711 &0 &0\\
0 &-.1419  &.0711  &0 &0\\
0 &-.00875 &-1.102 &0 &0\\
0 &-.00128 &-.1489 &0 &-.0013 \\
0 &.0605   &.1489  &0 &-.0591\\
\end{bmatrix}
\begin{bmatrix}
x_1 \\ x_2 \\x_3  \\ x_4 \\ x_5
\end{bmatrix} + 
\begin{bmatrix}
0 &-.143  &0\\
0 &0      &0\\
0 &0      &.392\\
0 &.108   &-.0592\\ 
0 &-.0486 &0\\
\end{bmatrix}
\begin{bmatrix}
u_1 \\ u_2 \\ u_3
\end{bmatrix}
\end{equation*}
Determine whether or not the evaporator is controllable from each of
the following combinations of inputs:

\subsection{My Answer}
First, let's put them into \matlab.

{\singlespacing
\begin{lstlisting}
%}
%% Problem 3

A = [...
     0 -.00156 -.0711 0 0;...
     0 -.1419  .0711  0 0;...
     0 -.00875 -1.102 0 0;...
     0 -.00128 -.1489 0 -.0013;...
     0 .0605   .1489  0 -.0591];

B = [...
     0 -.143  0; ...
     0 0      0;...
     0 0      .392;...
     0 .108   -.0592;...
     0 -.0486 0];

contMat = @(A,B) [B A*B A^2*B A^3*B A^4*B];
%{
\end{lstslisting}}


\begin{enumerate}[label={(\alph*)}]
\item $u_1$ only;
\item 
$u_1$ and $u_2$ ;
\item 
$u_1$ and $u_3$ ;
\item 
$u_2$ and $u_3$ ;
\end{enumerate}



\end{document}
%}
