%% This work is licensed under a Creative Commons
%% Attribution-NonCommercial 4.0 International License.
%% http://creativecommons.org/licenses/by-nc/4.0/
%% 
%% David M. Jones, July 2016

\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{alg}[2016/07/12 v2.13]

%% \gobble@text eats its argument in a safe way; \@bsphack and
%% \@esphack keep a use of the macro from inserting extra horizontal
%% space in certain contexts.

\newcommand{\gobble@text}[1]{%
    \@bsphack\@esphack
}

\newcommand{\version@gobble}{%
    \@ifstar{\gobble@text}{\gobble@text}%
}

\newcommand{\versionA}{%
    \@ifstar{\@versionX{red}}{\@gobble}%
}

\newcommand{\versionB}{%
    \@ifstar{\@versionX{blue}}{\@gobble}%
}

\long\def\@versionX#1#2{\relax#2\relax}
\long\def\@emendcolor#1#2{#2}

\DeclareOption{color}{%
    \long\def\@versionX#1#2{%
        \color{#1}\relax#2\relax\color{black}\relax
    }
    \let\@emendcolor\textcolor
}

\DeclareOption{versionA}{%
    \def\versionA{%
        \@ifstar{\@versionX{red}}{\@versionX{red}}%
    }%
    \let\versionB\version@gobble
}

\DeclareOption{versionB}{%
    \let\versionA\version@gobble
    \def\versionB{%
        \@ifstar{\@versionX{blue}}{\@versionX{blue}}%
    }%
}

\DeclareOption{versions}{%
    \def\versionA{%
        \@ifstar{\@versionX{red}}{\@versionX{red}}%
    }%
    \def\versionB{%
        \@ifstar{\@versionX{blue}}{\@versionX{blue}}%
    }%
}

\DeclareOption{brill}{%
    \AtEndOfPackage{\setmainfont[Numbers=Lining]{Brill}}%
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}

\ExecuteOptions{brill}

\ProcessOptions\relax

\LoadClass[12pt]{book}[2004/02/16]

\RequirePackage{fontspec}

\RequirePackage{amstext}
\RequirePackage{textcmds}
\RequirePackage{xcolor}

\RequirePackage{perpage}
\MakePerPage{footnote}

\RequirePackage[%
    includehead=true,
    paperheight=10in,
    paperwidth=7in,
    lmargin=1in,
    rmargin=1in,
%    textwidth=5in,
    tmargin=.5in,
    bmargin=0.75in
]{geometry}

\RequirePackage{multicol}
\multicolsep = \smallskipamount

\RequirePackage{array}
\RequirePackage{longtable}

\setlength{\LTpre}{\smallskipamount}
\setlength{\LTpost}{\smallskipamount}

\newcommand{\negbigskip}{\vskip-\bigskipamount}
\newcommand{\negmedskip}{\vskip-\medskipamount}
\newcommand{\negsmallskip}{\vskip-\smallskipamount}

\newdimen\normalparindent

\AtBeginDocument{\normalparindent\parindent}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                              LOGOS                               %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tweak logos for Brill.

\def\TeX{T\kern-.125em\lower.40ex\hbox{E}\kern-.075emX\@}

\DeclareRobustCommand{\LaTeX}{L\kern-.25em%
        {\sbox\z@ T%
         \vbox to\ht\z@{\hbox{\check@mathfonts
                              \fontsize{9}\z@
                              \math@fontsfalse\selectfont
                              A}%
                        \vss}%
        }%
        \kern-.125em%
        \TeX}

\def\XeTeX{X\lower0.4ex\hbox{\kern-0.08em\reflectbox{E}}\kern-0.125em\TeX}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                           EMENDATIONS                            %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \emend{LABEL}{OLD}{NEW}

\newcommand{\@emendlabel}[1]{%
    \@bsphack
    \protected@write\@auxout{}%
         {\string\newlabel{emend.#1}{{\the\c@section}{\thepage}}}%
    \@esphack
}

\newcommand{\eref}[2][]{%
    \@ifundefined{r@emend.#2}{%
        \protect\G@refundefinedtrue
        \nfss@text{\reset@font\bfseries ??}%
        \@latex@warning{Emendation `#2' on page \thepage \space undefined}%
    }{%
        \begingroup
            \let\emph\relax
            \edef\@tempa{\noexpand\set@eref\@nameuse{r@emend.#2}{#1}}%
        \expandafter\endgroup
        \@tempa
    }%
}

\newcommand{\set@eref}[3]{%
    \xref[#3]{#1}%
}

\newcommand{\erefpage}[1]{%
    \@ifundefined{r@emend.#1}{%
        \protect\G@refundefinedtrue
        \nfss@text{\reset@font\bfseries ??}%
        \@latex@warning{Emendation `#1' on page \thepage \space undefined}%
    }{%
        \Hy@safe@activestrue
        \begingroup
            \edef\@tempa{\@nameuse{r@emend.#1}}%
            \edef\@tempa{%
                p.~\noexpand\Hy@setref@link\csname r@emend.#1\endcsname{}{page.\expandafter\@secondoftwo\@tempa}{}\noexpand\@nil\noexpand\@secondoffive
            }%
        \expandafter\endgroup
        \@tempa
        \Hy@safe@activesfalse
    }%
}

\newcommand{\pagelink}[1]{%
    \Hy@safe@activestrue
    \Hy@setref@link{}{#1}{}{page.#1}{}\@nil\@secondoffive
    \Hy@safe@activesfalse
}

\DeclareRobustCommand{\emend}[3]{%
    \@emendcolor{green}{\@emendlabel{#1}#3}%
}

\def\gobble@erefnum\ignorespaces#1.{}%
\def\show@erefnum\ignorespaces#1.{\relax\ifnum#1>0 #1.\enskip\fi}%

\newenvironment{emendations}{%
    \small
    \frenchspacing
    \let\@erefnum\show@erefnum
    \let\@erefnum\gobble@erefnum
    \setlength{\LTleft}{\z@}%
    \Longtable{@{}>{\@erefnum}l@{}lll@{}}%
}{%
    \endLongtable
}

\renewcommand*\descriptionlabel[1]{\normalfont #1.}%

\newenvironment{variations}{%
    \description
}{%
    \enddescription
}

\newcommand{\logical}[1]{}
\newcommand{\visual}[1]{#1}

\def\partial@frameb@x#1{%
    \@tempdima\fboxrule
    \advance\@tempdima\fboxsep
    \advance\@tempdima\dp\@tempboxa
    \hbox{%
        \lower\@tempdima\hbox{%
            \vbox{%
                \hrule\@height\fboxrule
                \hbox{%
                    \vrule\@width\fboxrule
                    #1%
                    \vbox{%
                        \vskip\fboxsep
                        \box\@tempboxa
                    }%
                    #1%
                    \vrule\@width\fboxrule
                }%
            }%
        }%
    }%
}

\def\boxedX{%
    \begingroup
        \fboxsep1pt
        \let\@frameb@x\partial@frameb@x
        \fbox{\textsc{x}}%
    \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\hyphenbreak}{-\break}

\DeclareTextFontCommand{\textsc}{\normalfont\scshape}

\DeclareTextFontCommand{\textbfsc}{\normalfont\scshape\bfseries}

\let\english\emph
\let\german\emph
\let\french\emph
\let\italian\emph

\DeclareRobustCommand{\latin}{%
    \@ifstar\@empty\@latin
}

\newcommand{\@latin}[1]{%
    \textbf{\upshape#1}%
}

\let\vrb\latin

\def\suffix{\@ifstar\s@suffix\@suffix}

\newcommand\s@suffix[1]{\leavevmode\hbox{\english{#1}}\@}
\newcommand\@suffix[1]{\leavevmode\hbox{\latin{#1}}\@}

\let\prefix\suffix
\let\infix\suffix

\let\stem\suffix
\let\enclitic\suffix
\let\particle\suffix

\let\gender\textsc

\newcommand{\ellipsis}{\dots\allowbreak}

\newcommand{\remember}[2]{%
    \begingroup
        \setbox\z@\hbox{#2}%
        \xdef#1##1{\leavevmode\hbox to\the\wd\z@{##1\hfill}}%
    \endgroup
    \ignorespaces
}

\newcommand{\pushright}[2]{%
    \begingroup
        \setbox\z@\hbox{#2}%
        \xdef#1##1{\leavevmode\hbox to\the\wd\z@{\hfill##1}}%
    \endgroup
    \ignorespaces
}

\newcommand{\group}[2][c]{%
    $\begin{tabular}[#1]{@{}l@{}}#2\end{tabular}$%
}

\newcommand{\groupLR}[2][c]{%
    $\left\{ \begin{tabular}[#1]{@{}l@{}}#2\end{tabular} \right\}$%
}

\newcommand{\groupL}{%
    \@ifstar\@groupLc\@groupL
}

\newcommand{\@groupL}[2][c]{%
    $\left\{ \begin{tabular}[#1]{@{}l@{}}#2\end{tabular} \right.$%
}

\newcommand{\@groupLc}[2][c]{%
    $\left\{ \begin{tabular}[#1]{@{}c@{}}#2\end{tabular} \right.$%
}

\newcommand{\groupR}[2][c]{%
    $\left. \begin{tabular}[#1]{@{}l@{}}#2\end{tabular} \right\}$%
}

\newcounter{savedfootnote}

\newcommand{\savefootnote}{\global\c@savedfootnote\c@footnote}

\newcommand{\savedfootnote}{\protect\footnotemark[\the\c@savedfootnote]}

\newcounter{savedcounter}

\newcommand{\savecounter}[1]{\global\c@savedcounter\csname c@#1\endcsname}

\newcommand{\restorecounter}[1]{%
    \csname c@#1\endcsname\c@savedcounter
}

\newcommand\abbrev[1]{\latin{#1\@}}

\def\#{\ensuremath{\sharp}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                        CITATIONS (\APUD)                         %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\let\apud@prev\@empty
\let\apud@current\@empty

\def\apud#1#2{%
    \gdef\apud@current{#1}%
    \begingroup
        \ifx\apud@current\@empty\else
            \global\let\apud@prev\apud@current
            \apud@index{#2}%
            #1%
        \fi
        \apud@href{#2}{\@apud#2,\@nil}%
    \endgroup
}

\def\@apud#1,#2\@nil{%
    \if###1##\else
        \ifx\apud@current\@empty\else
            \ 
        \fi
    \fi
    #1%
    \@for\@apudnumber:=#2\do{%
        \ifx\@apudnumber\@empty\else
            , \ignorespaces\@apudnumber
        \fi
    }%
}

\def\apud@href#1#2{%
    \begingroup
        \begingroup
            \let~\@empty
            \let\ \@empty
            \let\hbox\@firstofone
            \let\emph\@firstofone
            \let\emend\@thirdofthree
            \let\linebreak\@empty
            \edef\@tempa{%
                \edef\noexpand\apud@major{%
                    \noexpand\zap@space\apud@prev\space\noexpand\@empty
                }%
                \edef\noexpand\apud@minor{%
                    \noexpand\zap@space#1\space\noexpand\@empty
                }%
            }%
        \expandafter\endgroup
        \@tempa
        \@ifundefined{latin@href@\apud@major}{%
            \@latex@warning{\string\apud{\apud@major} on page \thepage \space
             undefined}%
            #2%
        }{%
            \csname latin@href@\apud@major\endcsname{#2}%
        }%
    \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                          URL MANAGEMENT                          %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\setURL}[2]{%
    \begingroup
        \xdef\@tempa{%
            \noexpand\@newl@bel{url}{%
                \zap@space#1 \@empty:\zap@space#2 \@empty
            }%
        }%
    \expandafter\endgroup
    \@tempa
}

\newcommand{\setURLSuffix}[2]{%
    \begingroup
        \edef\@tempa{%
            \noexpand\@newl@bel{suffix}{%
                \zap@space#1 \@empty:\zap@space#2 \@empty
            }%
        }%
    \expandafter\endgroup
    \@tempa
}

\newcommand{\setURLHandler}[2]{%
    \begingroup
        \edef\@tempa{\noexpand\@newl@bel u{\zap@space#1 \@empty}{#2}}%
    \expandafter\endgroup
    \@tempa
    \relax\expandafter\def\csname latin@href@\zap@space#1 \@empty\endcsname
}

\def\plain@href#1{%
    \@ifundefined{u@\apud@major}{%
        #1%
    }{%
        \edef\apud@url{\csname u@\apud@major\endcsname}%
        \href{\apud@url}{#1}%
    }%
}

\def\perseus@href#1#2{%
    \@ifundefined{url@\apud@major:\apud@minor}{%
        \@ifundefined{u@\apud@major}{%
            #2%
        }{%
            \edef\apud@url{\csname u@\apud@major\endcsname}%
            \ifx\apud@url\@empty
                #2%
            \else
                \@ifundefined{suffix@\apud@major:\apud@minor}{%
                    \edef\@tempa{\noexpand#1{\apud@minor}}%
                }{%
                    \edef\@tempa{\csname suffix@\apud@major:\apud@minor\endcsname}%
                }%
                \ifx\@tempa\@empty
                    #2%
                \else
                    \edef\@tempa{\noexpand\perseus[\@tempa]}%
                    \@tempa{\apud@url}{#2}%
                \fi
            \fi
        }%
    }{%
        \edef\apud@url{\csname url@\apud@major:\apud@minor\endcsname}%
        \ifx\apud@url\@empty
            #2%
        \else
            \href{\apud@url}{#2}%
        \fi
    }%
}

\def\perseus@href@a{%
    \perseus@href\@firstofone
}

% 1, 2, 3 => 1.3

\def\perseus@href@b{%
    \perseus@href\perseus@b
}

\def\perseus@b#1{%
    \perseus@parse@b#1,,,\@nil
}

\def\perseus@parse@b#1,#2,#3,#4\@nil{%
    #1\if###3##\else.#3\fi
}

% 1, 2, 3 => 2

\def\perseus@href@c{%
    \perseus@href\perseus@c
}

\def\perseus@c#1{%
    \perseus@parse@c#1,,,\@nil
}

\def\perseus@parse@c#1,#2,#3,#4\@nil{#2}

% 1, 2, 3 => 1

\def\perseus@href@d{%
    \perseus@href\perseus@d
}

\def\perseus@d#1{%
    \perseus@parse@d#1,,,\@nil
}

\def\perseus@parse@d#1,#2,#3,#4\@nil{#1}

% S. 1, 2 => 1

\def\perseus@href@dom{%
    \perseus@href\perseus@dom
}

\def\perseus@dom#1{%
    \perseus@parse@dom#1,,,\@nil
}

\def\perseus@parse@dom S.#1,#2,#3\@nil{#1.#2}

% 1, 2, 3 => 1.2

\def\perseus@href@e{%
    \perseus@href\perseus@e
}

\def\perseus@e#1{%
    \perseus@parse@e#1,,,\@nil
}

\def\perseus@parse@e#1,#2,#3,#4\@nil{%
    #1\if###2##\else.#2\fi
}

% 1, 2, 3, 4 => 1.2.3

\def\perseus@href@f{%
    \perseus@href\perseus@f
}

\def\perseus@f#1{%
    \perseus@parse@f#1,,,\@nil
}

\def\perseus@parse@f#1,#2,#3,#4\@nil{%
    #1.#2\if###4##\else.#4\fi
}

% 1, 2, 3, 4 => 1.2.3

\def\perseus@href@quint{%
    \perseus@href\perseus@quint
}

\def\perseus@href@quint#1{%
    \@ifundefined{u@\apud@major}{%
        #1%
    }{%
        \edef\@tempa{%
            \edef\noexpand\apud@url{%
                \csname u@\apud@major\endcsname
                \noexpand\perseus@d{\apud@minor}%
            }%
        }%
        \@tempa
        \edef\@tempa{\noexpand\perseus@quint{\apud@minor}}%
        \edef\@tempa{\noexpand\perseus[\@tempa]}%
        \@tempa{\apud@url}{#1}%
    }%
}

\def\perseus@quint#1{%
    \perseus@parse@quint#1,,,\@nil
}

\def\perseus@parse@quint#1,#2,#3,#4\@nil{%
    #2\if###3##\else.#3\fi
}

% 1, 2, 3 => 1.2

\def\perseus@href@verr{%
    \perseus@href\perseus@verr
}

\def\perseus@verr#1{%
    \perseus@parse@verr#1,,,\@nil
}

\def\perseus@parse@verr#1,#2,#3,#4\@nil{%
    2.#1.#3%
}

\def\perseus@href@livy#1{%
    \edef\@tempa{%
        \edef\noexpand\apud@url{%
            \csname u@\apud@major\endcsname
            \expandafter\parse@livy \apud@minor,,, \@nil
        }%
    }%
    \@tempa
    \href{\apud@url}{#1}%
}

\edef\parse@livy #1,#2,#3\@nil{#1.shtml\string##2}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                             INDEXES                              %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{algindex}{%
    \begin{multicols}{2}
    \thispagestyle{dropfolio}%
    \raggedright
    \leftskip 1em
    \parindent-\leftskip
    \frenchspacing
}{%
    \end{multicols}
}

\let\apud@index\gobble@text

% \RequirePackage{makeidx}
% \makeindex
% 
% \def\apud@index#1{%
%     \@bsphack
%     \begingroup
%         \let\linebreak\@empty
%         \let~\space
%         \let\ \space
%         \let\@tempa\@empty
%         \@for\@apudnumber:=#1\do{%
%             \ifx\@apudnumber\@empty\else
%                 \protected@edef\@tempa{%
%                     \ifx\@tempa\@empty\else\@tempa, \fi
%                     \@apudnumber
%                 }%
%             \fi
%         }%
%         %\index{\apud@prev!\@tempa}%
%         \protected@write\@indexfile{}%
%             {\string\indexentry{\apud@prev!\@tempa|xref}{\@arabic\c@section}}%
%     \endgroup
%     \@esphack
% }

\newcommand{\indexauthor}[1]{%
    \markthird{#1}%
    \item \textsc{#1}%
}

\newenvironment{autindex}{%
    \begin{multicols*}{2}
    \thispagestyle{dropfolio}%
    \parindent\z@
    \parskip\z@ \@plus .3\p@\relax
    \columnseprule \z@
    \columnsep 35\p@
    \frenchspacing
    \raggedright
    \let\item\@idxitem
}{%
    \end{multicols*}
}

\renewcommand\@idxitem{\par\hangindent 2em}
\renewcommand\subitem{\par\hangindent 2em \quad}
\renewcommand\subsubitem{\par\hangindent 3em \qquad}

\newwrite\@perseus@urls

\immediate\openout\@perseus@urls=alatingrammar.html

% \def\write@perseus@url#1{%
%     \begingroup
%         \let~\@empty
%         \let\ \@empty
%         \let\hbox\@firstofone
%         \let\emph\@firstofone
%         \let\emend\@thirdofthree
%         \let\linebreak\@empty
%         \immediate\write\@perseus@urls{#1}%
%     \endgroup
% }

\def\perseus@citeurl{http://data.perseus.org/citations/urn:cts:latinLit}
\def\perseus@texturl{http://data.perseus.org/texts/urn:cts:latinLit}

\newcommand{\perseus}[2][]{%
    \begingroup
        \if###1##
            \def\@tempa{\perseus@texturl:#2.perseus-lat1}%
        \else
            \def\@tempa{\perseus@citeurl:#2.perseus-lat1:#1}%
        \fi
        \HyPsd@StringSubst{,}{.}\@tempa
        % \ifx\apud@major\undefined\else
        %     \write@perseus@url{<a target="_blank" href="\@tempa">\apud@major\space\apud@minor</a></p>^^J}%
        % \fi
        \edef\@tempa{\noexpand\href{\@tempa}}%
    \expandafter\endgroup
    \@tempa
}

\def\@biblabel#1{#1\enskip}

\newenvironment{abbreviations}{%
    \list{}{%
        \leftmargin\labelwidth
        \advance\leftmargin\labelsep
        \itemsep\z@
        \parsep\z@
    }%
    \sloppy
    \frenchspacing
    \clubpenalty4000
    \@clubpenalty \clubpenalty
    \widowpenalty4000%
}{%
    \def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
    \endlist
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                        THE \XREF COMMAND                         %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\xref@ff{ff.}
\def\xref@and{and}
\def\xref@ibid{\textnormal{\textit{ib.}}}

\def\xref@comma{, }

\def\xref@initcomma#1 #2\@nil{%
    \def\@tempa{#1}%
    \ifx\@tempa\xref@and
        \def\xref@comma{ }%
    \else
        \ifnum\@tempcnta = 1
            \def\xref@comma{,~}%
        \fi
    \fi
}

\let\xref@target\@empty
\let\xref@prev\@empty

\providecommand{\@firstoffive}[5]{#1}

\newcommand{\hyper@xref}[1]{%
    \Hy@setref@link{\textbf{\liningnumerals#1}}{#1}{\relax}{section.#1}{}\@empty\@empty\@nil\@firstoffive
}

\newcommand{\xref}[2][]{%
    \begingroup
        \ifx\xref@ibid#2%
            \let\xref@target\xref@prev
            \textbf{\liningnumerals#2}%
        \else
            \def\xref@target{#2}%
            \hyper@xref{#2}%
        \fi
        \@tempcnta\z@
        \@for\@subref:=#1\do{%
            \ifx\@subref\@empty\else
                \advance\@tempcnta\@ne
            \fi
        }%
        \xref@initcomma#1 \@nil
        \@for\@subref:=#1\do{%
            \ifx\@subref\@empty\else
                \ifx\@subref\xref@ff\space\else\xref@comma\fi
                \ignorespaces\@subref
                \def\xref@comma{, }%
            \fi
        }%
        \global\let\xref@prev\xref@target
    \endgroup
}

\newcommand{\ibid}[1][]{%
    \xref[#1]{\xref@ibid}%
}

\DeclareRobustCommand{\sftn}[1]{%
    ftn.%
    \if###1##\else
        ~\ref{ftn:s\xref@target:#1}%
    \fi
}

\newcommand{\ftn}{%
    \@ifstar{\@ftn{footnote}}{\@ftn{ftn.}}%
}

\newcommand{\@ftn}[3]{%
    \if###2##\else
        p.~\pageref{ftn:#2:#3}%
    \fi
    \if###3##\else
        , #1~\ref{ftn:#2:#3}%
    \fi
}

\def\({\textup(}
\def\){\textup)}

\newcommand{\bc}{\textsc{b.c.}}
\newcommand{\ad}{\@ifstar{\textsc{a.d\@.}}{\textsc{a.d.}}}

\newcommand{\ditto}[1][]{%
    \if###1##
        “%
    \else
        \begingroup
            \setbox\z@\hbox{#1}%
            \hb@xt@\wd\z@{\hss“\hss}%
        \endgroup
    \fi
}

\let\term\textbf

\def\ending#1{\leavevmode\hbox{\textbf{#1}}}

\newcommand{\na}[1][2em]{%
    \leavevmode
    \vbox{\hrule height 3pt depth -2.5pt width #1}\,%
}

\newcommand{\blank}[1][2em]{%
    \leavevmode
    \vbox{\hrule height 3pt depth -2.5pt width #1}%
}

\let\grapheme\textbf
\newcommand\phone[1]{\textnormal{\textbf{#1}}}

\newcommand\diphthong[2][i]{#2\kern.1em\tsup{#1}}

\let\sound\emph

\newcommand{\tup}{\textnormal}

\renewcommand{\root}[1]{\textbf{#1}}

\newcommand{\rec}{\@ifstar\s@rec\@rec}

\newcommand{\s@rec}[1]{\hbox{\emph{*#1}}}
\newcommand{\@rec}[1]{\hbox{\textbf{*#1}}}

% \REC is like \rec, but it allows hyphenation.
\newcommand{\REC}[1]{\textbf{*\nobreak#1}}

\newcommand{\incorrect}{\rec}

\def\clap#1{\hb@xt@\z@{\hss#1\hss}}

\def\cleardoublepage{%
    \clearpage
    \ifodd\c@page \else
        \thispagestyle{empty}%
        \hbox{}\newpage
    \fi
}

\newenvironment{verbcat}{%
    \begin{multicols}{2}
    \raggedright
    \leftskip 1em
    \parindent-\leftskip
}{%
    \end{multicols}
}

\def\syn@paren#1{%
    \if###1##\else
        \space(#1)%
    \fi
}

\def\l@synA#1#2{#1.\>\textbf{#2}\\}%
\def\l@synB#1#2{\>#2\syn@paren{#1}\\}%
\def\l@synC#1#2{\>\>#2\syn@paren{#1}\\}%
\def\l@synD#1#2{\>\>\>#2\syn@paren{#1}\\}%
\def\l@synE#1#2{\>\>\>\>#2\syn@paren{#1}\\}%

\newenvironment{synopsis}[1][III]{%
    \small
    \let\a\l@synA
    \let\b\l@synB
    \let\c\l@synC
    \let\d\l@synD
    \let\e\l@synE
    \tabbing
    #1.\enskip\=\qquad\=\quad\=\quad\=\quad\=\kill
}{%
    \endtabbing
}

\newenvironment{subjunctivesynopsis}{%
    \newcommand{\@parstyle}{%
        \parindent-.75\normalparindent
        \leftskip.75\normalparindent
        \rightskip = 0pt plus 1fil\relax
        \footnotesize
        \indent
    }
    \begin{Longtable}{@{}>{\@parstyle}p{.425\textwidth}%
                       @{\hskip0.5em}
                       |
                       @{\hskip0.5em}
                       >{\@parstyle}p{.425\textwidth}@{}}
}{%
    \end{Longtable}
}

\newenvironment{indicativesynopsis}{%
    \newcommand{\@parstyle}{%
        \parindent-.75\normalparindent
        \leftskip.75\normalparindent
        \rightskip = 0pt plus 1fil\relax
        \footnotesize
        \indent
    }
    \begin{Longtable}{@{}>{\@parstyle}p{.25\textwidth}%
                       @{\hskip0.5em}
                       |
                       @{\hskip0.5em}
                       >{\@parstyle}p{.7\textwidth}@{}}
}{%
    \end{Longtable}
}

\newenvironment{distributives}{%
    \par
    \newcommand{\@parstyle}{%
        \parindent-.75\normalparindent
        \leftskip.75\normalparindent
        \rightskip = 0pt plus 1fil\relax
        \footnotesize
        \indent
    }%
    \def\note##1{%
    \multicolumn{3}{>{\@parstyle}p{.95\textwidth}}{\textsc{Note}.\enskip##1}%
    }%
    \Longtable[l]{@{}r@{\enskip}
                       >{\@parstyle}p{.3\textwidth}%
                       >{\@parstyle}p{.2\textwidth}%
                       >{\@parstyle}p{.35\textwidth}@{}}%
}{%
    \endLongtable
}

\newenvironment{correlatives}{%
    \par
    \footnotesize
    \longtable[l]{@{}llll@{}}
}{%
    \endlongtable
}

\newenvironment{phonology}{%
    \par
    \smallskip
    \tabcolsep.25em
    \noindent
    \begin{Tabular*}{@{}
                     lcl
                     @{\extracolsep{\fill}}
                     l@{\extracolsep{2\tabcolsep}}c@{\extracolsep{2\tabcolsep}}l
                     @{}}
}{%
    \end{Tabular*}
}

\newenvironment{abbrevs}{%
    \par
    \advance\leftskip4em
    \parindent-1.5em
    \frenchspacing
}{%
    \par
}

\newenvironment{cpds}{%
    \advance\leftskip2em
}{%
}

\newenvironment{hiddenquantity}{%
    \begin{multicols}{4}
    \footnotesize
    \raggedright
    \leftskip 1em
    \parindent-\leftskip
}{%
    \end{multicols}
}

\newcount\indented@level
\indented@level\z@

\newenvironment{indented}[1][-1]{%
    \par
    \smallskip
    \ifnum#1 > -1
        \indented@level#1%
    \else
        \advance\indented@level\@ne
    \fi
    \@tempdima.5\normalparindent
    \multiply\@tempdima by \indented@level
    \leftskip\normalparindent
    \advance\leftskip\@tempdima
    \parindent-0.5\normalparindent
    \ifnum\indented@level > \@ne
        \footnotesize                   %%*???
    \fi
}{%
    \par
    \smallskip
}

\newenvironment{indented*}[1][-1]{%
    \par
    \ifnum#1 > -1
        \indented@level#1%
    \else
        \advance\indented@level\@ne
    \fi
    \@tempdima.5\normalparindent
    \multiply\@tempdima by \indented@level
    \leftskip\normalparindent
    \advance\leftskip\@tempdima
    \parindent-0.5\normalparindent
    \ifnum\indented@level > \@ne
        \footnotesize                   %%*???
    \fi
}{%
    \par
    \smallskip
}

\newenvironment{mexamples}[1][2]{%
    \begin{multicols}{#1}
    \small
    \raggedcolumns
    \raggedright
    \interlinepenalty\@M
    \leftskip\normalparindent
    \parindent-\leftskip
}{%
    \end{multicols}%
    \@ignoretrue
}

\newenvironment{mexamples*}[1][2]{%
    \begin{multicols}{#1}
    \small
    \raggedcolumns
    \raggedright
    \interlinepenalty\@M
%    \leftskip\normalparindent
    \parindent\normalparindent
}{%
    \end{multicols}
}

\newcommand{\cc}[1]{\multicolumn{#1}{@{}c@{}}}

\newenvironment{Longtable}{%
    \let\M\multicolumn
    \small
%    \setlength{\LTleft}{0pt}%
%    \setlength{\LTright}{0pt}%
    \longtable
}{%
    \endlongtable
}

\newenvironment{Longtable*}{%
    \let\M\multicolumn
    \small
    \setlength{\LTleft}{0pt}%
    \setlength{\LTright}{0pt}%
    \longtable
}{%
    \endlongtable
}

\newenvironment{Tabular}[1][]{%
    \let\note\alignnote
    \let\endnote\endalignnote
    \let\M\multicolumn
    #1%
    \Longtable
}{%
    \endLongtable
}

\newenvironment{Tabular*}[1][]{%
    \let\M\multicolumn
    \setlength{\LTleft}{0pt}%
    \setlength{\LTright}{0pt}%
    #1%
    \longtable
}{%
    \endlongtable
}

\newcommand\setrowsize[1]{\global\let\v@rowsize#1}

\newenvironment{vexamples}[1][\relax]{%
    \let\v@rowsize#1%
%    \LTpost\z@
    \csname Tabular*\endcsname{@{}>{\v@rowsize}l@{\extracolsep{\fill}}*{3}{>{\v@rowsize}l}@{}}
}{%
    \csname endTabular*\endcsname
    \nointerlineskip
}

\newenvironment{vexamples*}{%
    \vexamples[\footnotesize]
}{%
    \endvexamples
}

\newenvironment{sidebyside}{%
    \ifvmode\else
        \par
        \addvspace{\smallskipamount}%
    \fi
    \begin{Longtable*}{>{\hangindent.5\normalparindent}p{.47\textwidth}
                       @{\extracolsep{\fill}}
                       >{\hangindent.5\normalparindent}p{.47\textwidth}}

}{%
    \end{Longtable*}
}

\newenvironment{sidebyside*}{%
    \ifvmode\else
        \par
        \addvspace{\smallskipamount}%
    \fi
    \begin{Longtable*}{>{\hangindent.5\normalparindent\rightskip\@flushglue}p{.47\textwidth}
                       @{\extracolsep{\fill}}
                       >{\hangindent.5\normalparindent\rightskip\@flushglue}p{.47\textwidth}}

}{%
    \end{Longtable*}
}

\newenvironment{pparts}{%
    \begin{Tabular*}[][c]{@{\extracolsep{\fill}}*4{c}}
    \cc{4}{\textbf{Principal Parts}}\\[\smallskipamount]
}{%
    \end{Tabular*}
}

\newenvironment{paradigm}{%
    \let\M\multicolumn
    \setlength{\LTright}{0pt}%
    \setlength{\LTleft}{0pt}%
    \longtable{@{}
               l@{\extracolsep{1em}}l
               @{\extracolsep{\fill}}
               l@{\extracolsep{1em}}l
               @{}}
}{%
    \endlongtable
}

\newenvironment{imperative}{%
    \let\M\multicolumn
    \setlength{\LTright}{0pt}%
    \setlength{\LTleft}{0pt}%
    \longtable{@{}
               >{\itshape}l
               @{\enskip}l@{\quad}l
               @{\extracolsep{\fill}}
               l@{\extracolsep{0pt}}@{\quad}l
               @{}}
    \M{5}{c}{\textbfsc{imperative}} \\
    & \textsc{singular}
    & \textsc{plural}
    & \textsc{singular}
    & \textsc{plural} \\
}{%
    \endlongtable
}

\newenvironment{imperative*}{%
    \let\M\multicolumn
    \setlength{\LTright}{0pt}%
    \setlength{\LTleft}{0pt}%
    \longtable{@{}
               >{\itshape}l
               l@{\extracolsep{\fill}}l
               @{\extracolsep{2em}}
               l@{\extracolsep{\fill}}l
               @{}}
}{%
    \endlongtable
}

\newenvironment{nonfinite}{%
    \let\M\multicolumn
    \setlength{\LTright}{3\parindent}%
    \setlength{\LTleft}{3\parindent}%
    \longtable{@{}
               >{\itshape}l@{\enskip}l
               @{\qquad\qquad}
               >{\itshape}l@{\enskip}l
               @{}}
}{%
    \endlongtable
}

\newenvironment{calendar}{%
    \noindent\begin{minipage}{\textwidth}
    \let\footnoterule\relax
    \makeatletter
    \skip\@mpfootins2pt
    \renewcommand\@makefntext[1]{%
        \parindent\z@% 1em%
        \noindent
        \@makefnmark##1}
    \makeatother
    \let\M\multicolumn
    \begin{Tabular}[\footnotesize][l]{@{}c|
                                   r@{ }r@{ }c|
                                   r@{ }r@{ }c|
                                   r@{ }r@{ }c|
                                   r@{ }r@{ }c
                                   @{}}
    
}{%
    \end{Tabular}
    \end{minipage}
}

\newenvironment{examples}[1][0pt]{%
    \par
    \addvspace{\smallskipamount}%
    \small
    \advance\leftskip2\normalparindent
    \advance\leftskip-#1%
    \parindent-\normalparindent
    \advance\parindent#1%
    \parskip\z@
    \rightskip\z@
}{%
    \par
    \addvspace{\smallskipamount}%
    \@ignoretrue
}

\newenvironment{vocab}{%
    \par
    \addvspace{\smallskipamount}%
    \small
    \leftskip\normalparindent
    \parindent-\normalparindent
    \rightskip\z@
}{%
    \par
    \addvspace{\smallskipamount}%
    \@ignoretrue
}

%% Need a second level of minor (see section 29)

\newenvironment{minor}{%
    \par
    % \addvspace{2.5pt}%
    % \footnotesize
}{%
    \par
}

\newenvironment{@note}[1][Note]{%
    \let\item\orig@item
    \trivlist
    \labelsep.5em
    \small
    \item[\indent\textsc{#1}.]
}{%
    \endtrivlist
}

\let\note\@note
\let\endnote\end@note

\newenvironment{alignnote}{%
    \vadjust\bgroup
        \begin{@note}
}{%
        \end{@note}
    \egroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                              MARKS                               %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\@firstofthree#1#2#3{#1}
\def\@secondofthree#1#2#3{#2}

\let\@leftmark\@firstofthree
\let\@rightmark\@secondofthree
\let\@thirdmark\@thirdofthree

\def\leftmark{\expandafter\@leftmark\botmark\@empty\@empty\@empty}

\def\rightmark{\expandafter\@rightmark\firstmark\@empty\@empty\@empty}

\def\thirdmark{\expandafter\@thirdmark\firstmark\@empty\@empty\@empty}

\def\fourthmark{\expandafter\@thirdmark\botmark\@empty\@empty\@empty}

\def\@themark{{}{}{}}

\newtoks\@temptokenb

\def\markall#1#2#3{%
    \begingroup
        \let\label\relax \let\index\relax \let\glossary\relax
        \unrestored@protected@xdef\@themark{{#1}{#2}{#3}}%
        \@temptokena \expandafter{\@themark}%
        \mark{\the\@temptokena}%
    \endgroup
    \if@nobreak\ifvmode\nobreak\fi\fi
}

\def\markboth#1#2{%
    \begingroup
        \let\label\relax \let\index\relax \let\glossary\relax
        \unrestored@protected@xdef\@themark {{#1}{#2}{}}%
        \@temptokena \expandafter{\@themark}%
         \mark{\the\@temptokena}%
    \endgroup
    \if@nobreak\ifvmode\nobreak\fi\fi
}

\def\markright#1{%
    \begingroup
        \let\label\relax \let\index\relax \let\glossary\relax
        \expandafter\@markright\@themark{#1}%
        \@temptokena \expandafter{\@themark}%
        \mark{\the\@temptokena}%
    \endgroup
    \if@nobreak\ifvmode\nobreak\fi\fi
}

\def\markthird#1{%
    \begingroup
        \let\label\relax \let\index\relax \let\glossary\relax
        \expandafter\@markthird\@themark{#1}%
        \@temptokena \expandafter{\@themark}%
        \mark{\the\@temptokena}%
    \endgroup
    \if@nobreak\ifvmode\nobreak\fi\fi
}

% #1 = old leftmark
% #2 = old rightmark
% #3 = old thirdmark
% #4 = new rightmark

\def\@markright#1#2#3#4{%
    \@temptokena{#1}%
    \@temptokenb{#3}%
    \unrestored@protected@xdef\@themark{%
        {\the\@temptokena}% #1
        {#4}%
        {\the\@temptokenb}% #3
    }%
}

% #1 = old leftmark
% #2 = old rightmark
% #3 = old thirdmark
% #4 = new thirdmark

\def\@markthird#1#2#3#4{%
    \@temptokena{#1}%
    \@temptokenb{#2}%
    \unrestored@protected@xdef\@themark{%
        {\the\@temptokena}% #1
        {\the\@temptokenb}% #2
        {#4}%
    }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                            TITLEPAGE                             %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewenvironment{titlepage}{%
    \clearpage
    \if@twocolumn
        \@restonecoltrue\onecolumn
    \else
        \@restonecolfalse\newpage
    \fi
    \thispagestyle{empty}%
    \phantomsection
    \pdfbookmark[0]{Title page}{\@currentHref}%
}{%
    \if@restonecol\twocolumn \else \newpage \fi
}

\renewcommand\mainmatter{%
    \null
    \cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                             COLOPHON                             %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{colophon}{
    \cleardoublepage
    
    \thispagestyle{empty}
    
    \phantomsection
    \pdfbookmark[0]{Colophon}{\@currentHref}%
    
    \null
    
    \vfill
    
    \begin{center}
    
    \textbf{COLOPHON}
    
    \bigskip
    
    \begin{minipage}{.75\textwidth}
    \parskip\medskipamount
}{%
    \end{minipage}
    \end{center}
    \vfill
    \vfill
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                    SECTIONING, HEADINGS, ETC.                    %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand\part{%
    \@ifstar{\@dblarg\@part}{\cleardoublepage\@dblarg\@part}%
}

\def\@part[#1]#2{%
    \thispagestyle{dropfolio}%
    \refstepcounter{part}%
    \@stpelt{footnote}%
    \addtocontents{toc}{\protect\contentsline{part}{#1}{\thepart}
        {\@currentHref}%
    }
    \pdfbookmark[0]{#2}{\@currentHref}%
    \markall{#1}{#1}{}%
    \begingroup
        \centering
        \interlinepenalty \@M
        \normalfont
        \huge
        \textsc{\partname\enskip\thepart}\par
        \vskip 5\p@
        \textsc{\lowercase{#2}}\par
    \endgroup
    \bigskip
}

\newif\if@starred
\@starredfalse

\newif\if@numbered
\@numberedfalse

\newif\if@starrednum
\@starrednumfalse

\renewcommand\thechapter{\@Alph\c@chapter}

\newcommand\numchapter{%
    \@afterindentfalse
    \@numberedtrue
    \@ifstar
        {\@starrednumtrue\@dblarg{\@chapter}}%
        {\@starrednumfalse\@dblarg{\@chapter}}%
}

%% Decouple section numbers from chapter numbers.

\def\cl@chapter{%
    \@elt{equation}%
    \@elt{figure}%
    \@elt{table}%
    \@elt{footnote}%
}

\newif\if@unnumbered
\@unnumberedfalse

\newcommand\Unnumbered{%
    \@afterindentfalse
    \@numberedfalse
    \@unnumberedtrue
    \@ifstar
        {\@starredtrue\@dblarg{\@chapter}}%
        {\@starredfalse\@dblarg{\@chapter}}%
}

\renewcommand\chapter{%
    \@afterindentfalse
    \@numberedfalse
    \@unnumberedfalse
    \setcounter{headingD}{0}%
    \setcounter{headingE}{0}%
    \setcounter{headingF}{0}%
    \@ifstar
        {\@starredtrue\@dblarg{\@chapter}}%
        {\@starredfalse\@dblarg{\@chapter}}%
}

\def\@chapter[#1]#2{%
    \markright{#1}%
    \if@numbered
        \refstepcounter{chapter}%
    \fi
    \@makechapterhead{#2}%
}

\newif\if@nochapterspace
\@nochapterspacefalse

\def\suppresschapterspace{\global\@nochapterspacetrue}
\def\restorechapterspace{\global\@nochapterspacefalse}

\def\@makechapterhead#1{%
    \if@nochapterspace \else
        \addvspace\bigskipamount
    \fi
    \suppresschapterspace
    \begingroup
        \parindent\z@
        \interlinepenalty\@M
        \centering
        \normalfont
        \if@starred
            \bfseries
        \else
            \if@unnumbered
                \cleardoublepage
                \null
                \vskip 1em
                \large
            \fi
        \fi
        \if@numbered
            \if@starrednum
                \thechapter.\enskip
            \else
                \emph{\thechapter}.\enskip
            \fi
        \fi
        \Hy@MakeCurrentHrefAuto{algchapter*}%
        \Hy@raisedlink{\hyper@anchorstart{\@currentHref}\hyper@anchorend}%
        \begingroup
            \let\emend\@thirdofthree
            \pdfbookmark[\if@unnumbered0\else1\fi]{#1}{\@currentHref}%
        \endgroup
        \uppercase{#1}\par
        \nobreak
    \endgroup
    \addvspace\medskipamount
    \@afterheading
}

\def\@afterheading{%
    \@nobreaktrue
    \everypar{%
        \if@nobreak
            \@nobreakfalse
            \clubpenalty \@M
            \if@afterindent \else
                {\setbox\z@\lastbox}%
            \fi
        \else
            \clubpenalty \@clubpenalty
            \everypar{}%
        \fi
        \restorechapterspace
    }%
}

% \headingA looks like \chapter, but doesn't go in the heading

\def\headingA{%
    \@starredfalse
    \@numberedfalse
    \@makechapterhead
}

% \headingB looks like \chapter*, but doesn't go in the heading

\def\headingB{%
    \@starredtrue
    \@numberedfalse
    \@makechapterhead
}

\newcounter{@fake}

\def\headingC#1{%
    \@startsection{@fake}{100}{\z@}%
                  {\medskipamount}%
                  {\smallskipamount}%
                  {\centering\normalfont\bfseries}{#1}%
}

\let\@fakemark\@gobble

\newcounter{headingD}
\def\theheadingD{\textup{\@Roman\c@headingD}}
\let\headingDmark\@gobble

\def\headingD#1{%
    \@startsection{headingD}{3}{\z@}%
                  {\medskipamount}%
                  {\smallskipamount}%
                  {\centering\normalfont\large\itshape}{#1}%
}

\newcounter{headingE}
\def\theheadingE{\textup{\@Roman\c@headingE}}

\def\headingE#1{%
    \@startsection{headingE}{3}{\z@}%
                  {\medskipamount}%
                  {\smallskipamount}%
                  {\centering\normalfont\bfseries}{\uppercase{#1}}%
}

\let\headingEmark\@gobble

\newcounter{headingF}
\def\theheadingF{\textup{\@Alph\c@headingF}}

\def\headingF#1{%
    \@startsection{headingF}{3}{\z@}%
                  {\medskipamount}%
                  {\smallskipamount}%
                  {\centering\normalfont\bfseries}{\uppercase{#1}}%
}

\let\headingFmark\@gobble

\def\headingG#1{%
    \@startsection{@fake}{100}{\z@}%
                  {\medskipamount}%
                  {\smallskipamount}%
                  {\centering\normalfont\scshape}{#1}%
}

\newcommand{\subtitle}[1]{%
    \par
    \if@nochapterspace\else
        \addvspace{\medskipamount}%
    \fi
    \begingroup
        \interlinepenalty\@M
        \global\everypar{}%
        \@@line{%
            \rlap{\@svsechd}%
            \hss
            \normalfont #1
            \hss
        }%
        \par\nobreak
    \endgroup
    \addvspace{\smallskipamount}%
    \nointerlineskip
}

\def\@seccntformat#1{%
    \begingroup
        \csname the#1\endcsname.\enskip%
    \endgroup
}

% \def\@seccntformat#1{%
%   \protect\textup{\csname the#1\endcsname\protect\@secnumpunct}%
% }

\newif\if@ams@empty

\@ams@emptyfalse

\def\ams@measure#1{%
    \begingroup
        \let\[\(\let\]\)%
        \disable@stepcounter
        \setbox\@tempboxa\hbox{\ignorespaces#1\unskip}%
    \expandafter\endgroup
    \ifdim\wd\@tempboxa=\z@
        \@ams@emptytrue
    \else
        \@ams@emptyfalse
    \fi
}

\def\@startsection#1#2#3#4#5#6{%
    \if@noskipsec \leavevmode \fi
    \par
    \@tempskipa #4\relax
    \@afterindenttrue
    \ifdim \@tempskipa <\z@
        \@tempskipa -\@tempskipa
        \@afterindentfalse
    \fi
    \if@nobreak
        \everypar{}%
    \else
        \addpenalty\@secpenalty
        \if@nochapterspace\else
            \addvspace\@tempskipa
        \fi
    \fi
    \@tempskipb #5\relax
    \ifdim \@tempskipb <\z@
        \restorechapterspace
    \else
        \suppresschapterspace
    \fi
    \@ifstar
        {\@ssect{#3}{#4}{#5}{#6}}%
        {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}%
}

\def\@sect#1#2#3#4#5#6[#7]#8{%
    \ams@measure{#8}%
    \ifnum #2>\c@secnumdepth
        \let\@svsec\@empty
    \else
        \refstepcounter{#1}%
        \protected@edef\@svsec{\@seccntformat{#1}\relax}%
    \fi
    \@tempskipa #5\relax
    \ifdim \@tempskipa>\z@
        \begingroup
            #6{\@hangfrom{\hskip #3\relax\@svsec}%
               \interlinepenalty \@M #8\@@par}%
        \endgroup
        \csname #1mark\endcsname{#7}%
    \else
        \def\@svsechd{%
            #6{%
                \hskip #3\relax
                \@svsec
                \if@ams@empty
                    %\enskip
                \else
                    #8.\enskip
                \fi
                \if@inlinesubsection
                    \ifx\@inlinedsection\subsection
                        \refstepcounter{subsection}%
                        \ifx\@subsubsectionheading\@empty
                            \textnormal{\@seccntformat{subsection}}%
                        \else
                            \textnormal{\@seccntformat{subsection}\@subsubsectionheading.\enskip}%
                            \global\let\@subsubsectionheading\@empty
                        \fi
                    \else
                        \refstepcounter{subsubsection}%
                        \textnormal{\emph{\@seccntformat{subsubsection}}}%
                    \fi
                    \global\@inlinesubsectionfalse
                \fi
            }%
            \csname #1mark\endcsname{#7}%
        }%
    \fi
    \@xsect{#5}%
}

\def\@xsect#1{%
  \@tempskipa #1\relax
  \ifdim \@tempskipa>\z@
    \par \nobreak
    \vskip \@tempskipa
    \@afterheading
  \else
    \@nobreakfalse
    \global\@noskipsectrue
    \everypar{%
      \if@noskipsec
        \global\@noskipsecfalse
       {\setbox\z@\lastbox}%
        \clubpenalty\@M
        \begingroup \@svsechd \endgroup
        \global\let\@svsechd\@empty
        \unskip
        \@tempskipa #1\relax
        \hskip -\@tempskipa
      \else
        \clubpenalty \@clubpenalty
        \everypar{}%
      \fi}%
  \fi
  \ignorespaces}

\let\liningnumerals\relax

\renewcommand\thesection{{\liningnumerals\@arabic\c@section}}

\newif\if@inlinesubsection
\@inlinesubsectionfalse

\let\@inlinedsection\relax

\renewcommand\section[1][]{%
    \restorechapterspace
    \@ifnextchar\subsection{%
        \@inlinesubsection{#1}%
    }{%
        \@ifnextchar\subsubsection{%
            \@inlinesubsectiontrue
            \@section{#1}%
            \let\@inlinedsection
        }{%
            \@inlinesubsectionfalse
            \@section{#1}%
        }%
    }%
}

\def\@inlinesubsection#1\subsection{%
    \let\@inlinedsection\subsection
    \@inlinesubsectiontrue
    \@ifnextchar[{%
        \@insubsectionhead{#1}%
    }{%
        \@section{#1}%
    }%
}

\let\@subsubsectionheading\@empty

\def\@insubsectionhead#1[#2]{%
    \gdef\@subsubsectionheading{#2}%
    \@section{#1}%
}

\newcommand\@section[1]{%
    \@startsection{section}{0}{\parindent}
                              {\z@}
                              {-1sp}
                              {\normalfont\normalsize\bfseries}{#1}%
}

\renewcommand\thesubsection{\@arabic\c@subsection}

\newdimen\presubsectionskip
\presubsectionskip\z@%\smallskipamount

\renewcommand{\subsection}[1][]{%
    \@startsection{subsection}{1}{\parindent}%{\z@}%
                  {\presubsectionskip}%
                  {-.5em}%
                  {\normalfont}{#1}%
}

\@addtoreset{subsubsection}{section}

\renewcommand\thesubsubsection{\@alph\c@subsubsection}

\renewcommand{\subsubsection}[1][]{%
    \@startsection{subsubsection}{2}{\parindent}
                                 {0em}
                                 {-0.5em}%
                                 {\normalfont\itshape}{#1}%
}

\newcounter{psection}
\@addtoreset{psection}{section}
\@addtoreset{subsection}{psection}

\renewcommand\thepsection{\emph{\@Alph\c@psection}}

\newcommand{\psection}[1][]{%
    \@startsection{psection}{1}{\parindent}%
                               {1.0 ex \@plus.25ex \@minus.1ex}%
                               {-0.5em}%
                               {\normalfont}{#1}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                         FOOTNOTE PATCHES                         %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Patches to allow use of \footnote in headings. Cf. amsclass.dtx v2.53

\def\@gobbleopt{\@ifnextchar[{\@gobbleopt@}{}}
\def\@gobbleopt@[#1]{}
\def\@gobble@opt{\@ifnextchar[{\@gobble@opt@}{\@gobble}}
\def\@gobble@opt@[#1]#2{}

\def\disable@footnotes{%
    \let\footnote\@gobble@opt
    \let\footnotemark\@gobbleopt
    \let\footnotetext\@gobble@opt
}

\def\disable@stepcounter{%
    \let\stepcounter\@gobble
    \let\refstepcounter\@gobble
    \let\addtocounter\@gobbletwo
}

% \newskip\prefootnoteruleskip
% \newskip\normalprefootnoteruleskip
% 
% \normalprefootnoteruleskip-3pt
% 
% \prefootnoteruleskip\normalprefootnoteruleskip
% 
% \renewcommand\footnoterule{%
% \typeout{*** prefootnoteruleskip = \the\prefootnoteruleskip}%
%     \kern\prefootnoteruleskip
%     \hrule\@width.4\columnwidth
%     \kern2.6\p@
%     \global\prefootnoteruleskip\normalprefootnoteruleskip
% }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                        TABLE OF CONTENTS                         %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand\tableofcontents{%
    \cleardoublepage
    \@makechapterhead{Table of Contents}%
    \markboth{Table of Contents}{Table of Contents}%
    \thispagestyle{dropfolio}
    \begingroup
        \def\latin##1{\textnormal{\textbf{##1}}}%
        \@starttoc{toc}%
    \endgroup
}

\newcounter{contentsentry}

\newcommand{\contentsentry}[2]{%
    \begingroup
        \let\WriteBookmarks\relax
        \addcontentsline{toc}{toclevel#1}{#2}%{\@currentHref}%
    \endgroup
}

\setcounter{tocdepth}{-1}

\renewcommand*\l@part[2]{%
    \addpenalty{-\@highpenalty}%
    \addvspace{1em \@plus\p@}%
    \setlength\@tempdima{3em}%
    \begingroup
        \parindent \z@ \rightskip \@pnumwidth
        \parfillskip -\@pnumwidth
        \begin{center}%
            \large
            \textsc{Part #2}\\
            \medskip
            \textbf{\uppercase{#1}}%
            \medskip
        \end{center}
        \par
        \nobreak
        \global\@nobreaktrue
        \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
}

\def\toclevel@toclevelA{2}
\def\toclevel@toclevelB{3}
\def\toclevel@toclevelC{4}

\def\l@toclevelA#1#2{%
%    \goodbreak
    \vskip \z@ \@plus.2\p@
    \begingroup
        \parindent\z@
        \interlinepenalty\@M
        \leavevmode
        \textsc{#1}:\nobreak
        \nobreak
        \par
    \endgroup
}

\newcommand*\l@toclevelB{\@dottedtocline{-1}{0em}{1em}}
\newcommand*\l@toclevelC{\@dottedtocline{-1}{1.5em}{1.5em}}

\def\@dottedtocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth \else
    \vskip \z@ \@plus.2\p@
    {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
     \disable@footnotes
     \parindent #2\relax\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode
     \@tempdima #3\relax
     \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
     \textsc{#4}\nobreak
     \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hfill
     \nobreak
     \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
     \par}%
  \fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                              LISTS                               %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{points}{%
    \par
    \smallskip
    \small
    \leftskip 2em
    \parindent-\leftskip
}{%
}

\renewenvironment{verse}
               {\let\\\@centercr
                \list{}{\topsep\smallskipamount
                        \itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item\relax}
               {\endlist}

\renewenvironment{quote}{%
    \list{}{%
        \leftmargin1em
        \rightmargin\leftmargin
    }%
    \item\relax
}{%
    \endlist
}

%% Life is too short to spend fighting with the list environment, so
%% I'm just going to define my own more limited list functionality.

% \def\theenumi{\@arabic\c@enumi}
\renewcommand\labelenumi{\theenumi)}

% \def\theenumii{\@alph\c@enumi}
\renewcommand\labelenumii{\emph{\theenumii}.}

\let\orig@item\item

\let\orig@itemize\itemize

\def\itemhead#1{%
    \par
    \noindent\hskip-\leftskip\quad#1\enskip\ignorespaces
}

\def\itemize{%
    \let\item\orig@item
    \orig@itemize
}

\def\alg@item{%
    \@ifnextchar\par{\expandafter\alg@item@\@gobble}{\alg@item@}%
}

\def\alg@item@{%
    \refstepcounter\@listctr
    \par
    \csname label\@enumctr\endcsname\ %\hskip.25em\relax%\enskip
    \ignorespaces
}

\renewenvironment{enumerate}{%
    \par
    \ifnum \@enumdepth >\thr@@\@toodeep\else
        \advance\@enumdepth\@ne
        \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
        \usecounter\@enumctr
        \ifnum\@enumdepth > \@ne
            \advance\leftskip\normalparindent
        \fi
    \fi
    \let\item\alg@item
    \parindent\normalparindent
}{%
    \par
}

\newenvironment{enumerate*}{%
    \enumerate
    \def\labelenumi{\theenumi.}%
}{%
    \endenumerate
}

\newenvironment{enuma}{%
    \enumerate
    \def\theenumi{\alph{enumi}}%
    \renewcommand\labelenumi{\emph{\theenumi})}%
    \def\theenumii{\alph{enumii}}%
    \renewcommand\labelenumii{\emph{\theenumii})}%
}{%
    \endenumerate
}

\newenvironment{enumA}{%
    \leftmargini\z@
    \enumerate
    \def\theenumi{\Alph{enumi}}%
    \def\labelenumi{\emph{\theenumi}.}%
}{%
    \endenumerate
}

\newenvironment{enum1}{%
    \enumerate
    \def\theenumi{\arabic{enumi}}%
    \def\labelenumi{\theenumi.}%
    \def\theenumii{\arabic{enumii}}%
    \def\labelenumii{\theenumii.}%
}{%
    \endenumerate
}

\newenvironment{enum1*}{%
    \enumerate
    \def\theenumi{\arabic{enumi}}%
    \def\labelenumi{\theenumi)}%
    \def\theenumii{\arabic{enumii}}%
    \def\labelenumii{\theenumii)}%
}{%
    \endenumerate
}

\newenvironment{enumI}[1][VIIII]{%
    \enumerate
    \def\theenumi{\Roman{enumi}}%
    \def\labelenumi{\theenumi.}%
    \setbox\z@\hbox{#1.\enskip}%
    \labelwidth\wd\z@
    \labelsep.5em
    \leftskip\labelwidth
    \advance\leftskip\parindent
    \def\alg@item@{%
        \refstepcounter\@listctr
        \par
        \leavevmode
        \hskip-\leftskip
        \hbox to \labelwidth{%
            \hss\csname label\@enumctr\endcsname\hskip\labelsep
        }%
        \ignorespaces
    }%
}{%
    \endenumerate
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                          PAGE HEADINGS                           %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\headingfont}{\fontsize{10}{11}\selectfont}

\def\ps@headings{%
    \let\@oddfoot\@empty
    \let\@evenfoot\@empty
    \def\@evenhead{%
        \disable@footnotes
        \let\footnotemark\@empty
        \headingfont
        \thepage
        \hfill
        \emph{\leftmark}%
        \hfill
        \if####\thirdmark####\else
            [\textbf{\thirdmark}%
        \fi
    }%
    \def\@oddhead{%
        \disable@footnotes
        \let\footnotemark\@empty
        \headingfont
        \if####\thirdmark####\else
            \textbf{\fourthmark}]%
        \fi
        \hfill
        \emph{\rightmark}%
        \hfill
        \thepage
    }%
    \let\@mkboth\markboth
    \def\sectionmark##1{\markthird{\thesection}}%
}

\def\ps@dropfolio{%
    \def\@oddfoot{\hfill\thepage\hfill}%
    \let\@evenfoot\@oddfoot
    \let\@oddhead\@empty
    \let\@evenhead\@empty
}

\ps@headings

\topsep\z@

\raggedbottom

\hfuzz=1pt
\advance\hfuzz -1sp

\emergencystretch=2pt

\showboxbreadth=10000
\showboxdepth=10000

\hyphenation{man-u-script Chi-ca-go in-di-rect-ness name-ly sharp-ly}
\hyphenation{neu-ter neu-ters}
\hyphenation{pro-nom-i-nal}
\hyphenation{para-tax-is}
\hyphenation{post-quam}
\hyphenation{rhe-tor-i-cal}
\hyphenation{strong-er}
\hyphenation{pres-ent}
\hyphenation{ac-cu-sa-tive}
\hyphenation{an-te-ce-dent}
\hyphenation{an-te-ce-dents}
\hyphenation{Gnae-us}
\hyphenation{vir-tu-al}
%\hyphenation{add-ed}

\setcounter{secnumdepth}{3}

\let\orig@lbibitem\@lbibitem

\RequirePackage[
    colorlinks=true,
    linkcolor=blue,
    bookmarksdepth=3,
    verbose=true
]{hyperref}

\providecommand\theHsection{}
\renewcommand\theHsection{\arabic{section}}

\let\@lbibitem\orig@lbibitem

\RequirePackage{ifpdf,ifxetex}

% \RequirePackage{everypage}
% 
% \AddEverypageHook{%
%     \@ifundefined{pdfmark}{}{%
%         \pdfmark{pdfmark=/PAGELABEL,Raw={/Label (\thepage)}}%
%     }%
% }

\def\liningnumerals{\addfontfeatures{Numbers=Lining}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                          VERSE SCANSION                          %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\ictus}{%
    \@ifstar{\@ictus{\textstyle\text{.}}}{\@ictus{\circ}}%
}

\newcommand{\@ictus}[2]{%
    $\mathop{\text{#2}}\limits\sp{#1}$%
}

\newcommand{\stress}{%
    \@ifstar{\@ictus{\kern1pt\lower5pt\hbox{$\scriptscriptstyle\prime$}}}
            {\@ictus{\kern1.5pt\lower5pt\hbox{$\scriptstyle\prime$}}}%
}

\newcommand{\slur}[1]{\t{#1}}

\newfontface\scansion@font{ALPHABETUM Unicode}

\chardef\foot@l="F700
\chardef\foot@ĺ="F704
\chardef\foot@s="F701
\chardef\foot@ś="F706

\chardef\foot@c="F702
\chardef\foot@C="F70E

\chardef\foot@h="F70A % hiatus

\def\foot@t{{\normalsize\char"F741}} % short tie
\def\foot@T{{\normalsize\char"F742}} % long tie

\begingroup

\catcode`\|=11
\catcode`\^=11
\catcode`\∣=11 % U+2223
\catcode`\∥=11 % U+2225

\catcode`\×=11 % U+00D7 (for hiatus)

\global\chardef\foot@^="F714
\global\chardef\foot@∥="F711
\global\chardef\foot@×="F70A

\global\def\foot@|{\kern1pt\char"F710}

\endgroup

\catcode`\∣=\active
\edef∣{{\noexpand\scansion@font\csname foot@\string|\endcsname}}

\catcode`\∥=\active
\def∥{{\scansion@font\char"F711}}

\catcode`\^=\active
\def^{{\scansion@font\char"F714}}

% \catcode`\×=\active
% \def×{{\scansion@font\char"F70A}}

\edef\hiatus{{\noexpand\scansion@font\csname foot@\string ×\endcsname}}

\renewcommand{\slur}{\scan{t}}

\def\scan{%
    \begingroup
        \edef∣{\string∣}%
        \edef^{\string^}%
        \catcode`\∣=11
        \catcode`\∥=11
        \catcode`\^=11
        \catcode`\×=11
        \@scan
}

\newcommand\@scan[1]{%
        \large
        \scansion@font
        \@tempswafalse
        \@tfor\@foot:=#1\do{%
            \if@tempswa
                \kern.1em
            \else
                \@tempswatrue
            \fi
            \csname foot@\@foot\endcsname
        }%
    \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                          MUSIC NOTATION                          %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newfontface\music@font{Sonata Std}

\chardef\note@H="1D15E
\chardef\note@Q="1D15F

% \chardef\Note@h="E01D
% \chardef\Note@q="E020

\def\note@h{\raise.5em\hbox{\char"E01D}}
\def\note@q{\raise.5em\hbox{\char"E020}}

\def\music#1{%
    \begingroup
        \large
        \music@font
        \@tempswafalse
        \@tfor\@note:=#1\do{%
            \if@tempswa
                \,%
            \else
                \@tempswatrue
            \fi
            \csname note@\@note\endcsname
        }%
    \endgroup
}

% reversed c

\catcode"2184 = \active

\defↄ{\reflectbox{c}}

\def\u#1{{\accent"02D8 #1}}
\def\'#1{{\accent"00B4 #1}}
\def\=#1{{\accent"02C9 #1}}
\def\t#1#2{#1{\scansion@font\foot@t}#2}

\def\b#1{%
    \hmode@bgroup
        \o@lign{%
            \relax #1\crcr
            \hidewidth
                \ltx@sh@ft{-3ex}\vbox to.2ex{\hbox{\char"00AF}\vss}%
            \hidewidth
        }%
    \egroup
}

\edef\#{\string#}
\edef\${\string$}
\def\dots{…}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%                         VULGAR FRACTIONS                         %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\vfrac}[2]{%
    \begingroup
        \addfontfeatures{Fractions=On}%
        #1/#2
    \endgroup
}

\endinput
