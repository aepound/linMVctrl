%{
\documentclass{article}
\input{commonheader}
\usepackage{comment}


\newenvironment{matlabc}{}{}
\newenvironment{octavec}{}{}
\excludecomment{matlabc}
%\newenvironment{matlabv}{\verbatim}{\endverbatim}
%\newenvironment{octavev}{\verbatim}{\endverbatim}

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
\title{ECE 6320: Homework 1}             
\author{Andrew Pound}
%\date{\input{date.tex}}

\begin{document}
\maketitle

\section{Problem 1}\label{sec:prob1}

% Find a way to set this in a box.
A communication satellite of mass m orbiting around the earth is shown
in Figure \ref{fig:1}. The altitude of the satellite is specified 
by $r(t)$, $\theta(t)$, and $\phi(t)$ as shown. The orbit can be
controlled by three orthogonal thrusts; $ur$ , $u_{\theta}(t)$, 
and $u_{\phi}(t)$. Use Lagrange's equation to derive the satellite's
equations of motion.

% Can I include the figure in any manner?
\begin{figure}[h!]
\centering
{\Large Insert Picture}
\caption{Satellite figure}
\label{fig:1}
\end{figure}


\section{Problem 2}


% Box this too...
Using equations of motion derived in Question \ref{sec:prob1}, 
develop a simulator using SIMULINK (s-function). Verify using 
the simulator that for 
    $x_0 (t) = \begin{bmatrix}r_0 &0 &\omega_0 t & \omega_0 
    & 0 & 0\end{bmatrix}$
 the satellite will move in a circular orbit.
\begin{itemize}
\item Use \emph{SatelliteDummy.zip} folder to access the dummy m-files.
\item Use \emph{param.m} to see various parameters to be used in the simulator.
\item Use \emph{satelliteModel.m} (s-function) for satellite's 
    equations of motion. This function should take input 
$ u = \begin{bmatrix}u_r = 0& u_\theta = 0 & u_\phi = 0\end{bmatrix}^T$
and output will be $\begin{bmatrix} r &\theta &\phi\end{bmatrix}^T$ .
\item Use \emph{polar2cart.m} to convert polar coordinates to cartesian 
coordinates for plotting
\item Use \emph{drawSpacecraft.m} as it is to draw the satellite 
orbiting around
the earth (Please fee free to modify it to make it better looking
satellite).
\item \emph{SatelliteSim.slx} (simulink-model file) to run the simulation
\item Submit all your working files as zip folder on canvas. The name
of the folder should (\emph{satelliteLastnameofStudent.zip}). Example
\emph{satelliteSharma.zip}.
\item Show your working simulation to TA.
\end{itemize}


\section{Problem 3}

% Box here
Find state-space equations to describe the pendulum system in 
Figure \ref{fig:3}. The system is useful to model a two link 
robotic manipulators.
To find the state-space equations consider $\theta_1$ and 
$\theta_2$ very small.

% Figure ?
\begin{figure}[h!]
\centering
{\Large Insert picture}
\caption{Satellite figure}
\label{fig:3}
\end{figure}

\end{document}
%}
