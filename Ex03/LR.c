#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
    /*
        Sample Input Format:    E->E+T|T
                                T->T*F|F
                                F->i
    */
   
    char productions[100][100], sub_prods[100][100];
    char non_terminal;
    int num_prods, i, j, k, flag = 0;

    printf("\n\t\tElimination of Left Recursion\n");
    printf("\nEnter the number of Productions: ");
    scanf("%d", &num_prods);

    printf("\nEnter the Grammar:\n");

    for(i = 0; i < num_prods; i++){
        //Getting Input
        scanf("%s", productions[i]);
    }

    printf("\nGiven Grammar:\n");

    for(i = 0; i < num_prods; i++){
        //Printing the Grammar, and checking for left recursions
        printf("%s\n", productions[i]);

        if(productions[i][0] == productions[i][3]){
            flag = 1;
        }
    }

    if(flag == 0){
        //If Grammar is not left recursive, exit
        printf("\nGrammar is not Left Recursive.");
        return 0;
    }

    //Otherwise, Grammar is left recursive, parse and remove it
    printf("\nGrammar is Left Recursive.");
    printf("\n\nGrammar after removal of Left Recursion:");

    for(i = 0; i < num_prods; i++){
        //Parse each production one by one
        non_terminal = productions[i][0];
        
        char *split, production[100];
        flag = 0;

        //Store the RHS of the production alone
        for(j = 0; productions[i][j + 3] != '\0'; j++){
            production[j] = productions[i][j + 3];
        }

        production[j] = '\0';
        j = 0;

        //Split at the sub-expression level when there is an OR operator
        split = strtok(production, "|");

        while(split != NULL){
            //Store the subexpression in a new productions array
            strcpy(sub_prods[j], split);

            if(split[0] == non_terminal && flag == 0){
                //Seeing an immediate left recursion, with no other productions
                //for the same non-terminal
                //This type of Left Recursion cannot be removed
                flag = 1;
            }
            else if(split[0] != non_terminal && flag == 1){
                //Already seen a left recursion, but now we have seen 
                //another production with some terminal symbol 
                //for the same non-terminal
                flag = 2;
            }

            j++;
            split = strtok(NULL, "|");
            //split and loop till all productions are parsed
        }

        if(flag != 2){
            //flag == 0 => no LR
            //flag == 1 => LR of the form A->Ab which cannot be removed 
            printf("%s\n", productions[i]);
        }

        if(flag == 2){
            //Remove the left recursion if there's another production with terminal symbol
            printf("\n");
            flag = 0;
            
            for(k = 0; k < j; k++){
                if(sub_prods[k][0] != non_terminal){
                    //Loop until the non-terminal causing the LR is not found, for 1st production rule
                    if(flag != 0){
                        //Removed the LR by starting with the other non-terminal/ID,
                        //thus add the remaining sub-productions
                        printf("|%s%c\'", sub_prods[k], non_terminal);
                    }
                    else{
                        //No left recursion with that particular sub-production
                        //thus make it as a new production with a new non-terminal
                        flag = 1;
                        printf("%c->%s%c\'", non_terminal, sub_prods[k], non_terminal);
                    }
                }
            }
            printf("\n");
            flag = 0;
            
            for(k = 0; k < j; k++){
                if(sub_prods[k][0] == non_terminal){
                    //Loop until the non-terminal causing the LR is found, for 2nd production rule
                    if(flag != 0){
                        //Add the remaining sub-productions, since the LR has been removed
                        printf("|%s%c\'", sub_prods[k] + 1, non_terminal);
                    }
                    else{
                        //k sub-production contains the LR causing term, thus first print the
                        //next sub-production followed by a new non-terminal as a new production
                        //2D Array Manipulation, sub_prods[k] + 1 essentially prints 
                        //the string sub_prods[k][1] till sub_prods[k][n]
                        flag = 1;
                        printf("%c\'->%s%c\'", non_terminal, sub_prods[k] + 1, non_terminal);
                    }
                }
            }
            printf("|e\n");
        }

    }


    return 0;
}

/*
OUTPUT:

gcc LR.c -o l -w
./l             

		Elimination of Left Recursion

Enter the number of Productions: 3

Enter the Grammar:
E->E+T|T
T->T*F|F
F->i

Given Grammar:
E->E+T|T
T->T*F|F
F->i

Grammar is Left Recursive.

Grammar after removal of Left Recursion:
E->TE'
E'->+TE'|e

T->FT'
T'->*FT'|e
F->i

*/