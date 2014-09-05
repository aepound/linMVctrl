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

\subsection{Working the problem}
We will choose the generalized coordinates $q =
\begin{bmatrix}
  r & \phi & \theta
\end{bmatrix}^T$.  Using these coordinates, we know that the velocity
is given by 
\begin{equation}
  v =
  \begin{bmatrix}
    \rdot\\ r\phidot \\ r\cos(\phi)\thetadot
  \end{bmatrix}.
\end{equation}
Utilizing this we can readily calculate the Kinetic energy of the
system as
\begin{equation}
  \begin{split}
    T & = \frac{1}{2}mv^Tv\\
    &= \frac{1}{2}m \left(\rdot^2 + r^2\phidot^2 +
      r^2\cos^2(\phi)\thetadot^2\right).
  \end{split}
\end{equation}
Likewise, the potential energy is easily calculated as
\begin{equation}
  V = -\frac{GMm}{r}.
\end{equation}
Thus, the Lagrangian is given as
\begin{equation}
  \begin{split}
    L &= T - V\\
    & = \frac{1}{2}m \left(\rdot^2 + r^2\phidot^2 +
      r^2\cos^2(\phi)\thetadot^2\right) +\frac{GMm}{r}.
  \end{split}
\end{equation}
Then, to find the equations of motion,
we now need to calculate the derivatives to find the equations of
motion from the equations
\begin{equation}
  \frac{d}{dt}\left(\partiald{L}{\zdot_i}\right) - \partiald{L}{z_i} =
  F \quad \forall \;\; i.
\end{equation}

\paragraph{In the $r$-direction}
\begin{equation}
  \partiald{L}{\rdot} = \frac{2}{2}m\rdot
\end{equation}
\begin{equation}
  \frac{d}{dt}\left(\partiald{L}{\rdot}\right) = m\ddot{r}
\end{equation}
\begin{equation}
  \partiald{L}{r} = mr\phidot^2 + mr\cos^2(\phi)\thetadot^2 - \frac{GMm}{r^2}.
\end{equation}
Thus we get the equation
\begin{equation}
  m\ddot{r} - mr\phidot^2 - mr\cos^2(\phi)\thetadot^2 +
  \frac{GMm}{r^2} = u_r.
\end{equation}
\begin{equation}
  \ddot{r} = r\phidot^2 + r\cos^2(\phi)\thetadot^2 - \frac{GM}{r^2} +
  \frac{u_r}{m}
\end{equation}

\paragraph{In the $\phi$-direction}
\begin{equation}
  \partiald{L}{\phidot} = \frac{2}{2}mr^2\phidot
\end{equation}
\begin{equation}
  \frac{d}{dt}\left(\partiald{L}{\phidot}\right) =
  2mr\rdot\phidot + mr^2\ddot{\phi}
\end{equation}
\begin{equation}
  \partiald{L}{\phi} = -\frac{2}{2}mr^2\cos(\phi)\sin(\phi)\thetadot^2
\end{equation}
Thus, we get the equation
\begin{equation}
  mr^2\ddot{\phi} + 2mr\rdot\phidot +
  mr^2\cos(\phi)\sin(\phi)\thetadot^2 = u_\phi.
\end{equation}
\begin{equation}
    \ddot{\phi}  = 
    - 2\frac{\rdot}{r}\phidot 
    - \cos(\phi)\sin(\phi)\thetadot^2 
    + \frac{u_\phi}{mr^2}
\end{equation}

\paragraph{In the $\theta$-direction}
\begin{equation}
  \partiald{L}{\thetadot} = \frac{2}{2}mr^2\cos^2(\phi)\thetadot
\end{equation}
\begin{equation}
  \frac{d}{dt}\left(\partiald{L}{\thetadot}\right) = 
  2mr\rdot\cos^2(\phi)\thetadot -
  2mr^2\cos(\phi)\sin(\phi)\phidot\thetadot + 
  mr^2\cos^2(\phi)\thetaddot
\end{equation}
\begin{equation}
  \partiald{L}{\theta} = 0
\end{equation}
Thus, we get the equation
\begin{equation}
  mr^2\cos^2(\phi)\thetaddot + 
  2mr\rdot\cos^2(\phi)\thetadot -
  2mr^2\cos(\phi)\sin(\phi)\phidot\thetadot  
  = u_\theta
\end{equation}
\begin{equation}
  \thetaddot = 
  2\sin(\phi)\phidot\thetadot 
  -2\frac{\rdot}{r}\thetadot 
+ \frac{u_\theta}{mr^2\cos^2(\phi)}
\end{equation}

\paragraph{Full equations of motion}
\begin{equation}
  \begin{split}
  \ddot{r} &= r\phidot^2 + r\cos^2(\phi)\thetadot^2 - \frac{GM}{r^2} + 
  \frac{u_r}{m}\\
    \ddot{\phi}  &= 
    - 2\frac{\rdot}{r}\phidot 
    - \cos(\phi)\sin(\phi)\thetadot^2 
    + \frac{u_\phi}{mr^2}\\
  \thetaddot & = 
  2\sin(\phi)\phidot\thetadot 
  -2\frac{\rdot}{r}\thetadot 
+ \frac{u_\theta}{mr^2\cos^2(\phi)}
  \end{split}
\end{equation}

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

\subsection{Solution}
First, let's define the position of mass 1, $m_1$, as $(x_1,y_1)$ 
and we let
\begin{align}
  x_1 &= l_1 \sin(\theta_1) & \xdot_1 &= l_1\cos(\theta_1)\thetadot_1\\
  y_1 &= l_1 \cos(\theta_1) & \ydot_1 &= -l_1\sin(\theta_1)\thetadot_1
\end{align}
And now for mass 2, $m_2$ we obtain
\begin{align}
  x_2 &= l_2 \sin(\theta_2) +  l_1 \sin(\theta_1) & 
  \xdot_1 &= l_2\cos(\theta_2)\thetadot_2 + l_1\cos(\theta_1)\thetadot_1\\
  y_2 &= l_2 \cos(\theta_2) + l_1 \cos(\theta_1) & 
  \ydot_1 &= -l_2\sin(\theta_2)\thetadot_2 - l_1\sin(\theta_1)\thetadot_1
\end{align}
We will need the squared terms of the above velocities, so let's
calculate those:
\begin{equation}
  \begin{split}
    \xdot_1^2 &= l_1^2\cos^2(\theta_1)\thetadot_1^2\\
    \ydot_1^2 &= l_1^2\sin^2(\theta_1)\thetadot_1^2 \\
    \xdot_2^2 &= l_2^2\cos^2(\theta_2)\thetadot_2^2 +
    l_1l_2\cos(\theta_1)\cos(\theta_2)\thetadot_1\thetadot_2 +
    l_1^2\cos^2(\theta_1)\thetadot_1^2 \\
    \ydot_2^2 &= l_2^2\sin^2(\theta_2)\thetadot_2^2 +
    l_1l_2\sin(\theta_1)\sin(\theta_2)\thetadot_1\thetadot_2 +
    l_1^2\sin^2(\theta_1)\thetadot_1^2 
  \end{split}
\end{equation}

\subsubsection{Solving for $T$ and $V$}
Now let's solve for the Kinetic Energy
\begin{equation}
\begin{split}
  T & = \frac{1}{2} m_1\left(\xdot_1^2 + \ydot_1^2\right) +
  \frac{1}{2} m_2\left(\xdot_2^2 + \ydot_2^2\right) \\
  & =  \frac{1}{2} m_1 \left(l_1^2\cos^2(\theta_1)\thetadot_1^2 +
    l_1^2\sin^2(\theta_1)\thetadot_1^2 \right)  \\
  & \quad + \frac{1}{2} m_2 \left(l_1^2\thetadot_1^2 + l_2^2\thetadot_2^2 
    + 2l_1l_2\thetadot_1\thetadot_2
   \underbrace{\left(\cos(\theta_1)\cos(\theta_2) +
       \sin(\theta_1)\sin(\theta_2)\right)}_{ \cos(\theta_1-\theta_2)}
   \right)\\
 &=   \frac{1}{2} m_1 l_1^2\thetadot_1^2 +
   + \frac{1}{2} m_2 \left(l_1^2\thetadot_1^2 + l_2^2\thetadot_2^2 
    + 2l_1l_2\thetadot_1\thetadot_2
     \cos(\theta_1-\theta_2)
   \right)\\
  &=\frac{1}{2}\left(m_1 + m_2\right)l_1^2\thetadot_1^2 +
    \frac{1}{2}m_2l_2^2\thetadot_2^2 +
    m_2l_1l_2\thetadot_1\thetadot_2\cos(\theta_1 - \theta_2).
\end{split}
\end{equation}

Ok, let's solve for the Potential Energy now
\begin{equation}
\begin{split}
  V &= -m_1gy_1 -mgy_2\\
  & = -m_1gl_1\cos(\theta_1) - m_2g\left(l_1\cos(\theta_1) +
    l_2\cos(\theta_2)\right)\\
  &= -(m_1 + m_2)gl_1\cos(\theta_1) - m_2gl_2\cos(\theta_2).
\end{split}
\end{equation}

\subsubsection{The Lagrangian $L$}
Sticking these together, we get the Lagrangian
\begin{equation}
\begin{split}
  L &= T - V\\
  & = \frac{1}{2}\left(m_1 + m_2\right)l_1^2\thetadot_1^2 +
    \frac{1}{2}m_2l_2^2\thetadot_2^2 +
    m_2l_1l_2\thetadot_1\thetadot_2\cos(\theta_1 - \theta_2)
    +(m_1 + m_2)gl_1\cos(\theta_1) + m_2gl_2\cos(\theta_2).
\end{split}
\end{equation}

We now need to calculate the derivatives to find the equations of
motion from the equations
\begin{equation}
  \frac{d}{dt}\left(\partiald{L}{\zdot_i}\right) - \partiald{L}{z_i} =
  F \quad \forall \;\; i.
\end{equation}

\paragraph{First equation of motion}
So for the first, we are looking for the derivative with respect to
$\thetadot_1$.  We get
\begin{equation}
  \partiald{L}{\thetadot_1} = \frac{2}{2} \left(m_1+m_2\right)l_1^2\thetadot_1 +
  m_2l_1 l_2\thetadot_2\cos(\theta_1 - \theta_2)
\end{equation}
Then taking the time derivative, we get
\begin{equation}
  \frac{d}{dt}\left(\partiald{L}{\thetadot_1}\right) =
  \left(m_1 + m_2\right)l_1^2\thetaddot_1 + m_2l_1l_2\left(
    \thetaddot_2\cos(\theta_1 - \theta_2) -
    \thetadot_2(\thetadot_1 - \thetadot_2)\sin(\theta_1 -
    \theta_2) \right).
\end{equation}
 Ok, now we need the derivative with respect to $\theta_1$ to get
 \begin{equation}
   \partiald{L}{\theta_1} =
   m_2l_1l_2\thetadot_1\thetadot_2\sin(\theta_1  -
   \theta_2) - \left(m_1+m_2\right)gl_1\sin(\theta_1).
 \end{equation}

Putting this all together, we get that 
\begin{equation}
  \label{eq:eqmot1}
  (m_1 + m_2)l_1^2\thetaddot_1 + m_2l_1l_2\left(\thetaddot_2\cos(\theta_1 -
  \theta_2) - \thetadot_2^2(\thetadot_1-\thetadot_2)\sin(\theta_1 -
  \theta_2) - \thetadot_1\thetadot_2\sin(\theta_1 - \theta_2)\right) 
  +(m_1 +  m_2)gl_1\sin(\theta_1) = 0
\end{equation}

\paragraph{Second equation of motion}  
We need to take the derivative with respect to $\thetadot_2$. This
gives us the following equation
\begin{equation}
  \partiald{L}{\thetadot_2} = \frac{2}{2}m_2l_2^2\thetadot_2 +
    m_2l_1l_2\thetadot_1\cos(\theta_1 - \theta_2).
\end{equation}
Then we can take the time derivative,
\begin{equation}
  \frac{d}{dt}\left(\partiald{L}{\thetadot_2}\right) = 
  m_2l_2^2\thetaddot_2 + m_2l_1l_2\left(\thetaddot_1\cos(\theta_1 -
    \theta_2) - \thetadot_1\sin(\theta_1 -
    \theta_2)\left(\thetadot_1 - \thetadot_2\right)\right).
\end{equation}
Now we calculate the derivative with respect to $\theta_2$
\begin{equation}
  \partiald{L}{\theta_2} =
  -m_2l_1l_2\thetadot_1\thetadot_2\sin(\theta_1 - \theta_2)
  - m_2gl_2\sin(\theta_2).
\end{equation}

Putting this together, we will obtain the equation
\begin{equation}
  \label{eq:eqmot2}
  m_2l_2^2\thetaddot_2 + m_2l_1l_2\left(\thetaddot_1\cos(\theta_1 -
    \theta_2) - \thetadot_1\sin(\theta_1 -
    \theta_2)\left(\thetadot_1 - \thetadot_2\right)\right) 
  +m_2l_1l_2\thetadot_1\thetadot_2\sin(\theta_1 - \theta_2)
  + m_2gl_2\sin(\theta_2) = u.
\end{equation}

\paragraph{Small Angle Approximations}
Let's us a small angle approximation for both $\theta_1$ and
$\theta_2$. The approximation is
\begin{equation}
  \begin{split}
   \sin(\theta_i) &\approx \theta_i\\
   \cos(\theta_i) &\approx 1\\
   \sin(\theta_1 - \theta_2) &\approx 0\\
   \cos(\theta_1 - \theta_2) &\approx 1.
  \end{split}
\end{equation}
Then we can simplify Equation \ref{eq:eqmot1} to get
\begin{equation}
  (m_1 + m_2)l_1\thetaddot_1 + m_2l_2\thetaddot_2 =
  -\left(m_1+m_2\right)g\theta_1. 
\end{equation}
And for Equation \ref{eq:eqmot2}, we get 
\begin{equation}
   l_2\thetaddot_2 + l_1\thetaddot_1
   = \frac{u}{m_2} -  g\theta_2.
\end{equation}



\paragraph{Matrix Formulation}
Formulating the previous equations into a matrix form, we get
\begin{equation}
  \begin{bmatrix}
    (m_1+m_2)l_1 & m_2l_2 \\
    l_2 & l_1 
  \end{bmatrix}
  \begin{bmatrix}
    \thetaddot_1 \\ \thetaddot_2
  \end{bmatrix} = -g
  \begin{bmatrix}
    (m_1+m_2) & 0 \\ 0 & 1
  \end{bmatrix}
  \begin{bmatrix}
    \theta_1 \\ \theta_2
  \end{bmatrix}
  +
  \begin{bmatrix}
    0 \\ \frac{1}{m_2}
  \end{bmatrix}u.
\end{equation}
Which leads us to 
\begin{equation}
  \begin{bmatrix}
    \thetaddot_1 \\ \thetaddot_2
  \end{bmatrix} = 
  \begin{bmatrix}
    (m_1+m_2)l_1 & m_2l_2 \\
    l_2 & l_1 
  \end{bmatrix}^{-1}
\left( -g \begin{bmatrix}
    (m_1+m_2) & 0 \\ 0 & 1
  \end{bmatrix}
  \begin{bmatrix}
    \theta_1 \\ \theta_2
  \end{bmatrix}
  +
  \begin{bmatrix}
    0 \\ \frac{1}{m_2}
  \end{bmatrix}u\right).
\end{equation}
Let $M = (m_1 + m_2)$ and $D = Ml_1^2 - m_2l_2^2$, then 
\begin{equation}
  \begin{bmatrix}
    Ml_1 & m_2l_2 \\
    l_2 & l_1 
  \end{bmatrix}^{-1} = 
  \frac{1}{D}
  \begin{bmatrix}
    l_1 & -m_2l_2 \\
    -l_2 & Ml_1 
  \end{bmatrix},
\end{equation}
and we get the folowing
\begin{equation}
  \begin{bmatrix}
    \thetaddot_1 \\ \thetaddot_2
  \end{bmatrix} 
  = \frac{-g}{D}
  \begin{bmatrix}
    Ml_1 & -m_2^2l_2 \\ -Ml_2 & Mm_2l_1
  \end{bmatrix} 
  \begin{bmatrix}
    \theta_1 \\ \theta_2
  \end{bmatrix}
  +\frac{1}{D}
  \begin{bmatrix}
    -l_2 \\ \frac{M}{m_2}l_2
  \end{bmatrix}u.
\end{equation}

\begin{comment}

  \begin{equation}
  \frac{-g}{D}
  \begin{bmatrix}
    l_1 &-m_2l_2 \\ -l_2 & Ml_1
  \end{bmatrix}
  \begin{bmatrix}
    M & 0 \\ 0 & m_2
  \end{bmatrix} = 
\frac{-g}{D}
\begin{bmatrix}
  Ml_1 & -m_2^2l_2 \\ -Ml_2 & Mm_2l_1
\end{bmatrix}
\end{equation}
and then also:
\begin{equation}
  \frac{1}{D}
  \begin{bmatrix}
    l_1 & -m_2l_2 \\ -l_2 & M l_1
  \end{bmatrix}
  \begin{bmatrix}
    0 \\ \frac{1}{m_2}
  \end{bmatrix}u
  = \frac{u}{D}
  \begin{bmatrix}
    -l_2 \\ \frac{M}{m_2} l_1
  \end{bmatrix}
\end{equation}
\end{comment}

\paragraph{State Space Representation}
Ok, letting the state be $\xbf =
\begin{bmatrix}
  \theta_1 &\thetadot_1 & \theta_2 & \thetadot_2
\end{bmatrix}^T$, we want something in the form
\begin{equation}
  \begin{split}
  \xbfdot &= A\xbf + B\ubf\\
%\end{equation}
%
%\begin{equation}
%\underbrace{
\begin{bmatrix}
  \thetadot_1 \\\thetaddot_1 \\ \thetadot_2 \\ \thetaddot_2
\end{bmatrix}
% }_{\xbfdot} 
&=
%\underbrace{
\begin{bmatrix}
  0 & 1 & 0 & 0 \\
  -\frac{gMl_1}{D} & 0 & \frac{gm_2^2l_2}{D} & 0\\
  0 & 0 & 0& 1\\
  \frac{gMl_2}{D} & 0 & -\frac{gMm_2l_1}{D}& 0
\end{bmatrix}
% }_{A}
%\underbrace{
\begin{bmatrix}
  \theta_1 \\ \thetadot_1 \\ \theta_2 \\ \thetadot_2
\end{bmatrix}% }_{\xbf}
+
%\underbrace{
\begin{bmatrix}
  0 \\ \frac{-l_2}{D} \\ 0 \\ \frac{Ml_2}{Dm_2}
\end{bmatrix}% }_{B}
u.
\end{split}
\end{equation}
The output equation would be something like
\begin{equation}
  \ybf = 
  \begin{bmatrix}
    \theta_1 \\ \theta_2
  \end{bmatrix} = 
  \begin{bmatrix}
    1 & 0 & 0 & 0\\
    0 & 0 & 1 & 0
  \end{bmatrix}
  \xbf + \zerobf u.
\end{equation}

\paragraph{The solution}
The state space representation is given as
\begin{equation}
  \begin{split}
    \xbfdot & = A\xbf + B\ubf\\
    \ybf &= C\xbf + D\ubf,
  \end{split}
\end{equation}
where the matrices are 
\begin{equation}
  \begin{split}
    \begin{bmatrix}
     \thetadot_1 \\\thetaddot_1 \\ \thetadot_2 \\ \thetaddot_2
    \end{bmatrix}
  & = 
\begin{bmatrix}
  0 & 1 & 0 & 0 \\
  -\frac{gMl_1}{D} & 0 & \frac{gm_2^2l_2}{D} & 0\\
  0 & 0 & 0& 1\\
  \frac{gMl_2}{D} & 0 & -\frac{gMm_2l_1}{D}& 0
\end{bmatrix}
% }_{A}
%\underbrace{
\begin{bmatrix}
  \theta_1 \\ \thetadot_1 \\ \theta_2 \\ \thetadot_2
\end{bmatrix}% }_{\xbf}
+
%\underbrace{
\begin{bmatrix}
  0 \\ \frac{-l_2}{D} \\ 0 \\ \frac{Ml_2}{Dm_2}
\end{bmatrix}% }_{B}
u\\
\begin{bmatrix}
    \theta_1 \\ \theta_2
  \end{bmatrix} &= 
  \begin{bmatrix}
    1 & 0 & 0 & 0\\
    0 & 0 & 1 & 0
  \end{bmatrix}
\begin{bmatrix}
  \theta_1 \\ \thetadot_1 \\ \theta_2 \\ \thetadot_2
\end{bmatrix}% }_{\xbf}
   + \zerobf u.
  \end{split}
\end{equation}




\end{document}
%}
