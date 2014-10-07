% %{
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
\title{ECE 6320: Homework 6}             
\author{Andrew Pound}
%\date{\input{date.tex}}

\begin{document}
\maketitle

\section{Problem 1}\label{sec:prob1}

The cart carrying the inverted pendulum is driven by an electric motor.
Assume that the motor drives one pair of the wheels of the cart, so that
the whole cart, pendulum and all, becomes the load on the motor. The
differential equations of this system are written as
\begin{equation*}
  \begin{split}
    \xddot + \frac{k^2}{Mr^2R}\xdot + \frac{mg}{M}\theta 
    &= \frac{k}{MRr} \\
    \thetaddot - \left(\frac{M+m}{Ml}\right)g\theta -
    \frac{k^2}{Mr^2Rl}\xdot 
    &= \frac{k}{MRrl}e
  \end{split}
\end{equation*}
where $k$ is the motor torque constant, $R$ is the motor resistance, 
$r$ is the ratio of motor torque to linear force applied to the cart
($\tau = rf$), and $e$ is the voltage applied to the motor. Let the
state vector and input be defined $x = [x, \dot{x}, \theta,\thetadot]$
 and $u = e$. The parameters for simulation
are
$m = 0.1kg, M = 1.0kg, l = 1.0m,g = 9.8ms^{-2}, k = 1V, R = 100\Omega,$
and $r = 0.02m$.


The gains for stablizing the inverted pendulum on a motor-driven cart
are to be optimized using a performance criterion of the form
\begin{equation*}
  J_{lqr} = \int_0^\infinity (q_1^2x_1^2 + q_3^2x_3^2 + r^2u^2)dt
\end{equation*}

A pendulum angle much greater than $1 degree =0.0017 rad$ would be
precarious. Thus a heavy weighting on $\theta = x_3$ is indicated: 
$q^2_3 =\frac{1}{(0.017)^2 }\approx 3000$. For the physical dimensions
of the system, a position error of the order $10cm = 0.1m$ is not
unreasonable. Hence  $q^2_1 =\frac{1}{(0.1)^2} =100$.

\begin{enumerate}[label=(\alph*)]
\item Using these values of $q_1^2$ and $q_3^2$ determine and plot the
  gain matrices, corresponding closed loop poles, states $x(t)$ and
  $u(t)$ (for same initial conditions) as a function of the control
  weighting parameter $r^2$ for $0.001 < r^2 < 50$. Use can follow the
  Inverted pendulum on cart \matlab example covered in the class
  (follow ``IPonCartLqrPlots.m'' (main executable file) and
  ``InvertedPendulumonCartLQR.m'' in ``Optimal Control.zip''.
\item[]

\item Repeat part (a) for a veavier weighting: $q_1^2 = 10^4$ on the
  cart displacement.
\item[]
\item (Optional: Bonus 20 points) Change the inverted pendulum on cart
  simulator for this problem and generate simulation videos for both
  the cases. Download ``Optimal Control.zip'' and use ``param.m''
  (change the parameters based on this problem), ``controller.m'',
  ``pendulum.m'', ``drawPendulum.m'', and ``pendulum\_animation.mdl''
  (similink file).
\item[]
\end{enumerate}


\end{document}
%}
