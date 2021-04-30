%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>

    #include "y.tab.h"
%}

id      ([a-zA-Z\_][a-zA-Z0-9]*)
digit   ([0-9]+)

%%

{id}                    {yylval.str = strdup(yytext); return ID;}
{digit}                 {yylval.intval = atoi(yytext); return INT;}
{digit}[.]{digit}       {yylval.fltval = atof(yytext); return FLOAT;}
[\n]                    {return *yytext;}
[ \t]                   {;}
.                       {return *yytext;}            

%%