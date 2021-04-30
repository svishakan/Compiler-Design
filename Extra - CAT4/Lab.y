%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>

    //Redefine the inbuilt yyfunctions
    int yyerror(char *);
    int yylex(void);
    int yywrap();

    //Keep track of counts
    int labelCounter(){
        static int labels = 0;
        return labels++;
    }    

    int varCounter(){
        static int variables = 0;
        return variables++;
    }

    //Node to keep track of ICG, Optimized Code and ASM
    typedef struct Node{
        int intval;
        float fltval;
        char *code;
        char *optcode;
        char *tac;
        char *opttac;
        char *gen;
    }Node;

    Node *makeNode(){
        Node *n = (Node *)malloc(sizeof(Node));
        n->intval = 0;
        n->fltval = 0.0;
        n->code = (char *)malloc(sizeof(char) * 1024);
        n->optcode = (char *)malloc(sizeof(char) * 1024);
        n->tac = (char *)malloc(sizeof(char) * 1024);
        n->opttac = (char *)malloc(sizeof(char) * 1024);
        n->gen = (char *)malloc(sizeof(char) * 1024);
        
        return n;
    }
    
%}

%union{
    int intval;
    float fltval;
    char *str;
    struct Node* node;
}

/*
Precedence ^ is lesser priority than + , -, *, /
Associativity + and - left , * and / right
*/

/* %right '^'
%right '*' '/'
%left '+' '-' */

%token <str> ID
%token <intval> INT
%token <fltval> FLOAT
%type <node> Code Block Stmts Stmt Assign Expr E T F

%%
Code    :   Block{
                printf("\n---INPUT CODE---\n");
                system("cat code.txt");
                printf("\n---SYNTAX CHECK---\n");
                printf("\nSyntactically Correct.\n");
                printf("\n---TAC CODE---\n");
                printf("\n%s\n", $1->tac);
                printf("\n---OPTIMIZED CODE---\n");
                printf("\n%s\n", $1->opttac);
                printf("\n---MACHINE CODE---\n");
                printf("\n%s\n", $1->gen);


            }
        ;

Block   :   Stmts{
                $$ = $1;
            }   
        ;

Stmts   :   Stmt Stmts{
                $$ = makeNode();
                sprintf($$->tac, "%s%s", $1->tac, $2->tac);
                sprintf($$->opttac, "%s%s", $1->opttac, $2->opttac);
                sprintf($$->gen, "%s%s", $1->gen, $2->gen);
            }
        
        |   Stmt{
                $$ = $1;
            }
        ;

Stmt    :   Assign '\n'{
                $$ = $1;
            }
        ;

Assign  :   ID '=' Expr{
                $$ = makeNode();
                sprintf($$->code, "%s", $1);
                char temp[100], asmcode[100];
                sprintf(temp, "%s := %s\n", $$->code, $3->code);
                sprintf(asmcode, "MOV %s, R0\nMOV R0, %s\n", $3->code, $$->code);

                sprintf($$->tac, "%s%s", $3->tac, temp);
                sprintf($$->opttac, "%s%s", $3->opttac, temp);
                sprintf($$->gen, "%s%s", $3->gen, asmcode);
            }
        ;

Expr    :   E{
                $$ = $1;
            }
        ;

E       :   E '+' T{
                $$ = makeNode();
                int vc = varCounter();
                sprintf($$->code, "T%d", vc);
                char temp[100], asmcode[100];
                sprintf(temp, "%s = %s + %s\n", $$->code, $1->code, $3->code);

                float v1, v2;

                if (v1 = strtof($1->code, NULL)){
                    if(v2 = strtof($3->code, NULL)){
                        v1 = v1 + v2;
                        sprintf($$->opttac, "%s = %.2f\n", $$->code, v1);
                        sprintf(asmcode, "MOV #%2.f, R0\n", v1);     
                    }
                    else{
                        sprintf($$->opttac, "%s%s%s", $1->tac, $3->tac, temp);
                        sprintf(asmcode, "MOV %s, R0\nADD %s, R0\nMOV R0, %s\n", $1->code, $3->code, $$->code);
                    }
                }
                else{
                    sprintf($$->opttac, "%s%s%s", $1->tac, $3->tac, temp);
                    sprintf(asmcode, "MOV %s, R0\nADD %s, R0\nMOV R0, %s\n", $1->code, $3->code, $$->code);
                }

                sprintf($$->tac, "%s%s%s", $1->tac, $3->tac, temp);
                sprintf($$->gen, "%s%s%s", $1->gen, $3->gen, asmcode);
            }
        
        |   E '-' T{
                $$ = makeNode();
                int vc = varCounter();
                sprintf($$->code, "T%d", vc);
                char temp[100], asmcode[100];
                sprintf(temp, "%s = %s - %s\n", $$->code, $1->code, $3->code);

                float v1, v2;

                if (v1 = strtof($1->code, NULL)){
                    if(v2 = strtof($3->code, NULL)){
                        v1 = v1 - v2;
                        sprintf($$->opttac, "%s = %.2f\n", $$->code, v1);  
                        sprintf(asmcode, "MOV #%2.f, R0\n", v1);       
                    }
                    else{
                        sprintf($$->opttac, "%s%s%s", $1->tac, $3->tac, temp);
                        sprintf(asmcode, "MOV %s, R0\nSUB %s, R0\nMOV R0, %s\n", $1->code, $3->code, $$->code);
                    }
                }
                else{
                    sprintf($$->opttac, "%s%s%s", $1->tac, $3->tac, temp);
                    sprintf(asmcode, "MOV %s, R0\nSUB %s, R0\nMOV R0, %s\n", $1->code, $3->code, $$->code);
                }

                sprintf($$->tac, "%s%s%s", $1->tac, $3->tac, temp);
                sprintf($$->gen, "%s%s%s", $1->gen, $3->gen, asmcode);
            }
        
        |   T{
                $$ = $1;
            }
        ;

T       :   F '*' T{
                $$ = makeNode();
                int vc = varCounter();
                sprintf($$->code, "T%d", vc);
                char temp[100], asmcode[100];
                sprintf(temp, "%s = %s * %s\n", $$->code, $1->code, $3->code);

                float v1, v2;

                if (v1 = strtof($1->code, NULL)){
                    if(v2 = strtof($3->code, NULL)){
                        v1 = v1 * v2;
                        sprintf($$->opttac, "%s = %.2f\n", $$->code, v1);  
                        sprintf(asmcode, "MOV #%2.f, R0\n", v1);    
                    }
                    else{
                        sprintf($$->opttac, "%s%s%s", $1->tac, $3->tac, temp);
                        sprintf(asmcode, "MOV %s, R0\nMUL %s, R0\nMOV R0, %s\n", $1->code, $3->code, $$->code);
                    }
                }
                else{
                    sprintf($$->opttac, "%s%s%s", $1->tac, $3->tac, temp);
                    sprintf(asmcode, "MOV %s, R0\nMUL %s, R0\nMOV R0, %s\n", $1->code, $3->code, $$->code);
                    
                }

                sprintf($$->tac, "%s%s%s", $1->tac, $3->tac, temp);
                sprintf($$->gen, "%s%s%s", $1->gen, $3->gen, asmcode);
            }
        
        |   F '/' T{
                $$ = makeNode();
                int vc = varCounter();
                sprintf($$->code, "T%d", vc);
                char temp[100], asmcode[100];
                sprintf(temp, "%s = %s / %s\n", $$->code, $1->code, $3->code);

                float v1, v2;

                if (v1 = strtof($1->code, NULL)){
                    if(v2 = strtof($3->code, NULL)){
                        v1 = v1 / v2;
                        sprintf($$->opttac, "%s = %.2f\n", $$->code, v1);
                        sprintf(asmcode, "MOV #%2.f, R0\n", v1);        
                    }
                    else{
                        sprintf($$->opttac, "%s%s%s", $1->tac, $3->tac, temp);
                        sprintf(asmcode, "MOV %s, R0\nDIV %s, R0\nMOV R0, %s\n", $1->code, $3->code, $$->code);
                    }
                }
                else{
                    sprintf($$->opttac, "%s%s%s", $1->tac, $3->tac, temp);
                    sprintf(asmcode, "MOV %s, R0\nDIV %s, R0\nMOV R0, %s\n", $1->code, $3->code, $$->code);
                }

                sprintf($$->tac, "%s%s%s", $1->tac, $3->tac, temp);
                sprintf($$->gen, "%s%s%s", $1->gen, $3->gen, asmcode);
            }
        
        |   F '^' T{
                $$ = makeNode();
                int vc = varCounter();
                sprintf($$->code, "T%d", vc);
                char temp[100], asmcode[100];
                sprintf(temp, "%s = %s ^ %s\n", $$->code, $1->code, $3->code);

                float v1, v2;

                if (v1 = strtof($1->code, NULL)){
                    if(v2 = strtof($3->code, NULL)){
                        v1 = pow(v1, v2);
                        sprintf($$->opttac, "%s = %.2f\n", $$->code, v1);
                        sprintf(asmcode, "MOV #%2.f, R0\n", v1);         
                    }
                    else{
                        sprintf($$->opttac, "%s%s%s", $1->tac, $3->tac, temp);
                        sprintf(asmcode, "MOV %s, R0\nPOW %s, R0\nMOV R0, %s\n", $1->code, $3->code, $$->code);
                        
                    }
                }
                else{
                    sprintf($$->opttac, "%s%s%s", $1->tac, $3->tac, temp);
                    sprintf(asmcode, "MOV %s, R0\nPOW %s, R0\nMOV R0, %s\n", $1->code, $3->code, $$->code);
                }

                sprintf($$->tac, "%s%s%s", $1->tac, $3->tac, temp);
                sprintf($$->gen, "%s%s%s", $1->gen, $3->gen, asmcode);
            }
        
        |   F{
                $$ = $1;
            }
        ;

F       :   INT{
                $$ = makeNode();
                sprintf($$->code, "%d", $1);
                sprintf($$->tac, "");
                sprintf($$->opttac, "");
                sprintf($$->gen, "");
            }
        
        |   FLOAT{
                $$ = makeNode();
                sprintf($$->code, "%.2f", $1);
                sprintf($$->tac, "");
                sprintf($$->opttac, "");
                sprintf($$->gen, "");
            }
        
        |   ID{
                $$ = makeNode();
                sprintf($$->code, "%s", $1);
                sprintf($$->tac, "");
                sprintf($$->opttac, "");
                sprintf($$->gen, "");
            }
        ;

%%

int yyerror(char *error){
    fprintf(stderr, "\nError: %s\n", error);
    return 0;
}

int yywrap(){
    return 1;
}

int main(){
    printf("\n---Compiler Design: CAT 4---\n");
    yyparse();
    return 0;
}

