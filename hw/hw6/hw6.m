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
    &= \frac{k}{MRrl}e
  \end{split}
\end{equation*}
where $k$ is the motor torque constant, $R$ is the motor resistance, 
$r$ is the ratio of motor torque to linear force applied to the cart
($\tau = rf$), and $e$ is the voltage applied to the motor. Let the
state vector and input be defined $x = [x, \dot{x}, \theta,\thetadot]$
 and $u = e$. The parameters for simulation
are
$m = 0.1kg$, $M = 1.0kg$, $l = 1.0m$, $g = 9.8ms^{-2}$, $k = 1V$, $R =
100\Omega$,  
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
  weighting parameter $r^2$ for $0.001 < r^2 < 50$. You can follow the
  Inverted pendulum on cart \matlab example covered in the class
  (follow ``IPonCartLqrPlots.m'' (main executable file) and
  ``InvertedPendulumonCartLQR.m'' in ``Optimal Control.zip''.
\end{enumerate}

To avoid confusion, we will let our state vector be denoted 
$\xbf = \left[\begin{smallmatrix} y &  \theta & \ydot &
    \thetadot \end{smallmatrix}\right]^T$.  Thus, $y$ is our
position. 

\subsubsection{The LQR Controller}
The code to model the inverted pendulum on a cart along with the LQR
controller is given in the file \emph{InvertedPendulumonCartLQR.m}  The
code is listed below.

{\singlespacing
\lstinputlisting{InvertedPendulumonCartLQR.m}
}

\subsubsection{The Driver}
The code below is the driver to run LQR controller for the inverted
pendulum on a cart.

{\singlespacing
\begin{lstlisting}
%}  
%%
param
close all 
N=10;
cols = varycolor(N);
r = sqrt(linspace(0.01,50,N));
[T,X,K,E]=InvertedPendulumonCartLQR(r(1),P);
for i=1:N
    [T,X,K,E]=InvertedPendulumonCartLQR(r(i));
    u=-K*X';
    
    % Plotting it all.
    % Plot the poles....
    figure (1)
    plot(E,'*','color',cols(i,:),'linewidth',2)
    hold on
    
    % Plot \theta
    figure (2)
    plot (T,X(:,1),'color',cols(i,:),'linewidth',2)
    hold on
    
    % Plot \thetadot
    figure (3)
    plot(T,X(:,2),'color',cols(i,:),'linewidth',2)
    hold on
    
    % Plot u
    figure(4) 
    plot (T,u,'color',cols(i,:),'linewidth',2)
    hold on
end
for iter = 1:4
    figure(iter);
    legend(mat2cell([repmat('r^2 = ',N,1) num2str((r.^2)','%02.2f')],ones(N,1)))
    switch iter
        case 1
            title('Poles vs c','fontsize',14)
            xlabel('real','fontsize',12)
            ylabel('Img','fontsize',12)
            grid on
            xlim([-1,5])
            legend(mat2cell([repmat('r^2 = ',N,1) num2str((r.^2)','%02.2f')],ones(N,1)),'location','southwest')
        case 2
            title('theta','fontsize',14)
            grid on
            xlim([0,2.5])
        case 3
            title ('\dot\theta','fontsize',14)
            grid on
            xlim([0,2.5])
        case 4
            title('control input','fontsize',14)
            grid on
            xlim([0,2.5])
    end
end
%%
%{
\end{lstlisting}} % End singlespacing


\begin{matlabc}
%}
print(1,'-depsc2','poles.eps');
print(2,'-depsc2','theta.eps');
print(3,'-depsc2','dot_theta.eps');
print(4,'-depsc2','control.eps');
system('ps2pdf -dEPSCrop poles.eps');
system('ps2pdf -dEPSCrop theta.eps');
system('ps2pdf -dEPSCrop dot_theta.eps');
system('ps2pdf -dEPSCrop control.eps');
%{
\end{matlabc}

The plots can be seen in Figures \ref{fig:1}.
\begin{figure}
    \centering
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{poles}
        \caption{Plot of the poles}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{theta}
        \caption{Plot of $\theta$.}
    \end{subfigure}
\\
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{dot_theta}
        \caption{Plot of $\thetadot$.}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{control}
        \caption{Plot of the control input.}
    \end{subfigure}
\caption{Plots of the outputs with $q_1^2 = \frac{1}{(0.1)^2}$, and $q_3^2=
\frac{1}{(0.017)^2}$.}
\label{fig:1}
\end{figure}


% We can put the above equations into Linear form by
% \providecommand{\vdotbf}{\dot{\vbf}}
% \begin{equation*}
%   \begin{split}
%     \vdotbf &=
%     \underbrace{\begin{bmatrix}
%       0 & 1 & 0 & 0\\
%       0 & -\frac{k^2}{Mr^2Rl} & -\frac{mg}{M} & 0\\
%       0 & 0 & 0 & 1\\
%       0 & \frac{k^2}{Mr^2Rl} & \left(\frac{M+m}{ml}\right)g & 0\\
%     \end{bmatrix}}_A\vbf +\underbrace{
%     \begin{bmatrix}
%       0 \\ \frac{k}{MRr} \\ 0 \\ -\frac{k}{MRrl}
%     \end{bmatrix}}_Bu\\
%   \ybf &= I_4\vbf.
%   \end{split}
% \end{equation*}


% \begin{bmatrix}
%   \xdot \\ \xddot \\ \thetadot \\ \thetaddot
% \end{bmatrix}

\begin{enumerate}[label=(\alph*),start=2]
\item Repeat part (a) for a heavier weighting: $q_1^2 = 10^4$ on the
  cart displacement.
\end{enumerate}

\begin{matlabc}
%}
close all
P.Qmat(1,1) = 10^4;
[T,X,K,E]=InvertedPendulumonCartLQR(r(1),P);
for i=1:N
    [T,X,K,E]=InvertedPendulumonCartLQR(r(i));
    u=-K*X';
    
    % Plotting it all.
    % Plot the poles....
    figure (1)
    plot(E,'*','color',cols(i,:),'linewidth',2)
    hold on
    
    % Plot \theta
    figure (2)
    plot (T,X(:,1),'color',cols(i,:),'linewidth',2)
    hold on
    
    % Plot \thetadot
    figure (3)
    plot(T,X(:,2),'color',cols(i,:),'linewidth',2)
    hold on
    
    % Plot u
    figure(4) 
    plot (T,u,'color',cols(i,:),'linewidth',2)
    hold on
end
for iter = 1:4
    figure(iter);
    legend(mat2cell([repmat('r^2 = ',N,1) num2str((r.^2)','%02.2f')],ones(N,1)))
    switch iter
        case 1
            title('Poles vs c 2','fontsize',14)
            xlabel('real','fontsize',12)
            ylabel('Img','fontsize',12)
            grid on
            xlim([-1,5])
            legend(mat2cell([repmat('r^2 = ',N,1) num2str((r.^2)','%02.2f')],ones(N,1)),'location','southwest')
        case 2
            title('theta 2','fontsize',14)
            grid on
            xlim([0,2.5])
        case 3
            title ('\dot\theta 2','fontsize',14)
            grid on
            xlim([0,2.5])
        case 4
            title('control input 2','fontsize',14)
            grid on
            xlim([0,2.5])
    end
end
%{
\end{matlabc}


\begin{matlabc}
%}
print(1,'-depsc2','poles2.eps');
print(2,'-depsc2','theta2.eps');
print(3,'-depsc2','dot_theta2.eps');
print(4,'-depsc2','control2.eps');
system('ps2pdf -dEPSCrop poles2.eps');
system('ps2pdf -dEPSCrop theta2.eps');
system('ps2pdf -dEPSCrop dot_theta2.eps');
system('ps2pdf -dEPSCrop control2.eps');
%{
\end{matlabc}

The new plots can be seen in Figures \ref{fig:2}.  The plots for the
control input are pretty similar, but a little bit more ringing can be seen
in the plot of $\thetadot$.  Also the convergence of $\theta$ happens
quicker.

\begin{figure}
    \centering
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{poles2}
        \caption{Plot of the poles}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{theta2}
        \caption{Plot of $\theta$.}
    \end{subfigure}
\\
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{dot_theta2}
        \caption{Plot of $\thetadot$.}
    \end{subfigure}
\hfill
    \begin{subfigure}[b]{0.45\textwidth}
        \includegraphics[width=\linewidth]{control2}
        \caption{Plot of the control input.}
    \end{subfigure}
\caption{Plots of the outputs with $q_1^2 = (10)^4$, and $q_3^2=
\frac{1}{(0.017)^2}$.}
\label{fig:2}
\end{figure}

\begin{enumerate}[label=(\alph*),start=3]
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
