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
Find the state feedback gain $k$ so that the state feedback system
has -1 and -2 as its eigenvalues.  Compute k directly without using
similarity transformation. \emph{Do not use matlab. Please show your
  work.}

\subsection{My Answer}
Let $u = r - kx$, then
\begin{equation*}
  \xdot = \left(\begin{bmatrix}
    2 & 1 \\ -1 & 1
  \end{bmatrix}-
  \begin{bmatrix}
    k_1 & k_2 \\ 2k_1 & k_2
\end{bmatrix}\right)x(t)+
  \begin{bmatrix}
    1 \\ 2
  \end{bmatrix}r(t)
\end{equation*}
Thus, $(sI - \Abar)$ becomes:
\begin{equation*}
  \begin{bmatrix}
    s - 2 + k_1 & -1+k_2 \\ 1+2k_2 & s-1+2k_2
  \end{bmatrix}
\end{equation*}
\begin{equation*}
\begin{split}
  \Delta_f(s) &= (s-2+k_1)(s-1+2k_2) - (1-2k_1)(-1+k_2)\\
  &= s^2 - 2s + k_1s -s + 2 -k_1+2k_2s - 4k_2 +2k_1k_2 - (-1 + k_2
  +2k_1 -2k_1k_2)\\ 
  &= s^2 +(-2 + k_1 -1 + 2k_2)s + (2 - k_1-4k_2 + 2k_1k_2 +1 - k_2 -
  2k_1 + 2k_1k_2)\\
  &= s^2 + (-3 + k_1 + 2k_2)s +(3-3k_1-5k_2 + 4k_1k_2)
\end{split}
\end{equation*}
We want this to be:
\begin{equation*}
  (s+1)(s+2) = s^2 + 3s + 2.
\end{equation*}
Thus,
\begin{equation*}
  \begin{split}
    3 &= -3 + k_1 + 2k_2\\
    2 &= 3-3k_1-5k_2 + 4k_1k_2
  \end{split}
\end{equation*}
So, using substitution, we solve first for $k_1$ to get
\begin{equation*}
  k_1 = 6 - 2k_2.
\end{equation*}
Plugging that back into the the other equation, we get
\begin{equation*}
\begin{split}
    2 &= 3-3(6 - 2k_2)-5k_2 + 4(6 - 2k_2)k_2\\
    2 &= 3-18 + 6k_2 -5k_2+ (24 - 8k_2)k_2\\
    2 &= -8k_2^2 + 24k_2 + k_2 - 15\\
    0 &=-8k_2^2 + 25k_2 - 17
\end{split}
\end{equation*}
Using the quadratice formula, we get the following for $k_2$
\begin{equation*}
  k_2 = \frac{-25 \pm \sqrt{25^2 - 4(-8)(-17)}}{2(-8)} \approx \{2.125,1\}
\end{equation*}
Let's choose $k_2 = 1$, then 
\begin{equation*}
  k_1 = 6 - 2(1) = 4.
\end{equation*}

Double check:
\begin{equation*}
  \begin{split}
    -3 + 4 + 2*1 &= 3 \\
3 - 3*4 - 5*1 + 4*4*1 &= 2
  \end{split}
\end{equation*}
Thus our gain vector is 
\begin{equation*}
  k =
  \begin{bmatrix}
    4 & 1
  \end{bmatrix}.
\end{equation*}

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
The desired charateristic polynomial is 
\begin{equation*}
  \begin{split}
  \Delta_f(s) 
  &= (s + 2)(s + 1 + j)(s + 1 - j) \\
  &= (s + 2)(s^2 + 2s + 2)\\
  &= s^3 + 4s^2 + 6 s + 4.
  \end{split}
\end{equation*}

Calculating $(sI = \Abar)$, we get
\begin{equation*}
  \begin{split}
  (sI - A + kB) &=
  \begin{bmatrix}
    s - 1 + k_1 & -1 + k_2 & 2 + k_3\\
    0 & s - 1 & -1\\
    k_1 & k_2 & s- 1+k_3
  \end{bmatrix}
  \end{split}
\end{equation*}
The characteristice polynomial from this is
\begin{equation*}
\begin{split}
  \Delta_f(s) &= 
  (s-1+k_1)\left[(s-1)(s-1+k_3) + k_2\right] + k_1\left[(-1+k_2)(-1) -
    (s-1)(2+k_3)\right]\\
  & = (s-1+k_1)\left[s^2-s +k_3s-s+1-k_3 + k_2\right] + k_1\left[1-k_2 -
    2s-k_3s+2+k_3\right]\\
  &= (s-1+k_1)\left[s^2+(k_3-2)s +1+ k_2-k_3 \right] + k_1\left[ -
    (2+k_3)s+3-k_2+k_3\right]\\
  &= \left[s^3 + (k_1  + k_3 - 3)s^2 + (3 - 2k_3 + k_2 -2k_1 +
    k_1k_3)s + (k_1k_2 - k_1k_3 + k_1 - k_2 + k_3 - 1     )\right]\\
  &\qquad  + \left[(-2k_1 - k_1k_3)s + (3k_1 - k_1k_2 +
    k_1k_3)\right]\\
  &= s^3 + (k_1  + k_3 - 3)s^2 + (3 - 2k_3 + k_2 -2k_1 +
    k_1k_3 -2k_1 - k_1k_3)s  \\
  & \qquad +(k_1k_2 - k_1k_3 + k_1 - k_2 + k_3 - 1 + 3k_1 - k_1k_2 +
    k_1k_3)\\
  &= s^3 + (k_1  + k_3 - 3)s^2 + (3 -4k_1+ k_2 - 2k_3  )s  +(4k_1 - k_2 + k_3 - 1)
\end{split}
\end{equation*}
Thus we know that we need
\begin{equation*}
  \begin{split}
    4 &= k_1  + k_3 - 3\\
    6 &= -4k_1+ k_2 - 2k_3 + 3\\
    4 &= 4k_1 - k_2 + k_3 - 1.
  \end{split}
\end{equation*}
Then we know that 
\begin{equation*}
  k_1 = 7 - k_3.
\end{equation*}
Substituting this back in we get:
\begin{equation*}
\begin{split}
  6 &= 3 -4k_1+ k_2 - 2k_3\\
  &= 3 -4(7 - k_3)+ k_2 - 2k_3\\
  &= 3 - 28 + 4k_3 + k_2 - 2k_3\\
  &= -25 + k_2 + 2k_3\\
  31 &= k_2 + 2k_3\\
  k_2& = 31 - 2k_3.
\end{split}
\end{equation*}
Then we can substitute both of these into the third equation to get
\begin{equation*}
  \begin{split}
    4 &=  4k_1 - k_2 + k_3 - 1\\
    & = 4(7 - k_3) - (31 - 2k_3) + k_3 - 1\\
    &= 28 - 4k_3 - 31 +2k_3 + k_3 - 1\\
    &= -3 -k_3 - 1\\
    &= -4 - k_3\\
    k_3 &= -8.    
  \end{split}
\end{equation*}
Together, we have
\begin{equation*}
  \begin{split}
    k_1 &= 7 - k_3 = 7 + 8 = 15\\
    k_2 &= 31 - 2(-8) = 31 + 16 = 47\\
    k_3 &= -8.
  \end{split}
\end{equation*}
Doublecheck to make sure it works.
\begin{equation*}
  \begin{split}
  k1+ k3 - 3 &=15- 8 - 3 = 4 \quad \checkmark\\
  -4k_1 + k_2 - 2k_3 + 3 &= -4(15) + 47  - 2(-8) + 3 = 6 \quad
  \checkmark\\
  4k_1 - k_2 + k_3 - 1 &= 4(15) - 47 - 8 -1 = 4 \quad \checkmark
  \end{split}
\end{equation*}


\begin{matlabc}
%}
% This is for doublechecking again... ;)
A = [1 0 1; -4 1 -2; 4 -1 1];
b = [4; 6; 4];
a = [-3 ; 3; -1];
% The system is:
% b = A*k + a
k = inv(A)*(b-a)
%{
\end{matlabc}


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
The desired charateristic polynomial is 
\begin{equation*}
  \begin{split}
  \Delta_f(s) 
  &= (s + 2)(s + 1 + j)(s + 1 - j) \\
  &= (s + 2)(s^2 + 2s + 2)\\
  &= s^3 + 4s^2 + 6 s + 4.
  \end{split}
\end{equation*}
Thus, we know that 
\begin{align*}
  \bar{\alpha}_1 &= 4 &
  \bar{\alpha}_2 &= 6 \\
  \bar{\alpha}_3 &= 4
\end{align*}

Ok, let's calculate the charateristic polynomila of the current
system.
\begin{equation*}
\det(sI - A) = \det\left(
  \begin{bmatrix}
    s - 1 & -1 & 2\\
    0 &s - 1 & -1\\
    0 & 0 & s-1
  \end{bmatrix}\right)
 = (s-1)^3 = s^3 - 3s^2 + 3s -1.
\end{equation*}

Thus, we know that 
\begin{align*}
  {\alpha}_1 &= -3 &
  {\alpha}_2 &= 3 \\
  {\alpha}_3 &= -1.
\end{align*}
Using these, we now know our $\kbar$
\begin{equation*}
  \kbar =
  \begin{bmatrix}
    \bar{\alpha}_1 -\alpha_1 &
    \bar{\alpha}_2 -\alpha_2 &
    \bar{\alpha}_3 -\alpha_3 
  \end{bmatrix}
  =\begin{bmatrix}
    7 & 3 & 5
  \end{bmatrix}.
\end{equation*}


Now, let's form the controllability matrix.
First, let's calculate $A^2$.
\begin{equation*}
  \begin{split}
    A^2 &= 
    \begin{bmatrix}
      1 & 1 & -2\\ 0 & 1 & 1\\ 0 & 0 & 1
    \end{bmatrix}
    \begin{bmatrix}
      1 & 1 & -2\\ 0 & 1 & 1\\ 0 & 0 & 1
    \end{bmatrix} =
    \begin{bmatrix}
      1 & 2 & -3\\ 0 & 1 & 2\\ 0 & 0 & 1
    \end{bmatrix}
  \end{split}
\end{equation*}
Thus, we can calculate the components of the controllability matrix as
\begin{align*}
  \bbf &=
  \begin{bmatrix}
    1 \\ 0 \\ 1
  \end{bmatrix}
  & A\bbf &= 
  \begin{bmatrix}
    -1 \\ 1\\ 1
  \end{bmatrix}
  & A^2\bbf &= 
  \begin{bmatrix}
    -2 \\ 2 \\ 1
  \end{bmatrix}
\end{align*}
Now, we can build the controllability matrix.
\begin{equation*}
  C_{con} =
  \begin{bmatrix}
    \bbf & A\bbf & A^2\bbf
  \end{bmatrix}
  = \begin{bmatrix}
       1 & -1 & -2\\ 0 & 1 & 2\\ 1 & 0 & 1
  \end{bmatrix}.
\end{equation*}
Ok. Using this, we can find our $P^{-1}$ as
\begin{equation*}
  P^{-1} = C_{con}\bar{C}_{con}^{-1} =.
\end{equation*}

We also need to calculate our $\Cbar_{con}$ matrix:
\begin{align*}
  \Abar &=
  \begin{bmatrix}
    -\alpha_1 & -\alpha_2 & -\alpha_3\\
    1 & 0 & 0 \\
    0 & 1& 0 
  \end{bmatrix}
  & \bbar &=
  \begin{bmatrix}
    1 \\ 0 \\ 0
  \end{bmatrix}
  & \Abar^2 &= 
  \begin{bmatrix}
    \alpha_1^2-\alpha_2 & \alpha_1\alpha_2 - \alpha_3 & \alpha_1\alpha_3\\
    -\alpha_1 & -\alpha_2 & -\alpha_3\\
    1 & 0 & 0
  \end{bmatrix}\\
  \Abar\bbar &=
  \begin{bmatrix}
    \alpha_1 \\ 1 \\ 0
  \end{bmatrix}
  & \Abar^2\bbar &= 
  \begin{bmatrix}
    \alpha_1^2 - \alpha_2\\ -\alpha_1 \\ 1
  \end{bmatrix}
  & \Cbar_{con} &= 
  \begin{bmatrix}
    1 &-\alpha_1& \alpha_1^2 - \alpha_2\\
    0 & 1 & -\alpha_1 \\ 0 & 0 & 1
  \end{bmatrix} =
  \begin{bmatrix}
    1 & 3 & 6 \\ 0 & 1 & 3\\ 0 & 0 & 1
  \end{bmatrix}
\end{align*}
Taking the inverse of $\Cbar_{con}$, we get
\begin{equation*}
  \Cbar_{con}^{-1} =
  \begin{bmatrix}
    1 & -3 & 3\\ 0 & 1 & -3 \\ 0 & 0 & 1
  \end{bmatrix}.
\end{equation*}
Then we get 
\begin{equation*}
  P^{-1} = C_{con}\Cbar_{con}^{-1} =
  \begin{bmatrix}
       1 & -1 & -2\\ 0 & 1 & 2\\ 1 & 0 & 1
  \end{bmatrix}
  \begin{bmatrix}
    1 & -3 & 3\\ 0 & 1 & -3 \\ 0 & 0 & 1
  \end{bmatrix}
  =
  \begin{bmatrix}
    1 & -4 & 4 \\ 0 & 1 & -1 \\ 1 & -2 & 1
  \end{bmatrix}
\end{equation*}
And thus, 
\begin{equation*}
  P =
  \begin{bmatrix}
    1 & 4 & 0 \\ 1 & 3 & -1 \\ 1 & 2 & -1
  \end{bmatrix}
\end{equation*}
And using this transformation matrix, we can get our gain vector  $k$ as
\begin{equation*}
  k = \kbar P =
  \begin{bmatrix}
    7 & 3 & 5
  \end{bmatrix}
  \begin{bmatrix}
    1 & 4 & 0 \\ 1 & 3 & -1 \\ 1 & 2 & -1
  \end{bmatrix}
  =
  \begin{bmatrix}
    15 & 47 & -8
  \end{bmatrix}.
\end{equation*}
The same as before.  (Using a different method... Dang it! Why did I just put all
this time into this!!!)

Ok, the feed forward gain to match any step input can be found by using the
transformed $\Cbar$ matrix.
\begin{equation*}
  \Cbar = CP^{-1} =
  \begin{bmatrix}
    2 & 0 & 0
  \end{bmatrix}
  \begin{bmatrix}
    1 & -4 & 4 \\ 0 & 1 & -1 \\ 1 & -2 & 1
  \end{bmatrix} = 
  \begin{bmatrix}
    2 & -8 & 8
  \end{bmatrix} = 
  \begin{bmatrix}
    \beta_1 &    \beta_2 &    \beta_3 
  \end{bmatrix}
\end{equation*}
And from my notes from class, the feedforward gain to be able to track and step
input $a$ is
\begin{equation*}
  p = \frac{\bar{\alpha_3}}{\beta_3} = \frac{4}{8} = \frac{1}{2}.
\end{equation*}


\section{Problem 4}
Consider the uncontrollable state equation
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


I'm not sure yet... I'll get to this problem next...
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

I'll work on this after I figure out problem 4.





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
