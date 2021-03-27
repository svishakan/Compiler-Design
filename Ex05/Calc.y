%{
   #include <stdio.h>
   #include <math.h>
   #define YYSTYPE double
   int flag = 0;
%}

%token NUM
/*Defining the precedence*/
%left '|'
%left '&'
%left '!'
%left  '>' '<'
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

And   :  '&''&'
Or    :  '|''|'
Not   :  '!'

Expr  :  Expr And Expr  {$$ = $1 * $3;}
      |  Expr Or Expr   {if($1 == 1 || $2 == 1){$$ = 1;}else{$$ = 0;}}
      |  Not Expr       {if($2 == 1){$$ = 0;}else{$$ = 1;}}

Lsht  :  '<''<'
Rsht  :  '>''>'
Band  :  '&'
Bor   :  '|'
Bnot  :  '~'

Expr  :  Expr Lsht Expr {$$ = (int)$1 << (int)$3;}
      |  Expr Rsht Expr {$$ = (int)$1 >> (int)$3;}   
      |  Expr Band Expr {$$ = (int)$1 & (int)$3;}
      |  Expr Bor Expr  {$$ = (int)$1 | (int)$3;}
      |  Bnot Expr      {$$ = ~(int)$1;}
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
