%{
    #include <stdio.h>
    #define YYSTYPE double
    int flag = 0;
%}

%token  NUM ASSIGN ID
%token  RELOP LOGIC ARITH INCDEC
%token  IF ELIF ELSE
%token  FOR WHILE

%%
Lines   :   Block Lines
        |   Block
        ;

Block   :   Stmt Block
        |   Stmt
        ;

Stmt    :   Loop '{' Block '}'
        |   ConStmt '{' Block '}'
        |   Expr ';'

Loop    :   FOR '(' Expr ';' Condns ';' Expr ')'
        |   FOR '(' ';' Condns ';' ')'
        |   WHILE '(' Condns ')'
        ;

ConStmt :   IF '(' Condns ')'
        |   ELIF '(' Condns ')'
        |   ELSE
        ;

Condns  :   Condn LOGIC Condns          
        |   Condn                       
        ;

Condn   :   ID RELOP ID
        |   ID RELOP NUM
        |   ID
        ;

Expr    :   Init              
        |   ID ASSIGN ID ARITH ID       
        |   ID ASSIGN ID ARITH NUM      
        |   ID ASSIGN NUM ARITH NUM     
        |   ID INCDEC                   
        |   INCDEC ID                               
        ;

Init    :   ID ASSIGN Init
        |   ID ASSIGN ID
        |   ID ASSIGN NUM
        ;
%%

int yyerror(char *s){
    flag = 1;
    //fprintf(stderr, "%s\n", s);
    return 1;
}

int main(void){
    printf("\n\n\t\tSYNTAX CHECKER USING YACC\n");
    printf("\nNote: Enter the code snippet in Code.txt.\n");
    printf("\nCode Obtained:\n\n");
    system("cat Code.txt");
    yyparse();

    if(flag){
        printf("\nSyntactically Incorrect.\n");
    }
   
    else{
        printf("\nSyntactically Correct.\n");
    }

    return 0;
}

/* Usage:
        Run yacc -d Check.y
        Run lex Check.l
        Run gcc lex.yy.c -lm -w
        Run ./a.out < Code.txt
*/