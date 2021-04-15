%{
   #include <stdio.h>
   #include <string.h>
   #include "y.tab.c"
   extern YYSTYPE yylval;   
%}

%%

[0-9]+          {yylval = atoi(yytext); return NUM;}
[a-zA-Z\_]      {yylval.str = strdup(yytext); return ID;} 
[\t]            {;}
[\n]            {;}
.               {return *yytext;}

%%

int yywrap(){
   return 1;
}
