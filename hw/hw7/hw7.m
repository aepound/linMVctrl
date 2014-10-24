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
\title{ECE 6320: Homework 6}             
\author{Andrew Pound}
%\date{\input{date.tex}}

\begin{document}
\maketitle

\section{Problem 1}\label{sec:prob1}
. Design a LQR controller for a quadrotor to track y traj . The objective
is minimize the tracking error $x - x^r$ meaning find the best $Q$ and $R$
weighting matrices and then showing that the gain matrix $K$ computed
based on $Q$ and $R$ matrices gives you the minimum tracking error.
\begin{equation}
y_{traj} (t) =
\begin{bmatrix}
p^r_n (t)
p^r_e (t)
p^r_d(t)
\psi^r (t)  
\end{bmatrix}
=
\begin{bmatrix}
  a\cos(\omega_2 t)
  b\sin(\omega_1 t)
  n + c\sin(\omega_3 t)
  \psi r (t)
\end{bmatrix}
\end{equation}
where $\omega_1 =\frac{2\pi}{T}$
for the following four scenarios
\begin{enumerate}
\item  $a = 1.5$, $b = 0.75$, $c = 0$, $n = -0.75$, $\omega_2 =
\omega_1/2$, $\omega_3 = \omega_1$ and $T = 5s$.
\item $a = 1.5$, $b = 0.75$, $c = 0.5$, $n = -0.75$, $\omega_2 =
\omega_1/2$, $\omega_3 = \omega_1$ and $T = 10s$.
\item $a = 0.75$, $b = 0.75$, $c = 0$, $n = -0.75$, $\omega_2 =
\omega_1$, $\omega_3 = \omega_1$ and $T = 10s$.
\item  Generate an unique trajectory (what ever you can cook up) and
track it using the LQR controller.
\end{enumerate}
{\singlespacing
\begin{lstlisting}
%}  

param
close all 
N=10;
r = sqrt(linspace(0.0001,50,N));
[T,X,K,E]=InvertedPendulumonCartLQR(r(1),P);

%{
\end{lstlisting}
}


\end{document}
%}
