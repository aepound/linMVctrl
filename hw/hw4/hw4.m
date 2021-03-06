%{
\documentclass[10pt]{article}
%\input{page}
\usepackage{fullpage}	% Does about the same as the \input{page}...
% ^ part of the preprint package...

\input{symbolmac}
\usepackage{amsmath}
\usepackage{amssymb}  	% provides Rbb, etc.
\usepackage{latexsym}  	% provides \Box
%\usepackage{theorem} \input{proof}
%\pagestyle{empty}
\usepackage{graphicx} 	% for inserting graphics.
%\usepackage{booktabs}	% for fancy tabular environments and stuff
%\usepackage{subfig}	% for subfigures... 
%(This breaks Beamer if the patch isn't applied!!)
%usepackage{hyperref}
\usepackage{enumitem}

%% ******** For code: ******************
\usepackage{listings}
\usepackage[usenames,dvipsnames]{color}
%% ******** Define the language: *******
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
%% ******** Set the style: **************
\lstset{style=matlab}

%\newcommand{\matlab}{{\sc Matlab }} % Or 
\renewcommand{\matlab}{{\sc Matlab }} 


\usepackage{comment}



\newenvironment{matlabc}{}{}
\newenvironment{octavec}{}{}
\excludecomment{matlabc}
%\newenvironment{matlabv}{\verbatim}{\endverbatim}
%\newenvironment{octavev}{\verbatim}{\endverbatim}


% \newcommand{\homedir}{/home/aepound}
% \newcommand{\figdir}{\homedir/figs}  % picture stuff: ps,fig,tex
%\newtheorem{theorem}{Theorem}
%\newtheorem{corollary}{Corollary}
%\newtheorem{lemma}{Lemma}
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
\title{ECE 6320 Homework 4}
\author{Andrew Pound}
\date{\today}



\begin{document}
\maketitle

%\begin{abstract}
%\end{abstract}


\section{}
Find the fundamental and state transition matrix for
\begin{equation}
  \xdot(t) =
  \begin{bmatrix}
   0 & 1 \\ 0 & t
  \end{bmatrix}x(t)
\end{equation}
and 
\begin{equation}
  \xdot(t) =
  \begin{bmatrix}
    -1 & e^{2t} \\ 0 & -1 
  \end{bmatrix}x(t).
\end{equation}

I attempted to do this on paper, but never got it worked out.
I was getting tripped up by the 1st order ODEs (which shouldn't have
been an issue, but were...).

\section{}

An oscillation can be generated by 
\begin{equation}
  \xdot(t) =
  \begin{bmatrix}
    0 & 1 \\ -1 & 0
  \end{bmatrix}x(t)
\end{equation}
Show that its solution is 
\begin{equation}
  x(t) =
  \begin{bmatrix}
    \cos(t)& \sin(t) \\ -\sin(t) & \cos(t)
  \end{bmatrix}x(0).
\end{equation}
Well, let's first calculate what the state $x(t)$ is, assuming it is as
given,
\begin{equation}
  x(t) =
  \begin{bmatrix}
    \cos t & \sin t \\ -\sin t & \cos t
  \end{bmatrix}x(0)
  =
  \begin{bmatrix}
    x_1(0)\cos(t) + x_2(0)\sin(t) \\
    -x_1(0)\sin(t) + x_2(0)\cos(t)
  \end{bmatrix}.
\end{equation}
Ok, now let's figure out what the derivative of this would be
\begin{equation}
  \frac{d}{dt} \left( 
    \begin{bmatrix}
      x_1(0)\cos(t) + x_2(0)\sin(t) \\
      -x_1(0)\sin(t) + x_2(0)\cos(t)
    \end{bmatrix}\right) = 
\begin{bmatrix}
  -x_1(0)\sin(t) + x_2(0)\cos(t) \\
  -x_1(0)\cos(t) - x_2(0)\sin(t)
\end{bmatrix}.
\end{equation}
Now, let's see if the right hand side of the equation works:
\begin{equation}
  \begin{bmatrix}
    0 & 1 \\ -1 & 0
  \end{bmatrix}\begin{bmatrix}
      x_1(0)\cos(t) + x_2(0)\sin(t) \\
      -x_1(0)\sin(t) + x_2(0)\cos(t)
    \end{bmatrix} =
  \begin{bmatrix}
    -x_1(0)\sin(t) + x_2(0)\cos(t)\\
    -\left(x_1(0)\cos(t) + x_2(0)\sin(t)\right)
  \end{bmatrix},
\end{equation}
Which is the same as the derivative above.

\section{}
A communication satellite of mass $m$ orbiting around the earth is shown
in Figure 3. The altitude of the satellite is specified by $r(t)$,
$\theta(t)$, and $\phi(t)$ as shown. The orbit can be controlled by
three orthogonal thrusts; $u_r$, $u_\theta(t)$, and $u_\phi(t)$. If
you remember you have already computed the exact nonlinear equations
in homework 1. You can refresh your memory by looking equation (2.47)
on page 36 in Chen. One solution which corresponds to a circular orbit
is given by 
\begin{equation}
  \begin{split}
    x_0 &=
    \begin{bmatrix}
      r_0 & 0 & \omega_0t & \omega_0 & 0 & 0
    \end{bmatrix}^T\\
    u_0 &=
    \begin{bmatrix}
      0 & 0 & 0
    \end{bmatrix}^T.
  \end{split}
\end{equation}
It's linearized pertubation model at $x_0(t)$ and $u_0(t)$ (given
above) is given as
\begin{equation}
\begin{split}
  \dot{\xbar} &= A\xbar(t)\\
  &=
  \begin{bmatrix}
   0&1&0&0&0&0\\ 
   3\omega_0^2 &0&0&2\omega_0r_0 &0&0\\ 
   0&0&0&1&0&0\\ 
   0&-\frac{2\omega_0}{r_0} &0&0&0&0\\ 
   0&0&0&0&0&1\\ 
   0&0&0&0&-\omega_0^2 &0\\ 
  \end{bmatrix}\xbar(t).
\end{split}
\end{equation}

\begin{enumerate}[label=(\alph*)]
\item Compute the transition matrix ($e^{At}$) for the linearized
  system given above.
\item[]
Using the following \matlab code, we get 
\begin{matlabc}
%}
if exist('p3res.txt','file')
delete('p3res.txt');
end
diary('p3res.txt')
%{
\end{matlabc}
\begin{lstlisting}
%}
syms w r
A = [0      1       0 0      0     0; 
     3*w^2  0       0 2*w*r  0     0;
     0      0       0 1      0     0;
     0      -2*w/r  0 0      0     0;
     0      0       0 0      0     1;
     0      0       0 0      -w^2  0]; 
E_At = expm(A)
%{
\end{lstlisting}
\begin{matlabc}
%}
diary('off')
%{
\end{matlabc}
This gives the following
{\footnotesize \lstinputlisting{p3res.txt}}

\item Use the parameters given in Homework 3 (param.m) to compute
  Jordan's form of $A$.
\item[]
\begin{matlabc}
%}
if exist('p3res2.txt','file')
delete('p3res2.txt');
end
diary('p3res2.txt')
%{
\end{matlabc}
\begin{lstlisting}
%}
% Run the parameter file...
param
w = P.w0;
r = P.r0;
A = [0      1       0 0      0     0; 
     3*w^2  0       0 2*w*r  0     0;
     0      0       0 1      0     0;
     0      -2*w/r  0 0      0     0;
     0      0       0 0      0     1;
     0      0       0 0      -w^2  0]; 
[P,J] = jordan(A)% <==== This errors... with the values from the
                 % param.m file.
%{
\end{lstlisting}
\begin{matlabc}
%}
diary('off')
%{
\end{matlabc}
From this, we get the following output:
{\footnotesize \lstinputlisting{p3res2.txt}}


\item Based on the Jordan's form computed above what can you say about
  $e^{At}$ as $t \rightarrow \infinity$.
\item[]
\item You can use \matlab (show your work step by step) for this work
  but first see if you can solve it yourself.
\item[]
\end{enumerate}

\section{}
Compute $A^t$ and $e^{At}$ for the following matrices
\begin{align}
  A_1 &=
  \begin{bmatrix}
    1 & 1 & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1
  \end{bmatrix}
  & A_2 &=
  \begin{bmatrix}
    1 & 1 & 0 \\ 0 & 0 & 1 \\ 0 & 0 & 1
  \end{bmatrix}
\end{align}

Let's start with $A_1$.
%\begin{equation}
%  A_1 =
%  \begin{bmatrix}
%    1 & 1 & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1
%  \end{bmatrix}.
%\end{equation}
The diagonals of $A_1$ are the eigenvalues, so the multiplicity of
$\lambda_1$ is 3. Also of note is that $A_1$ is already in Jordan
form, so no transformations need to be done ($P = I$).
Thus we have that $J = PAP^{1}$, and we need to find 
\begin{equation}
  \begin{split}
    e^{A_1t} = P^{-1}e^{Jt}P = Pe^{1t}
    \begin{bmatrix}
      1 & 1 & 0 \\ 0 & 1 & 0\\ 0 & 0 & 1
    \end{bmatrix}P
    = Ie^{t}AI
    =
    \begin{bmatrix}
      e^{t} & e^{1} & 0\\
      0 & e^{t} & 0 \\
      0 & 0 & e^{t}
    \end{bmatrix}
  \end{split}
\end{equation}
Now for $A^t$, we will look at the Jordan form and raise it to the
power of $t$,
\begin{equation}
%  \begin{split}
    A_1^t = 
      PJ^tP^{-1}
      = J^t 
      = 
    \begin{bmatrix}
      1^t & t1^{t-1} &0\\
      0 & 1^t & 0\\
      0 & 0 & 1^t
    \end{bmatrix}=
    \begin{bmatrix}
      1 & t & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1
    \end{bmatrix}
%  \end{split}
\end{equation}

Now for $A_2$.  Once again, because $A_2$ is diagonal, we can read off
the eigenvalues of $1, 1$, and $0$.  Thus, we can say that the Jordan
form will be of the form
\begin{equation}
  \hat{J} =
  \begin{bmatrix}
    0 & 0 & 0 \\ 0 & 1 & a \\ 0 & 0 & 1
  \end{bmatrix},
\end{equation}
where $a$ is either 0 or 1. Using \matlab, we can find the Jordan form
easily by 
\begin{matlabc}
%}
if exist('A2.txt','file')
delete('A2.txt')
end
diary('A2.txt')
%{
\end{matlabc}

\begin{lstlisting}
%}
A2 = [1 1 0; 0 0 1; 0 0 1];
[P, J] = jordan(A2)
Pinv = inv(P)
%{
\end{lstlisting}
which yields 
\begin{matlabc}
%}
diary('off')
%{
\end{matlabc}
\lstinputlisting{A2.txt}
Thus, we know that $a=1$.  Now, we need to compute the exponentials of
this Jordan block.
We'll get 
\begin{equation}
\begin{split}
  e^{At} &= P^{-1}e^{Jt}P = P^{-1}e^{t}
  \begin{bmatrix}
    1 & 0 & 0 \\ 
    0 & 1 & t \\
    0 & 0 & 1
  \end{bmatrix}P = e^{t}
 \begin{bmatrix}
    0 & -1 & 1 \\ 1 & 1 & 0 \\ 0 & 0 & 1
  \end{bmatrix}
  \begin{bmatrix}
    1 & 0 & 0 \\ 
    0 & 1 & t \\
    0 & 0 & 1
  \end{bmatrix}
  \begin{bmatrix}
    1 & 1 & -1 \\ -1 & 0 &1 \\ 0 & 0 & 1
  \end{bmatrix}\\
  &= e^{t}
 \begin{bmatrix}
   0& -1& 1-t\\
   0& 1 & t\\
   0& 0 & 1
 \end{bmatrix}
  \begin{bmatrix}
    1 & 1 & -1 \\ -1 & 1 &1 \\ 0 & 0 & 1
  \end{bmatrix}
=e^{t}
\begin{bmatrix}
 1 & -1 & -t \\
 -1& 1 & 1+t \\ 
 0 & 0 & 1
\end{bmatrix}
\end{split}
\end{equation}

Now, let's compute $A^t$.  We get the Jordan block from above
\begin{equation}
  J =  \begin{bmatrix}
    0 & 0 & 0 \\ 0 & 1 & a \\ 0 & 0 & 1
  \end{bmatrix},
\end{equation}
and then using the formula, we get
\begin{equation}
  J^t = 
 \begin{bmatrix}
    0 & 0 & 0 \\ 0 & 1^t & t1^{t-1} \\ 0 & 0 & 1^t
  \end{bmatrix} 
  = \begin{bmatrix}
    0 & 0 & 0 \\ 0 & 1 & t \\ 0 & 0 & 1
  \end{bmatrix}.
\end{equation}
Then we can get $A^t$ by doing the multiplication
\begin{equation}
  A^t = P^{-1}J^tP =
  \begin{bmatrix}
    0 & -1 & 1 \\ 1 & 1 & 0 \\ 0 & 0 & 1
  \end{bmatrix}
  \begin{bmatrix}
    0 & 0 & 0 \\ 0 & 1 & t \\ 0 & 0 & 1
  \end{bmatrix}
  \begin{bmatrix}
    1 & 1 & -1 \\ -1 & 0 &1 \\ 0 & 0 & 1
  \end{bmatrix}
 =
 \begin{bmatrix}
   0& -1& 1-t\\
   0& 1 & t\\
   0& 0 & 1
 \end{bmatrix}
  \begin{bmatrix}
    1 & 1 & -1 \\ -1 & 1 &1 \\ 0 & 0 & 1
  \end{bmatrix}
=
\begin{bmatrix}
 1 & -1 & -t \\
 -1& 1 & 1+t \\ 
 0 & 0 & 1
\end{bmatrix}.
\end{equation}


%{\singlespacing
\begin{matlabc}
%}
A1 = [1 1 0; 0 1 0; 0 0 1]
[p j] = jordan(A1)

A2 = [1 1 0; 0 0 1; 0 0 1]
[p j] = jordan(A2)

%{
\end{matlabc}
%}% end singlespacing




% \bibliographystyle{ieeetr}
% \newcommand{\bibdir}{~}
% \bibliography{\bibdir/~}
\end{document}
%}
