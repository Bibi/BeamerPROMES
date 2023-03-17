\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Beamer_PROMES}[2023/03/17 Beamer avec mise en page PROMES (par Bibi)]
\LoadClassWithOptions{beamer}
\RequirePackage[T1]{fontenc}
\RequirePackage{tikz}\usetikzlibrary{fadings}
\RequirePackage{xsavebox}
\RequirePackage{textcomp}
\RequirePackage{etoolbox}
\RequirePackage{cmbright}
\RequirePackage{mathtools}

\usefonttheme{professionalfonts}
\DeclareMathAlphabet{\mathsf}{OT1}{cmbr}{m}{n}
\newtranslation[to = French]{Outline}{Sommaire}

\definecolor{darkblue}{rgb}{0.2,0.2,0.7}
\definecolor{darkgreen}{rgb}{0.1,0.5,0.1}

\setbeamertemplate{blocks}[rounded]%[shadow=true]
\setbeamercolor{block title}{bg=darkblue!15}
\setbeamercolor{block body}{bg=darkblue!6}
\setbeamercolor{block title example}{bg=darkgreen!15}
\setbeamercolor{block body example}{bg=darkgreen!6}
\setbeamercolor{block title alerted}{bg=red!15}
\setbeamercolor{block body alerted}{bg=red!6}



% ===========================================================================================================
% Start funky stuff
% ===========================================================================================================

% ======= Custom TOCs =======
% At beginning of parts
\makeatletter
\providecommand\beamer@partintoc[3]{% number, shortname, page
   \ifnum\c@tocdepth=-1\relax
      % requesting onlyparts.
      % \makebox[6em]{PART #1:} #2
      {\color{blue!65!black}#2}%
      \par\vspace*{3mm}
   \fi
}
\define@key{beamertoc}{onlyparts}[]{%
  \c@tocdepth=-1\relax
}
\AtBeginPart{%
   \addtocontents{toc}{\protect\beamer@partintoc{\the\c@part}{\beamer@partnameshort}{\the\c@page}}%
   {\setbeamertemplate{frametitle}{
   \nointerlineskip
   \begin{beamercolorbox}[sep=0.0cm,ht=10mm,wd=\paperwidth]{frametitle}
      \vbox{}\vskip-0ex\strut%
      \hspace*{8mm}\insertframetitle%
      \ifx\insertframesubtitle
         \newline\hspace*{5mm}\small\strut\phantom{Pq}%
      \else
         \newline\hspace*{5mm}\small\strut\insertframesubtitle%
      \fi
   \end{beamercolorbox}
   }
   \setbeamertemplate{footline}{}
   \begin{frame}[noframenumbering]
      \frametitle{\translate{Outline}}
      \begin{center}
         \usebeamerfont{part name}\insertpart
      \end{center}
      \tableofcontents[sectionstyle=show,subsectionstyle=hide,subsubsectionstyle=hide]
   \end{frame}
   }
}

% At beginning of sections
\AtBeginSection[]{
   {
   \setbeamertemplate{frametitle}{
      \nointerlineskip
      \begin{beamercolorbox}[sep=0.0cm,ht=10mm,wd=\paperwidth]{frametitle}
         \vbox{}\vskip-0ex\strut%
         \hspace*{8mm}\insertframetitle%
         \ifx\insertframesubtitle
            \newline\hspace*{5mm}\small\strut\phantom{Pq}%
         \else
            \newline\hspace*{5mm}\small\strut\insertframesubtitle%
         \fi
      \end{beamercolorbox}
      }
   \setbeamertemplate{footline}{}
   \begin{frame}[noframenumbering]% To prevent that frame from messing with the automatic bullets!
      \frametitle{\translate{Outline}}
      \tableofcontents[sectionstyle=show/shaded,subsectionstyle=show/show/hide,subsubsectionstyle=show/show/show/hide]
   \end{frame}
   }
}


% ======= Automatic frametitle, framesubtitle and bullets =======
% First get start and end frames for parts, sections, subsections and subsubsections
% ====== Parts
\newcount\beamer@partstartframe
\beamer@partstartframe=1
\apptocmd{\beamer@part}{\addtocontents{nav}{\protect\headcommand{\protect\beamer@partframes{\the\beamer@partstartframe}{\the\c@framenumber}}}}{}{}
\apptocmd{\beamer@part}{\beamer@partstartframe=\c@framenumber\advance\beamer@partstartframe by1\relax}{}{}
\AtEndDocument{\immediate\write\@auxout{\string\@writefile{nav}{\noexpand\headcommand{\noexpand\beamer@partframes{\the\beamer@partstartframe}{\the\c@framenumber}}}}}{}{}
\def\beamer@startframeofpart{1}
\def\beamer@endframeofpart{1}
\def\beamer@partframes#1#2{%
  \ifnum\c@framenumber<#1%
  \else%
    \ifnum\c@framenumber>#2%
    \else%
      \gdef\beamer@startframeofpart{#1}%
      \gdef\beamer@endframeofpart{#2}%
    \fi%
  \fi%
}
\newcommand\insertpartstartframe{\beamer@startframeofpart}
\newcommand\insertpartendframe{\beamer@endframeofpart}
% \newcounter{partframenumber}
% \newcounter{totalpartframenumber}

% ====== Sections
\newcount\beamer@sectionstartframe
\beamer@sectionstartframe=1
\apptocmd{\beamer@section}{\addtocontents{nav}{\protect\headcommand{\protect\beamer@sectionframes{\the\beamer@sectionstartframe}{\the\c@framenumber}}}}{}{}
\apptocmd{\beamer@section}{\beamer@sectionstartframe=\c@framenumber\advance\beamer@sectionstartframe by1\relax}{}{}
\AtEndDocument{\immediate\write\@auxout{\string\@writefile{nav}{\noexpand\headcommand{\noexpand\beamer@sectionframes{\the\beamer@sectionstartframe}{\the\c@framenumber}}}}}{}{}
\def\beamer@startframeofsection{1}
\def\beamer@endframeofsection{1}
\def\beamer@sectionframes#1#2{%
   \ifnum\c@framenumber<#1%
   \else%
      \ifnum\c@framenumber>#2%
      \else%
         \gdef\beamer@startframeofsection{#1}%
         \gdef\beamer@endframeofsection{#2}%
      \fi%
   \fi%
}
\newcommand\insertsectionstartframe{\beamer@startframeofsection}
\newcommand\insertsectionendframe{\beamer@endframeofsection}
\newcounter{sectionframenumber}
\newcounter{totalsectionframenumber}

% ====== Subsections
\newcount\beamer@subsectionstartframe
\beamer@subsectionstartframe=1
\apptocmd{\beamer@subsection}{\addtocontents{nav}{\protect\headcommand{\protect\beamer@subsectionframes{\the\beamer@subsectionstartframe}{\the\c@framenumber}}}}{}{}
\apptocmd{\beamer@subsection}{\beamer@subsectionstartframe=\c@framenumber\advance\beamer@subsectionstartframe by1\relax}{}{}
\AtEndDocument{\immediate\write\@auxout{\string\@writefile{nav}{\noexpand\headcommand{\noexpand\beamer@subsectionframes{\the\beamer@subsectionstartframe}{\the\c@framenumber}}}}}{}{}
\def\beamer@startframeofsubsection{1}
\def\beamer@endframeofsubsection{1}
\def\beamer@subsectionframes#1#2{%
   \ifnum\c@framenumber<#1%
   \else%
      \ifnum\c@framenumber>#2%
      \else%
         \gdef\beamer@startframeofsubsection{#1}%
         \gdef\beamer@endframeofsubsection{#2}%
      \fi%
   \fi%
}
\newcommand\insertsubsectionstartframe{\beamer@startframeofsubsection}
\newcommand\insertsubsectionendframe{\beamer@endframeofsubsection}
\newcounter{subsectionframenumber}
\newcounter{totalsubsectionframenumber}

% ====== Subsubsections
\newcount\beamer@subsubsectionstartframe
\beamer@subsubsectionstartframe=1
\apptocmd{\beamer@subsubsection}{\addtocontents{nav}{\protect\headcommand{\protect\beamer@subsubsectionframes{\the\beamer@subsubsectionstartframe}{\the\c@framenumber}}}}{}{}
\apptocmd{\beamer@subsubsection}{\beamer@subsubsectionstartframe=\c@framenumber\advance\beamer@subsubsectionstartframe by1\relax}{}{}
\AtEndDocument{\immediate\write\@auxout{\string\@writefile{nav}{\noexpand\headcommand{\noexpand\beamer@subsubsectionframes{\the\beamer@subsubsectionstartframe}{\the\c@framenumber}}}}}{}{}
\def\beamer@startframeofsubsubsection{1}
\def\beamer@endframeofsubsubsection{1}
\def\beamer@subsubsectionframes#1#2{%
   \ifnum\c@framenumber<#1%
   \else%
      \ifnum\c@framenumber>#2%
      \else%
         \gdef\beamer@startframeofsubsubsection{#1}%
         \gdef\beamer@endframeofsubsubsection{#2}%
      \fi%
   \fi%
}
\newcommand\insertsubsubsectionstartframe{\beamer@startframeofsubsubsection}
\newcommand\insertsubsubsectionendframe{\beamer@endframeofsubsubsection}
\newcounter{subsubsectionframenumber}
\newcounter{totalsubsubsectionframenumber}

% ========
% Now edit frametitle
% ========
\setbeamertemplate{frametitle}
{
   \nointerlineskip
   \begin{beamercolorbox}[sep=0.0cm,ht=10mm,wd=\paperwidth]{frametitle}
      \vbox{}\vskip-0ex%
      \strut%
      \hspace*{8mm}\insertsectionhead%
      \ifnum\insertsubsectionendframe>\insertpartendframe% Part end apparently isn't also recognised as subsection end...
         \gdef\beamer@endframeofsubsection{\insertpartendframe}%
      \else
         \ifnum\insertsubsectionendframe>\insertsectionendframe% Section end apparently isn't also recognised as subsection end...
            \gdef\beamer@endframeofsubsection{\insertsectionendframe}%
         \fi%
      \fi%
      \ifnum\insertsectionstartframe=\insertsectionendframe%
      \else%
         \setcounter{sectionframenumber}{1}%
         \addtocounter{sectionframenumber}{\insertframenumber}%
         \addtocounter{sectionframenumber}{-\insertsectionstartframe}%
         \setcounter{totalsectionframenumber}{1}%
         \addtocounter{totalsectionframenumber}{\insertsectionendframe}%
         \addtocounter{totalsectionframenumber}{-\insertsectionstartframe}%
         \ifnum\insertsectionendframe>\insertpartendframe%
            \addtocounter{totalsectionframenumber}{-\insertsectionendframe}%
            \addtocounter{totalsectionframenumber}{\insertpartendframe}%
         \fi%
         % \ifnum\value{section}>0% ==> bullets in sections
         %    \foreach\x in {1,...,\value{totalsectionframenumber}}{%
         %        \ifnum \x<\numexpr\value{sectionframenumber}+1%
         %           \textbullet%
         %        \else%
         %           \textopenbullet%
         %        \fi%
         %    }%
         % \fi%
         % )%
      \fi%
      % \hfill{\scriptsize\insertframenumber/\inserttotalframenumber}\hspace*{0.5cm}%
      \ifnum\thesubsection=0
         \newline\hspace*{8mm}\small\strut\phantom{Pq}%
         \hfill{\scriptsize(\insertframenumber/\inserttotalframenumber)}\hspace*{0.3cm}%
      \else
         \newline\hspace*{8mm}\small\strut\insertsubsectionhead%
         \ifnum\insertsubsectionstartframe=\insertsubsectionendframe%
         \else%
            \setcounter{subsectionframenumber}{1}%
            \addtocounter{subsectionframenumber}{\insertframenumber}%
            \addtocounter{subsectionframenumber}{-\insertsubsectionstartframe}%
            \setcounter{totalsubsectionframenumber}{1}%
            \ifnum\insertsubsectionendframe<\insertsectionendframe
               \addtocounter{totalsubsectionframenumber}{\insertsubsectionendframe}%
            \else%
               \addtocounter{totalsubsectionframenumber}{\insertsectionendframe}%
            \fi%
            \addtocounter{totalsubsectionframenumber}{-\insertsubsectionstartframe}%
            \ifnum\value{totalsubsectionframenumber}=1%
            \else%
               \space(%
               \ifnum\value{section}>0% ==> bullets in subsections
                  \foreach\x in {1,...,\value{totalsubsectionframenumber}}{%
                     \ifnum\x<\numexpr\value{subsectionframenumber}+1%
                        \textbullet%
                     \else%
                        \textopenbullet%
                     \fi%
                  }%
               \fi%
               )%
               \ifx\insertsubsubsectionhead\@empty%
               \else%
                  \space---\space\insertsubsubsectionhead%
               \fi%
            \fi%
         \fi%
         \hfill{\scriptsize(\insertframenumber/\inserttotalframenumber)}\hspace*{0.3cm}%
      \fi%
   \end{beamercolorbox}
}


\CheckCommand*\beamer@checkframetitle{\@ifnextchar\bgroup\beamer@inlineframetitle{}}
\renewcommand*\beamer@checkframetitle{\global\let\beamer@frametitle\relax\@ifnextchar\bgroup\beamer@inlineframetitle{}}

% Patch to reduce space between sections in TOC
\patchcmd{\beamer@sectionintoc}
  {\vskip1.5em}
  {\vskip1em}
  {}
  {}

\makeatother
% ============================================================================================================
% End of funky stuff
% ============================================================================================================

\providecommand{\maketitlepage}[1]
{{% Custom templates for title page
\setbeamertemplate{footline}{}%
\setbeamertemplate{frametitle}{}%
\setbeamertemplate{background}{%
   \begin{tikzpicture}
      \node[inner sep=0pt, anchor=south west] at (0,-0.02) {\includegraphics[width=\paperwidth]{./FigsCLS/Photo_PageDeGarde.jpg}};
      \node[align=right, anchor=north east] at (\paperwidth,\paperheight) {
         \includegraphics[width=1.8cm]{./FigsCLS/logo-promes.jpg}\\[2mm]
         \includegraphics[height=5.5mm]{./FigsCLS/logo-cnrs.pdf}\ \includegraphics[height=5.5mm]{./FigsCLS/logo-upvd.png}%\\[2mm]
         % \includegraphics[width=1.7cm]{./FigsCLS/logo-sfera3_cropped.png}
         };
   \end{tikzpicture}
}
\begin{frame}[noframenumbering]
   \begin{columns}
      \column{\dimexpr\paperwidth-30pt}
         \usebeamerfont{title}\usebeamercolor[fg]{title}\inserttitle\par%
         \usebeamerfont{subtitle}\usebeamercolor[fg]{subtitle}\insertsubtitle\par%
         \bigskip%
         \usebeamerfont{author}\insertauthor\par%
         \bigskip%
         \usebeamerfont{institute}\insertinstitute\par%
         \medskip%
         \usebeamerfont{date}\insertdate\par%
         \vspace{#1}%
         \vfill%
   \end{columns}
\end{frame}
}}% End custom templates for title page

\providecommand{\makeglobaloutline}
{{% Custom templates for global outline
\setbeamersize{text margin left=8mm,text margin right=5mm} 
\setbeamertemplate{footline}{}%
\setbeamertemplate{frametitle}{%
   \nointerlineskip%
   \begin{beamercolorbox}[sep=0.0cm,ht=10mm,wd=\paperwidth]{frametitle}%
      \vbox{}\vskip-0ex\strut%
      \hspace*{8mm}\insertframetitle%
      \ifx\insertframesubtitle
         \newline\hspace*{5mm}\small\strut\phantom{Pq}%
      \else%
         \newline\hspace*{5mm}\small\strut\insertframesubtitle%
      \fi%
   \end{beamercolorbox}%
   }%
\begin{frame}[noframenumbering]
   \frametitle{\translate{Outline}}
   \tableofcontents%[subsubsectionstyle=hide]
\end{frame}
}}% End custom templates for global outline

\providecommand{\makeglobaloutlinewithparts}
{{% Custom templates for global outline
\setbeamertemplate{footline}{}%
\setbeamertemplate{frametitle}{%
   \nointerlineskip%
   \begin{beamercolorbox}[sep=0.0cm,ht=10mm,wd=\paperwidth]{frametitle}%
      \vbox{}\vskip-0ex\strut%
      \hspace*{8mm}\insertframetitle%
      \ifx\insertframesubtitle
         \newline\hspace*{5mm}\small\strut\phantom{Pq}%
      \else%
         \newline\hspace*{5mm}\small\strut\insertframesubtitle%
      \fi%
   \end{beamercolorbox}%
   }%
\begin{frame}[noframenumbering]
   \frametitle{\translate{Outline}}
   \tableofcontents[onlyparts]
\end{frame}
}}% End custom templates for global outline

\setbeamertemplate{navigation symbols}{} % No nav. symbols
\setbeamertemplate{background}{\xusebox{graphics for bg}} % Background image for all slides
\begin{xlrbox}{graphics for bg}
   \begin{tikzpicture}%[opacity=0.2]
      \node[scope fading=east, inner sep=0pt, anchor=south west] at (0,0) {\includegraphics[height=\paperheight]{./FigsCLS/Photo_Bandeau.jpg}};
      \node[below left, anchor=north east] at (\paperwidth,\paperheight) {%
         % \includegraphics[height=0.4cm]{./FigsCLS/logo-sfera3_cropped.png}\hspace{1mm}%
         \includegraphics[height=0.45cm]{./FigsCLS/logo-promes.jpg}\hspace{1mm}%
         \includegraphics[height=0.45cm]{./FigsCLS/logo-cnrs.pdf}\hspace{1mm}%
         \includegraphics[height=0.45cm]{./FigsCLS/logo-upvd.png}%
         };
   \end{tikzpicture}
\end{xlrbox}

\setbeamersize{text margin left=12mm,text margin right=5mm} 

% \setbeamertemplate{footline} % Frame number in footline
% {
%   \hfill%
%   \usebeamercolor[fg]{page number in head/foot}%
%   \usebeamerfont{page number in head/foot}%
%   \insertframenumber\,/\,\inserttotalframenumber\kern1em\vskip2pt%
% }

% Always use letters for footnotes (and reset counter each frame)
\AtBeginEnvironment{frame}{\setcounter{footnote}{0}}
\renewcommand*{\thefootnote}{\alph{footnote}} 


% ======= EOF =======