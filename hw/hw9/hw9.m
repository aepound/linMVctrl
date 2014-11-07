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

\section{Problem 1}
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
Determine whether or not the system is observable with the following
sets of observations.
\begin{enumerate}[label={(\alph*)}]
 \item Cart displacement $y = x_1$.
 \item Pendulum angle $y = x_3$.
 \item Cart velocity $y = x_2$.
 \item Cart velocity and pensulum angle $y_1 = x_2$, $y_2 = x_3$.
 \end{enumerate}
The following numerical data can be used if would rather use numbers
then letters:
$m = 0.1kg$, $M = 1.0kg$, $l = 1.0m$, $g = 9.8ms^{-2}$, $k = 1V$, $R =
100\Omega$,  
and $r = 0.02m$.


\subsection{My Answer}
The first thing is to rearrange the equations as 
\begin{equation*}
  \begin{split}
    \xddot &=- \frac{k^2}{Mr^2R}\xdot - \frac{mg}{M}\theta 
    + \frac{k}{MRr}e \\
    \thetaddot &= \left(\frac{M+m}{Ml}\right)g\theta +
    \frac{k^2}{Mr^2Rl}\xdot 
    - \frac{k}{MRrl}e.
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
   0 \\ \frac{k}{MRr} \\ 0 \\ -\frac{k}{MRrl}
 \end{bmatrix}e.
  \end{split}
\end{equation*}


{\singlespacing
\begin{lstlisting}
%}
%% Problem 1 setup
disp(['Problem 2...'])
m = 0.1; 
M = 1;
l = 1;
g = 9.8;
k = 1;
R = 100;
r = 0.02;

syms m M l g k R r;

contMat = @(A,B) [B A*B A^2*B A^3*B];
obsMat = @(A,C) [C; C*A; C*A^2; C*A^3];

A = [ 0 1 0 0;...
      0 -k^2./(M*r^2*R) -m*g/(M) 0;...
      0 0 0 1;
      0 k^2/(M*r^2*R*l) (M+m)/(M*l)*g 0];

B = [ 0; k/(M*R*r); 0; -k/(M*R*r*l)];
%{
\end{lstlisting}}


\begin{matlabc}
%}
probs = 'abcde';
ranks = struct;

%{
\end{matlabc}



\begin{enumerate}[label={(\alph*)}]
 \item Cart displacement $y = x_1$.

{\singlespacing
\begin{lstlisting}
%}
%% Part a:
part = 'a';
C = [1 0 0 0];
Obs = obsMat(A,C);


ranks.(part) = double(rank(Obs));
disp(ranks.(part))

%{
\end{lstlisting}}

\begin{matlabc}
%}
fnamebase = ['prob1' part];
if exist([fnamebase '1.txt'],'file')
  delete([fnamebase '1.txt']);
end
if exist([fnamebase '0.txt'],'file')
  delete([fnamebase '0.txt'])
end
if ranks.(part) == size(A,1)
  fid = fopen([fnamebase '1.txt'],'wt');
else
  fid = fopen([fnamebase '0.txt'],'wt');
end
fprintf(fid,'%d',ranks.(part));
fclose(fid);
%{  
\end{matlabc}

The rank of the observability matrix is 
\IfFileExists{./prob1a1.txt}{\input{prob1a1.txt}}{\input{prob1a0.txt}}.
Thus the system is \IfFileExists{./prob1a0.txt}{\emph{not}}{}
observable. 

 \item Pendulum angle $y = x_3$.

{\singlespacing
\begin{lstlisting}
%}
%% Part b:
part = 'b';
C = [0 0 1 0];
Obs = obsMat(A,C);


ranks.(part) = double(rank(Obs));
disp(ranks.(part))

%{
\end{lstlisting}}

\begin{matlabc}
%}
fnamebase = ['prob1' part];
if exist([fnamebase '1.txt'],'file')
  delete([fnamebase '1.txt']);
end
if exist([fnamebase '0.txt'],'file')
  delete([fnamebase '0.txt'])
end
if ranks.(part) == size(A,1)
  fid = fopen([fnamebase '1.txt'],'wt');
else
  fid = fopen([fnamebase '0.txt'],'wt');
end
fprintf(fid,'%d',ranks.(part));
fclose(fid);
%{
\end{matlab}

The rank of the observability matrix is 
\IfFileExists{./prob1b1.txt}{\input{prob1b1.txt}}{\input{prob1b0.txt}}.
Thus the system is \IfFileExists{./prob1b0.txt}{\emph{not}}{}
observable. 

 \item Cart velocity $y = x_2$.

{\singlespacing
\begin{lstlisting}
%}
%% Part c:
part = 'c';
C = [ 0 1 0 0];
Obs = obsMat(A,C);


ranks.(part) = double(rank(Obs));
disp(ranks.(part))

%{
\end{lstlisting}}

\begin{matlabc}
%}
fnamebase = ['prob1' part];
if exist([fnamebase '1.txt'],'file')
  delete([fnamebase '1.txt']);
end
if exist([fnamebase '0.txt'],'file')
  delete([fnamebase '0.txt'])
end
if ranks.(part) == size(A,1)
  fid = fopen([fnamebase '1.txt'],'wt');
else
  fid = fopen([fnamebase '0.txt'],'wt');
end
fprintf(fid,'%d',ranks.(part));
fclose(fid);
%{
\end{matlabc}

The rank of the observability matrix is 
\IfFileExists{./prob1c1.txt}{\input{prob1c1.txt}}{\input{prob1c0.txt}}.
Thus the system is \IfFileExists{./prob1c0.txt}{\emph{not}}{}
observable. 

 \item Cart velocity and pensulum angle $y_1 = x_2$, $y_2 = x_3$.

{\singlespacing
\begin{lstlisting}
%}
%% Part d:
part = 'd';
C = [ 0 1 0 0; 0 0 1 0];
Obs = obsMat(A,C);


ranks.(part) = double(rank(Obs));
disp(ranks.(part))

%{
\end{lstlisting}}

\begin{matlabc}
%}
fnamebase = ['prob1' part];
if exist([fnamebase '1.txt'],'file')
  delete([fnamebase '1.txt']);
end
if exist([fnamebase '0.txt'],'file')
  delete([fnamebase '0.txt'])
end
if ranks.(part) == size(A,1)
  fid = fopen([fnamebase '1.txt'],'wt');
else
  fid = fopen([fnamebase '0.txt'],'wt');
end
fprintf(fid,'%d',ranks.(part));
fclose(fid);
%{
\end{matlabc}

The rank of the observability matrix is 
\IfFileExists{./prob1d1.txt}{\input{prob1d1.txt}}{\input{prob1d0.txt}}.
Thus the system is \IfFileExists{./prob1d0.txt}{\emph{not}}{}
observable. 
\end{enumerate}


\section{Problem 2}

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
.3920 &0 & 0       \\
0 &.108   &-.0592\\ 
0 &-.0486 &0\\
\end{bmatrix}
\begin{bmatrix}
u_1 \\ u_2 \\ u_3
\end{bmatrix}
\end{equation*}
Determine whether or not the evaporator is observable from each of
the following combinations of outputs:

\begin{enumerate}[label={(\alph*)}]
\item $x_1$ and $x_4$.
\item  $x_3$ and $x_5$.
\item  $x_3$, $x_4$ and $x_5$.
\end{enumerate}

If the system is not observable for any of the above cases, explain
why not.  Also, find state-space equations for observable and
unobservable states using Kalman decomposition.



\subsection{My Answer}
First, let's put them into \matlab{}.


{\singlespacing
\begin{lstlisting}
%}
%% Problem 2 setup
problem = '2';
disp(['Problem 2...'])
A = [...
     0 -.00156 -.0711 0 0;...
     0 -.1419  .0711  0 0;...
     0 -.00875 -1.102 0 0;...
     0 -.00128 -.1489 0 -.0013;...
     0 .0605   .1489  0 -.0591];

B = [...
     0 -.143  0; ...
     0 0      0;...
     .392  0  0;...
     0 .108   -.0592;...
     0 -.0486 0];

contMat = @(A,B) [B A*B A^2*B A^3*B A^4*B];
obsMat = @(A,C) [C; C*A; C*A^2; C*A^3 C*A^4];
%{
\end{lstlisting}}

\begin{enumerate}[label={(\alph*)}]
\item $x_1$ and $x_4$.         %% part a
\item[]
{\singlespacing
\begin{lstlisting}
%}
%% Part a:
part = 'a';
C = [ 1 0 0 0 0; 0 0 0 1 0];
Obs = obsMat(A,C);


ranks.(part) = double(rank(Obs));
disp(ranks.(part))

%{
\end{lstlisting}}

\begin{matlabc}
%}
fnamebase = ['prob' problem part];
if exist([fnamebase '1.txt'],'file')
  delete([fnamebase '1.txt']);
end
if exist([fnamebase '0.txt'],'file')
  delete([fnamebase '0.txt'])
end
if ranks.(part) == size(A,1)
  fid = fopen([fnamebase '1.txt'],'wt');
else
  fid = fopen([fnamebase '0.txt'],'wt');
end
fprintf(fid,'%d',ranks.(part));
fclose(fid);
%{
\end{matlabc}

The rank of the observability matrix is 
\IfFileExists{./prob2a1.txt}{\input{prob2a1.txt}}{\input{prob2a0.txt}}.
Thus the system is \IfFileExists{./prob2a0.txt}{\emph{not}}{}
observable. 
 
\item  $x_3$ and $x_5$.        %% part b
\item[]
{\singlespacing
\begin{lstlisting}
%}
%% Part b:
part = 'b';
C = [ 0 0 1 0 0; 0 0 0 0 1];
Obs = obsMat(A,C);


ranks.(part) = double(rank(Obs));
disp(ranks.(part))

%{
\end{lstlisting}}

\begin{matlabc}
%}
fnamebase = ['prob' problem part];
if exist([fnamebase '1.txt'],'file')
  delete([fnamebase '1.txt']);
end
if exist([fnamebase '0.txt'],'file')
  delete([fnamebase '0.txt'])
end
if ranks.(part) == size(A,1)
  fid = fopen([fnamebase '1.txt'],'wt');
else
  fid = fopen([fnamebase '0.txt'],'wt');
end
fprintf(fid,'%d',ranks.(part));
fclose(fid);
%{
\end{matlabc}

The rank of the observability matrix is 
\IfFileExists{./prob2b1.txt}{\input{prob2b1.txt}}{\input{prob2b0.txt}}.
Thus the system is \IfFileExists{./prob2b0.txt}{\emph{not}}{}
observable. 


\item  $x_3$, $x_4$ and $x_5$. %% part c
\item[]
{\singlespacing
\begin{lstlisting}
%}
%% Part c:
part = 'c';
C = [ 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1];
Obs = obsMat(A,C);


ranks.(part) = double(rank(Obs));
disp(ranks.(part))

%{
\end{lstlisting}}

\begin{matlabc}
%}
fnamebase = ['prob' problem part];
if exist([fnamebase '1.txt'],'file')
  delete([fnamebase '1.txt']);
end
if exist([fnamebase '0.txt'],'file')
  delete([fnamebase '0.txt'])
end
if ranks.(part) == size(A,1)
  fid = fopen([fnamebase '1.txt'],'wt');
else
  fid = fopen([fnamebase '0.txt'],'wt');
end
fprintf(fid,'%d',ranks.(part));
fclose(fid);
%{
\end{matlabc}

The rank of the observability matrix is 
\IfFileExists{./prob2c1.txt}{\input{prob2c1.txt}}{\input{prob2c0.txt}}.
Thus the system is \IfFileExists{./prob2c0.txt}{\emph{not}}{}
observable. 


\end{enumerate}



\section{}
Check the controllability and observability of
\begin{equation*}
\begin{split}
  \xdot(t) &=
  \begin{bmatrix}
    0 & 1 \\ 0 & t
  \end{bmatrix}x(t) +
  \begin{bmatrix}
    0 \\ 1
  \end{bmatrix}u(t)\\
  y(t) &=
  \begin{bmatrix}
    0 & 1
  \end{bmatrix} x(t).
\end{split}
\end{equation*}

\subsection{My Answer}
First, let's put them into \matlab{}.


{\singlespacing
\begin{lstlisting}
%}
%% Problem 3 setup
problem = '3';
disp(['Problem ' problem '...'])
syms t
A = [ 0 1; 0 t];

B = [ 0; 1];

C = [ 0 1];

contMat = @(A,B) [B A*B];
obsMat = @(A,C) [C; C*A];

Con = contMat(A,B);
Obs = obsMat(A,C);

Crank= double(rank(Con))
Orank= double(rank(Obs))
%{
\end{lstlisting}}



\section{}

Check the controllability and observability of
\begin{equation*}
\begin{split}
  \xdot(t) &=
  \begin{bmatrix}
    0 & 0 \\ 0 & -1
  \end{bmatrix}x(t) +
  \begin{bmatrix}
    0 \\ e^-t
  \end{bmatrix}u(t)\\
  y(t) &=
  \begin{bmatrix}
    0 & e^-t
  \end{bmatrix} x(t).
\end{split}
\end{equation*}



\subsection{My Answer}
First, let's put them into \matlab{}.


{\singlespacing
\begin{lstlisting}
%}
%% Problem 3 setup
problem = '4';
disp(['Problem ' problem '...'])
syms t
A = [ 0 0; 0 -1];

B = [ 0; exp(-t)];

C = [ 0 exp(-t)];

contMat = @(A,B) [B A*B];
obsMat = @(A,C) [C; C*A];

Con = contMat(A,B);
Obs = obsMat(A,C);

Crank= double(rank(Con))
Orank= double(rank(Obs))
%{
\end{lstlisting}}



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
