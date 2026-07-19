\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lispy-book}[2026/06/11 LisPy Book Class]

% ---------- base class ----------
\LoadClass[10pt,oneside,openany]{book}

% ---------- geometry ----------
\RequirePackage[paperwidth=7.5in,paperheight=9.25in,
  top=0.9in,bottom=0.9in,inner=0.9in,outer=0.75in,
  marginparwidth=1.2in,marginparsep=0.15in,
  headheight=15.1pt,headsep=0.2in,footskip=0.35in]{geometry}

% ---------- fonts ----------
\RequirePackage{fontspec}
\setmainfont{TeX Gyre Pagella}
\setsansfont{TeX Gyre Heros}
\setmonofont{Inconsolatazi4}[
  Scale=MatchLowercase]

% ---------- math ----------
\RequirePackage{amsmath,amssymb,amsthm}

% ---------- color ----------
\RequirePackage{xcolor}
\definecolor{lisppygreen}{RGB}{0,128,0}
\definecolor{lispblue}{RGB}{40,80,160}
\definecolor{pyyellow}{RGB}{255,185,15}
\definecolor{codebg}{RGB}{245,245,245}
\definecolor{codeframe}{RGB}{210,210,210}
\definecolor{stringgreen}{RGB}{0,128,0}
\definecolor{keywordblue}{RGB}{0,0,255}
\definecolor{commentgray}{RGB}{128,128,128}
\definecolor{numberred}{RGB}{200,0,0}

% ---------- packages that might load pgf/tikz ----------
\RequirePackage{graphicx}
\RequirePackage{pgf}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18}
\RequirePackage{longtable}
\RequirePackage{booktabs}
\RequirePackage{enumitem}
\setlist{nosep}

% ---------- tcolorbox ----------
\RequirePackage{tcolorbox}
\tcbuselibrary{breakable}

\newtcolorbox{examplebox}[1][]{
  colback=green!5!white,
  colframe=green!50!black,
  fonttitle=\bfseries,
  title=Ejemplo,
  breakable,
  #1
}

\newtcolorbox{notebox}[1][]{
  colback=blue!5!white,
  colframe=lispblue,
  fonttitle=\bfseries,
  title=Nota,
  breakable,
  #1
}

\newtcolorbox{warningbox}[1][]{
  colback=red!5!white,
  colframe=red!70!black,
  fonttitle=\bfseries,
  title=Advertencia,
  breakable,
  #1
}

\newtcolorbox{infobox}[1][]{
  colback=gray!5!white,
  colframe=gray!50!black,
  fonttitle=\bfseries,
  title=Info,
  breakable,
  #1
}

\newtcolorbox{mathbox}[1][]{
  colback=purple!5!white,
  colframe=purple!60!black,
  fonttitle=\bfseries,
  title=Matemáticas,
  breakable,
  #1
}

% ---------- hyperref ----------
\RequirePackage[colorlinks=true,
  linkcolor=lispblue,
  urlcolor=lispblue,
  citecolor=lispblue,
  bookmarksnumbered=true,
  bookmarksopen=true,
  pdfauthor={Oscar Riveros},
  pdftitle={LisPy Handbook --- The Definitive Guide}]{hyperref}

\graphicspath{{images/}}

% ---------- listings ----------
\RequirePackage{listings}
\RequirePackage{caption}

\lstdefinelanguage{Lisp}{
  morekeywords=[1]{
    defun,defmacro,defclass,defmethod,defgeneric,
    defvar,defparameter,defconstant,defpackage,in-package,
    defstruct,deftype,
    let,let*,setq,setf,incf,decf,rotatef,shiftf,
    if,when,unless,cond,case,ecase,typecase,
    loop,do,do*,dotimes,dolist,tagbody,go,
    block,return-from,catch,throw,unwind-protect,
    lambda,flet,labels,macrolet,
    handler-case,handler-bind,error,cerror,warn,
    signal,restart-case,restart-bind,
    with-open-file,with-slots,with-accessors,
    eval,compile,load,provide,require,eval-when,
    values,multiple-value-bind,multiple-value-list,
    declare,special,ignore,ignorable,inline,notinline,
    ftype,type,the,check-type,assert,locally,
    quote,function,progn,prog1,prog2,
    and,or,not,
    import,export,
    define-compiler-macro,define-symbol-macro,symbol-macrolet,
    defsetf,define-setf-expander,
    multiple-value-setq,multiple-value-call,multiple-value-prog1
  },
  morekeywords=[2]{
    funcall,apply,mapcar,reduce,
    car,cdr,cons,list,append,nth,elt,
    format,print,princ,prin1,read,write,terpri,
    read-line,read-char,write-line,write-char,write-string,
    read-from-string,write-to-string,
    make-instance,slot-value,call-next-method,change-class,
    null,eq,eql,equal,equalp,
    member,assoc,find,position,remove,subst,
    sort,stable-sort,merge,search,mismatch,
    every,some,notevery,notany,
    complement,constantly,identity,
    nthcdr,last,butlast,ldiff,nreconc,
    push,pop,pushnew,adjoin,
    union,intersection,set-difference,set-exclusive-or,
    make-hash-table,gethash,remhash,clrhash,maphash,
    hash-table-count,hash-table-p,sxhash,
    make-array,aref,vector-push,vector-pop,
    fill,replace,reverse,nreverse,
    concatenate,map,map-into,coerce,
    remove-if,remove-if-not,delete-if,
    count-if,find-if,position-if,
    substitute,substitute-if,nsubstitute,
    type-of,class-of,find-class,
    symbol-name,symbol-value,symbol-function,
    boundp,fboundp,makunbound,fmakunbound,
    gensym,intern,make-symbol,
    find-symbol,find-package,
    symbol-plist,get,getf,remprop,
    trace,untrace,step,time,disassemble,
    macroexpand,macroexpand-1,
    slot-boundp,slot-makunbound,slot-exists-p,
    initialize-instance,reinitialize-instance,
    shared-initialize,make-instances-obsolete,
    no-next-method,no-applicable-method,
    +,-,*,/,/=,mod,rem,floor,ceiling,round,
    sin,cos,tan,sqrt,exp,expt,log,abs,min,max,random,
    atom,consp,listp,symbolp,numberp,integerp,floatp,stringp,
    length,reverse,copy-list,copy-tree,copy-seq,subseq,
    open,close,delete-file,rename-file,probe-file,
    file-position,file-length,
    string=,string<,string-equal,
    read-byte,write-byte,peek-char,listen,
    clear-input,clear-output,finish-output,force-output,
    y-or-n-p,yes-or-no-p,fresh-line,
    make-string-input-stream,make-string-output-stream,
    with-input-from-string,with-output-to-string,
    first,second,third,fourth,fifth,
    rest,mapc,mapcan,mapl,maplist,mapcon,
    acons,pairlis,sublis,nsublis,subst-if,subst-if-not,
    nsubst,nsubst-if,nsubst-if-not,tree-equal,
    nunion,nintersection,nset-difference,nset-exclusive-or,
    subsetp,count,count-if,count-if-not,
    delete,delete-if-not,remove-duplicates,delete-duplicates,
    member-if,member-if-not,assoc-if,assoc-if-not,
    rassoc,rassoc-if,rassoc-if-not,
    tailp,revappend,nconc,
    make-symbol,copy-symbol,keywordp,
    evenp,oddp,plusp,minusp,zerop,
    1+,1-,signum,isqrt,gcd,lcm,conjugate,
    typep,subtypep,char,schar,string-upcase,string-downcase,
    string-trim,string-left-trim,string-right-trim,
    array-dimension,array-dimensions,array-total-size,array-rank,
    adjust-array,make-sequence,make-string,
    directory,pathname,namestring,parse-namestring,
    merge-pathnames,user-homedir-pathname,
    compile-file,get-output-stream-string,
    for,in,from,to,by,below,collect,sum,maximize,minimize,count,
    until,always,never,thereis,across,with,initially,finally,
    nconc,append
  },
  morekeywords=[3]{
    py:import,py:call,py:attr,py:getitem,py:run,
    py:type,py:repr,py:str,py:len,
    py:help,py:dir,py:iter,py:next,py:callable,py:python,
    py:call-kw,
    py:last-traceback,py:frame-locals,py:frame-globals,py:frame-eval,
    py:register-callback,py:gen-next,py:gen-send,
    py:pickle-dumps,py:pickle-loads,
    py:save-session,py:load-session,
    py:gen-close,py:register-ast-hook,py:remove-ast-hook,
    py:python?,py:callable?,
    defpyfun,defpyclass,numpy-fast,sympy-bridge,defmath,
    defnp,pandas-bridge,import-hooks,pythonic,python-template,
    persist,continuations,sklearn-init
  },
  morekeywords=[4]{
    nil,t,pi,most-positive-fixnum,
    most-negative-fixnum,lambda
  },
  sensitive=true,
  alsoletter={'},
  morecomment=[l]{;},
  morestring=[b]"
}

\lstdefinelanguage{PythonPlus}{
  language=Python,
  morekeywords={
    numpy,scipy,matplotlib,sympy,numba,pandas,
    np,plt,sn,sp
  },
}

\lstset{
  basicstyle=\small\ttfamily,
  frame=single,
  framesep=4pt,
  framerule=0.5pt,
  rulecolor=\color{codeframe},
  backgroundcolor=\color{codebg},
  breaklines=true,
  breakatwhitespace=true,
  columns=fixed,
  basewidth={0.5em,0.5em},
  keepspaces=true,
  tabsize=2,
  showstringspaces=false,
  extendedchars=true,
  inputencoding=utf8,
  literate={→}{{$\rightarrow$}}1 {λ}{{$\lambda$}}1 {ε}{{$\varepsilon$}}1
    {Θ}{{$\Theta$}}1 {θ}{{$\theta$}}1
    {✓}{{$\checkmark$}}1
    {⏎}{{$\hookleftarrow$}}1,
}

\lstdefinestyle{lisp}{
  language=Lisp,
  keywordstyle=[1]\color{keywordblue}\bfseries,
  keywordstyle=[2]\color{lispblue},
  keywordstyle=[3]\color{lisppygreen},
  keywordstyle=[4]\color{numberred}\bfseries,
  commentstyle=\color{commentgray}\itshape,
  stringstyle=\color{stringgreen},
  numberstyle=\tiny\color{commentgray},
}

\lstdefinestyle{python}{
  language=PythonPlus,
  keywordstyle=\color{keywordblue}\bfseries,
  commentstyle=\color{commentgray}\itshape,
  stringstyle=\color{stringgreen},
}

\lstnewenvironment{lispcode}[1][]
  {\lstset{style=lisp,#1}}
  {}

\lstnewenvironment{pycode}[1][]
  {\lstset{style=python,#1}}
  {}

% ---------- headings ----------
\RequirePackage{titlesec}
\RequirePackage{titletoc}

\titleformat{\part}[display]
  {\normalfont\huge\bfseries\centering\color{lispblue}}
  {\partname~\thepart}{20pt}{\Huge}

\titleformat{\chapter}[display]
  {\normalfont\Large\bfseries\color{lispblue}}
  {\chaptername~\thechapter}{12pt}{\LARGE}

\titlespacing*{\chapter}{0pt}{30pt}{20pt}

\titleformat{\section}
  {\normalfont\large\bfseries\color{lispblue}}
  {\thesection}{1em}{}

\titleformat{\subsection}
  {\normalfont\normalsize\bfseries\color{lispblue!70!black}}
  {\thesubsection}{1em}{}

\titleformat{\subsubsection}
  {\normalfont\normalsize\bfseries\color{lispblue!50!black}}
  {\thesubsubsection}{1em}{}

% ---------- table of contents ----------
\RequirePackage{tocloft}
\renewcommand{\cftpartfont}{\large\bfseries\color{lispblue}}
\renewcommand{\cftchapfont}{\normalsize\bfseries\color{lispblue!80!black}}
\renewcommand{\cftsecfont}{\normalsize\color{black}}
\renewcommand{\cftsubsecfont}{\small\color{black!70!black}}

% ---------- headers & footers ----------
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\leftmark}
\fancyhead[R]{\thepage}
\renewcommand{\chaptermark}[1]{\markboth{\thechapter.\ #1}{}}
\renewcommand{\headrulewidth}{0.4pt}

% ---------- theorem-like ----------
\newtheorem{definition}{Definición}[chapter]
\newtheorem{theorem}{Teorema}[chapter]
\newtheorem{lemma}{Lema}[chapter]
\newtheorem{corollary}{Corolario}[chapter]

% ---------- line spacing ----------
\RequirePackage{setspace}
\setstretch{1.1}

% ---------- index ----------
\RequirePackage{imakeidx}
\makeindex[intoc=true,columns=2]

\endinput
