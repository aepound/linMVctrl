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

\section{Problem 1}\label{sec:prob1}
Consider the inverted pendulum in Figure 1 . The equation of motion
can be written as
\begin{figure}[h!]
  \centering
  {\Huge Put in a figure here...}
  \caption{Inverted Pendulum}
  \label{fig:1}
\end{figure}
\begin{equation*}
 ml^2 \thetaddot = mgl \sin \theta - b\thetadot + T 
\end{equation*} 
where $T$ denotes the applied torque at the base and $g$ is the
gravitational acceleration. For this system assume the input and
output to the system are the signals $u$ and $y$ defined as $T =
sat(u)$, $y = \theta$ where ``sat'' denotes the unit-slope saturation
function that truncates $u$ at $+1$ and $-1$.
\begin{enumerate}[label=(\alph*)]
\item 
 Linearize this system around the equilibrium point for which
$\theta = 0$.  
\item 
 Linearize this system around the equilibrium point for which $\theta
 = \pi$ (Assume that the pendulum is free to rotate all the way to
 this configuration without hitting the table).
\item 
Linearize the system around the equilibrium point for which $\theta =
\frac{\pi}{4}$. 
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
  \begin{bmatrix}
    x_1\\  x_2\\ x_3
  \end{bmatrix}= 
  \begin{bmatrix}
    p_x \cos \theta + (p_y - 1) \sin \theta\\
    -p_x \sin \theta + (p_y - 1) \cos \theta\\
    \theta
  \end{bmatrix}
\end{equation}
and output $y = \left[x_1 x_2 \right]^T \in \Rbb^2$.
\item 
Compute a local linearization for this system around the equilibrium
point $x^{eq} = 0$ and $u^{eq} = \theta$. 
\item 
Show that $\omega(t) = v(t) = 1$, $p_x (t) = \sin t$, $p_y = 1 - \cos t$, and
$\theta(t) = t, \forall \: t \ge 0$ is a solution to the system.
\item 
 Show that a local linearzation of this system around this trajectory
$( \omega(t) = v(t) = 1\text{, } p_x (t) = \sin t\text{, } p_y =
1-\cos t\text{, and }\theta(t) = t,\: \forall \: t \ge 0)$
results in an Linear Time Invariant (LTI) system.
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
Inverted Pendulum.zip to show that your controller works. Remember
that the Inverted Pendulum.zip is a simulation for a inverted pendulum
on a cart and you can still use it for a inverted pendulum by just
giving zero input to the cart. You can also create your own simulator
in Matlab-Simulink to show your work.  
\item 
Assume now that the pendulum is mounted on a cart and that
you can control the cart's jerk, which is the derivative of its ac-
celeration $a$. In this case,
$T = -mla cos \theta, a = u$. Design the feedback linearization con-
troller for the new system.Show your work in using Inverted Pen-
dulum.zip (use parameters in param.m).
\end{enumerate}

\end{document}
%}
