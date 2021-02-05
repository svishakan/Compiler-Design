/* Lexical Analyser Using Lex Tool */

/*Definitions*/

%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
%}

int_const [0-9]+
float_const [0-9]+.[0-9]+
char_const [\'].[\']
string_const [\"].*[\"]
identifier [a-zA-Z_][a-zA-Z0-9_]*
function [a-zA-Z_][a-zA-Z0-9]*[(].*[)]
keyword (int|float|char|unsigned|typedef|struct|return|continue|break|if|else|for|while|do|extern|auto|case|switch|enum|goto|long|double|sizeof|void|default|register)
pp_dir ^[#].*[>]$
rel_ops ("<"|">"|"<="|">="|"=="|"!=")
assign_ops ("="|"+="|"-="|"%="|"/="|"*=")
arith_ops ("+"|"-"|"%"|"/"|"*")
single_cmt [/][/].*
multi_cmt ([/][/].*)|([/][*](.|[\n\r])*[*][/])
spl_chars [{}(),;\[\]]

/*Rules*/

%%

{pp_dir} {
    printf("PPDIR ");
}

{keyword} {
    printf("KW ");
}

{function} {
    printf("FUNCT ");
}

{identifier} {
    printf("ID ");
}

{single_cmt} {
    printf("SCMT ");
}

{multi_cmt} {
    printf("MCMT ");
}

{int_const} {
    printf("INT_CONST ");
}

{float_const} {
    printf("FLT_CONST ");
}

{char_const} {
    printf("CHAR_CONST ");
}

{string_const} {
    printf("STR_CONST ");
}

{rel_ops} {
    printf("REL_OP ");
}

{arith_ops} {
    printf("ARITH_OP ");
}

{assign_ops} {
    printf("ASSIGN_OP ");
}

{spl_chars} { }

\n {
    printf("\n");
}

[ \t] { }


%%

int yywrap(void){
    return 1;
}


/*User Subroutines*/

int main(int argc, char *argv[]){
    
    yyin = fopen(argv[1], "r");
    yylex();

    return 0;
}

