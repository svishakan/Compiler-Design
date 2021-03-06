%{
   #include <stdio.h>
   #include "y.tab.c"
   extern YYSTYPE yylval;   
%}

%%

[0-9]+ {yylval = atoi(yytext); return NUM;}
[\t]  ;
[\n]  return 0;
.     return yytext[0];

%%

int yywrap(){
   return 1;
}