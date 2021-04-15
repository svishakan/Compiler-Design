%{
    #include <stdio.h>
    #define YYSTYPE struct info*
    void yyerror();    

    struct info{
        int c;
        char var[100];
        char *code;
    };

    struct info temp;
    int flag = 0;
    int count = 0;

%}

%token NUM ID

/* Associativity */
%right '/' '*'
%left '+' '-' '%'

%%
S   :   E   {}
E   :   E '+' E {char *t ="";}
    |   ID '=' NUM {printf("\n%s = %d", $1, $2);}
    |   NUM {temp.c = $1; $$ = &temp; printf("temp = %ld\n $$ = %ld", &temp, $$);}
%%

void yyerror(){
    flag = 1;
    return;
}

int main(){
    printf("\n\t\tIntermediate Code Generation\n");
    yyparse();
    return 0;
}

