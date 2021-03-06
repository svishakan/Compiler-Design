%{
   #include <stdio.h>
   #include <math.h>
   #define YYSTYPE double
   int flag = 0;
%}

%token NUM
/*Defining the precedence*/
%left '+' '-'
%left '/' '*'
%right '^'
%left '(' ')'

%%
Line  :  Expr           {printf("\nResult: %.2f\n", $$);}
Expr  :  Expr '+' Expr  {$$ = $1 + $3;}
      |  Expr '-' Expr  {$$ = $1 - $3;}
      |  Expr '*' Expr  {$$ = $1 * $3;}
      |  Expr '/' Expr  {$$ = $1 / $3;}
      |  Expr '^' Expr  {$$ = pow($1, $3);}
      |  '('Expr')'     {$$ = $2;}
      |  NUM            {$$ = $1;}
%%

int yyerror(){
   flag = 1;
   return 1;
}

int main(void){
   printf("\nEnter arithmetic expression: ");
   yyparse();

   if(flag){
      printf("\nEntered Unexpected Tokens.\n");
   }

   return 0;
}

/* Usage:
         Run yacc -d Calc.y
         Run lex Calc.l
         Run gcc lex.yy.c -lm -w
         Run ./a.out
*/