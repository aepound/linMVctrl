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

\subsection{My code modifications}
So in order to test the different trajectories, I modified my code somewhat to
make it easier to work with. I turned the \emph{param.m} file into a function
instead of a script.  It now has three inputs: \emph{QR, tag, traj}.  \emph{QR}
is the information needed to compute the LQR gain matrix $K$. \emph{tag} is a
flag to specify between two different methods of inputting the \emph{QR}
information. And finally, the \emph{traj} specifies the trajectory to use for the
simulation.

The relevant portions of the param file can be seen in the listing below.

{\singlespacing\footnotesize
\lstinputlisting[linerange={1-1,9-15,104-166},stepnumber=2,
caption=Relevant parts of \emph{param.m}]{param.m}
}

In order to get the simulation to work in the first place, I needed to add in the
following to the \emph{TrajControll\_diffFlatness.m} file.  My additions were

{\singlespacing\footnotesize
\lstinputlisting[firstline=40,lastline=61,stepnumber=2,
caption=Relevant parts of
\emph{TrajControlI\_diffFlatness.m}]{TrajControlI_diffFlatness.m} 
}

\subsection{Finding the LQR matrices}
Ok, I think that pretty much summarizes the code to get the thing working
correctly.  Now, I'll detail the methods I wrote to find the best $Q$ and $R$
matrices that I could.  I considered using both a particle filter and/or a
simulated annealing technique, to evolve the matrices in the direction that
minimized the errors, but I didn't want to take the time to debug them.  So I
went with something much more simple and straightforward, and more
brute-force-ish.   I ran each of the trajectories for a certain number of times,
while putting in different values for the $Q$ and $R$ matrices.  

I did make use of Bryson's rule, so that I wouldn't have to worry about
constraining the matrices to be positive definite. (Though I did give it a try
once or twice, but it just became difficult to continue.) I first experimented
with the magnitude of the two matrices and found that if both $Q$ and $R$ all had
the same entries and were scaled identities, then no matter the scaling on the
identities, the gain matrix was essentially the same.  So I started experimenting
with changing the relevant magnitudes of $Q$ and $R$, sticking with both being
scaled identities.  I got slightly better results, but not that much better.
Then I tried to use uniformly random noise coefficients for both $Q$ and $R$.
That once again reduced the error a bit (sometimes: it also sometimes produced
horrible results that wouldn't even converge to the trajectory wanted).

Then I was able to run an experiment that really reduced the error.  I changed it
so that of the 7 elements on the diagonal of $Q$, I had different orders of
magnitudes.  I took this $Q$ vector, and permuted it in a number of different
ways and ran the simulation on these and some permutations produced really good
error.  So I then worked to build the apparatus to test out and find a number of
these ``good'' $Q$ matrices.

What I coded up is shown in the listing below.
{\singlespacing\footnotesize
\lstinputlisting[stepnumber=2,%
caption=Relevant parts of
\emph{scriptingloop.m}]{scriptingloop.m} 
}

\subsection{Best results}
\subsubsection{Trajectory 1}
\begin{matlabc}
%}
%% Trajectory 1
N = 20;
traj = 1;
scriptingloop

print(2,'-depsc2','1path.eps');
print(3,'-depsc2','1angles.eps');
print(4,'-depsc2','1errors.eps');
print(5,'-depsc2','1position.eps');
system('ps2pdf -dEPSCrop 1path.eps');
system('ps2pdf -dEPSCrop 1angles.eps');
system('ps2pdf -dEPSCrop 1errors.eps');
system('ps2pdf -dEPSCrop 1position.eps');
%%
%{
\end{matlabc}

The $Q$ and $R$ matrices that were found to be the best were 
\begin{align*}
  Q &=
  \begin{bmatrix}
    \input{1Q.tex}
  \end{bmatrix}
  & 
  R &= 
  \begin{bmatrix}
    \input{1R.tex}
  \end{bmatrix}
\end{align*}
The best error obtained for this trajectory is shown in the following table.
\begin{table}[h]
  \centering
  \begin{tabular}{cc}
    \toprule
    Max Position Error & Position RMS Error \\
    \midrule
    \input{1errTable}
    \bottomrule
  \end{tabular}
  \caption{Trajectory 1 error results}
  \label{tab:1}
\end{table}
The plots can be seen in Figures \ref{fig:1}.
\begin{figure}
    \centering
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{1path}
        \caption{Plot of the path/trajectory}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{1angles}
        \caption{Plot of angle states}
    \end{subfigure}
\\
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{1errors}
        \caption{Plot of errors in position}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{1position}
        \caption{Plot of the position states}
    \end{subfigure}
\caption{Plots of the outputs for the first trajectory}
\label{fig:1}
\end{figure}




\subsubsection{Trajectory 2}
\begin{matlabc}
%}
%% Trajectory 2
traj = 2;
scriptingloop

print(2,'-depsc2','2path.eps');
print(3,'-depsc2','2angles.eps');
print(4,'-depsc2','2errors.eps');
print(5,'-depsc2','2position.eps');
system('ps2pdf -dEPSCrop 2path.eps');
system('ps2pdf -dEPSCrop 2angles.eps');
system('ps2pdf -dEPSCrop 2errors.eps');
system('ps2pdf -dEPSCrop 2position.eps');
%%
%{
\end{matlabc}

The $Q$ and $R$ matrices that were found to be the best were 
\begin{align*}
  Q &=
  \begin{bmatrix}
    \input{2Q.tex}
  \end{bmatrix}
  & 
  R &= 
  \begin{bmatrix}
    \input{2R.tex}
  \end{bmatrix}
\end{align*}
The best error obtained for this trajectory is shown in the following table.
\begin{table}[h]
  \centering
  \begin{tabular}{cc}
    \toprule
    Max Position Error & Position RMS Error \\
    \midrule
    \input{2errTable}
    \bottomrule
  \end{tabular}
  \caption{Trajectory 2 error results}
  \label{tab:2}
\end{table}
The plots can be seen in Figures \ref{fig:2}.
\begin{figure}
    \centering
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{2path}
        \caption{Plot of the path/trajectory}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{2angles}
        \caption{Plot of angle states}
    \end{subfigure}
\\
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{2errors}
        \caption{Plot of errors in position}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{2position}
        \caption{Plot of the position states}
    \end{subfigure}
\caption{Plots of the outputs for the second trajectory}
\label{fig:2}
\end{figure}


\subsubsection{Trajectory 3}
\begin{matlabc}
%}
%% Trajectory 3
traj = 3;
scriptingloop

print(2,'-depsc2','3path.eps');
print(3,'-depsc2','3angles.eps');
print(4,'-depsc2','3errors.eps');
print(5,'-depsc2','3position.eps');
system('ps2pdf -dEPSCrop 3path.eps');
system('ps2pdf -dEPSCrop 3angles.eps');
system('ps2pdf -dEPSCrop 3errors.eps');
system('ps2pdf -dEPSCrop 3position.eps');
%%
%{
\end{matlabc}

The $Q$ and $R$ matrices that were found to be the best were 
\begin{align*}
  Q &=
  \begin{bmatrix}
    \input{3Q.tex}
  \end{bmatrix}
  & 
  R &= 
  \begin{bmatrix}
    \input{3R.tex}
  \end{bmatrix}
\end{align*}
The best error obtained for this trajectory is shown in the following table.
\begin{table}[h]
  \centering
  \begin{tabular}{cc}
    \toprule
    Max Position Error & Position RMS Error \\
    \midrule
    \input{3errTable}
    \bottomrule
  \end{tabular}
  \caption{Trajectory 3 error results}
  \label{tab:3}
\end{table}
The plots can be seen in Figures \ref{fig:1}.
\begin{figure}
    \centering
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{3path}
        \caption{Plot of the path/trajectory}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{3angles}
        \caption{Plot of angle states}
    \end{subfigure}
\\
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{3errors}
        \caption{Plot of errors in position}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{3position}
        \caption{Plot of the position states}
    \end{subfigure}
\caption{Plots of the outputs for the third trajectory}
\label{fig:3}
\end{figure}

\subsubsection{Trajectory 4}
\begin{matlabc}
%}
%% Trajectory 4
traj = 4;
scriptingloop

print(2,'-depsc2','4path.eps');
print(3,'-depsc2','4angles.eps');
print(4,'-depsc2','4errors.eps');
print(5,'-depsc2','4position.eps');
system('ps2pdf -dEPSCrop 4path.eps');
system('ps2pdf -dEPSCrop 4angles.eps');
system('ps2pdf -dEPSCrop 4errors.eps');
system('ps2pdf -dEPSCrop 4position.eps');

%% 
%{
\end{matlabc}

The $Q$ and $R$ matrices that were found to be the best were 
\begin{align*}
  Q &=
  \begin{bmatrix}
    \input{4Q.tex}
  \end{bmatrix}
  & 
  R &= 
  \begin{bmatrix}
    \input{4R.tex}
  \end{bmatrix}
\end{align*}
The best error obtained for this trajectory is shown in the following table.
\begin{table}[h]
  \centering
  \begin{tabular}{cc}
    \toprule
    Max Position Error & Position RMS Error \\
    \midrule
    \input{4errTable}
    \bottomrule
  \end{tabular}
  \caption{Trajectory 4 error results}
  \label{tab:4}
\end{table}
The plots can be seen in Figures \ref{fig:4}.
\begin{figure}
    \centering
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{4path}
        \caption{Plot of the path/trajectory}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{4angles}
        \caption{Plot of angle states}
    \end{subfigure}
\\
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{4errors}
        \caption{Plot of errors in position}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{4position}
        \caption{Plot of the position states}
    \end{subfigure}
\caption{Plots of the outputs for the fourth trajectory}
\label{fig:4}
\end{figure}

\begin{matlabc}
%}
%% LaTeX the document...
system('pdflatex hw7.m');
system('pdflatex hw7.m');
%% 
%{
\end{matlabc}


\end{document}
%}
