%{
\documentclass[10pt]{article}
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

% A debugging flag:
debugging = 1;
%{
\end{matlabc}
\title{ECE 6320: Homework 9}
\author{Andrew Pound}
%\date{\input{date.tex}}

\begin{document}

\maketitle
\singlespacing

\section{Problem 1}
Given 
\begin{equation*}
\begin{split}
  \xdot(t) &=
  \begin{bmatrix}
    2 & 1 \\ -1 & 1
  \end{bmatrix}x(t) +
  \begin{bmatrix}
    1 \\ 2
  \end{bmatrix}u(t)\\
  y(t) &=
  \begin{bmatrix}
    1 & 1
  \end{bmatrix} x(t).
\end{split}
\end{equation*}
Finde the state feedback gain $k$ so that the state feedback system
has -1 and -2 as its eigenvalues.  Compute k directly without using
similarity transformation. \emph{Do not use matlab. Please show your
  work.}

\subsection{My Answer}


\section{Problem 2}
Find the state feedback gain for the state equation
\begin{equation*}
\begin{split}
  \xdot(t) &=
  \begin{bmatrix}
    1 & 1 & -2\\ 0 & 1 & 1\\
    0 & 0 & 1
  \end{bmatrix}x(t) +
  \begin{bmatrix}
    1 \\ 0 \\ 1
  \end{bmatrix}u(t)
\end{split}
\end{equation*}
so that the resulting system has eigenvalues -2 and $-1\pm j1$. Use
the method you think is the simplest by hand to carry out the design.
\emph{Do not use matlab. Please show your  work.}

\subsection{My Answer}

\section{Problem 3}
Consider the continuous-time state space equation
\begin{equation*}
\begin{split}
  \xdot(t) &=
  \begin{bmatrix}
    1 & 1 & -2\\ 0 & 1 & 1\\
    0 & 0 & 1
  \end{bmatrix}x(t) +
  \begin{bmatrix}
    1 \\ 0 \\ 1
  \end{bmatrix}u(t)\\
  y(t) &=
  \begin{bmatrix}
    2 & 0 & 0
  \end{bmatrix}
  x(t).
\end{split}
\end{equation*}
Let $u(t) = pr(t) - kx(t)$. Find the feed-forward gain $p$ and state
feedback gain $k$ so that the resulting system has eigenvalues -2 and
$-1 \pm j1$ and will track asymptotically any step reference input.
\emph{Validate results by \matlab plots.}

\subsection{My Answer}

\section{Problem 4}
Consider the uncontrollable state equaiton
\begin{equation*}
\begin{split}
  \xdot(t) &=
  \begin{bmatrix}
    2 & 1 & 0 & 0\\ 
    0 & 2 & 0 & 0\\
    0 & 0 &-1 & 0\\
    0 & 0 & 0 &-1
  \end{bmatrix}x(t) +
  \begin{bmatrix}
    0 \\ 1 \\ 1 \\ 1
  \end{bmatrix}u(t).
\end{split}
\end{equation*}
Is it possible to find a gain $k$ so that the equation with state
feedback $u = r - kx$ has eigenvalues $-2, -1, -1, -1$?  Is it
possible to have eigenvalues $-2, -2, -1, -1$? Is it possible to have
eigenvalues $-2, -2, -2, -1$? How about $-2, -2, -2, -2$?  Is this
equation stabilizable?

\subsection{My Answer}

\section{Problem 5}
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
    &= -\frac{k}{MRrl}e
  \end{split}
\end{equation*}
where $k$ is the motor torque constant, $R$ is the motor resistance, 
$r$ is the ratio of motor torque to linear force applied to the cart
($\tau = rf$), and $e$ is the voltage applied to the motor. Let the
state vector and input be defined $\xbf = [x, \dot{x},
\theta,\thetadot]^T$  and $u = e$. 
It is desired to place poles at $s = -4, s = -2 \pm j2\sqrt{3}$, and
$s = -25$.
\begin{enumerate}[label={(\alph*)}]
 \item Find the gain matrix that produces this set of closed loop
   poles. 
 \item It is desired to move the cart from one position to another
   without causing the pendulum to fall.  How must the control law of
   part \emph{a} be modified to account for a reference input $x$?
 \end{enumerate}
\emph{
Use the following numerical data and modify the inverted pendulum
simulink files you have to validate your results.  You will have to
change the param.m file, pendulum.m files, and controller.m file.}

$m = 0.1kg$, $M = 1.0kg$, $l = 1.0m$, $g = 9.8ms^{-2}$, $k = 1V$, $R =
100\Omega$,  
and $r = 0.02m$.


\subsection{My Answer}





\begin{matlabc}
%}
%% LaTeX the document...
if ~debugging
if isunix
system('pdflatex -interaction nonstopmode hw8.m > /dev/null');
system('pdflatex -interaction nonstopmode hw8.m > /dev/null');
else
system('pdflatex -interaction nonstopmode hw8.m > trash');
system('pdflatex -interaction nonstopmode hw8.m > trash');
delete('trash');
end    
end
%clear all
%close all
%{
\end{matlabc}
\end{document}
%}
