%{
    #include <stdio.h>
    #include "y.tab.c"
    extern YYSTYPE yylval;   
%}

assign      ("=")
relop       ("=="|"!="|">="|"<="|"<"|">")
arithop     ("+"|"-"|"/"|"%"|"*")
incdec      ("++"|"--")
logical     ("||"|"&&")
identifier  [a-zA-Z_][a-zA-Z0-9_]*


%%

[0-9]+          {return NUM;}
{assign}        {return ASSIGN;}
{relop}         {return RELOP;}
{logical}       {return LOGIC;}
{arithop}       {return ARITH;}
{incdec}        {return INCDEC;}
"if"            {return IF;}
"else if"       {return ELIF;}
"else"          {return ELSE;}
"for"           {return FOR;}
"while"         {return WHILE;}
{identifier}    {return ID;}


[ \t]           {;}
[\n]            {;}
.               {return *yytext;}

%%

int yywrap(){
   return 1;
}
