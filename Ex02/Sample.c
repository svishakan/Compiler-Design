#include<stdio.h>
#include<stdlib.h>

int main(){
    int a = 1, b;
    int c = 2;
    char d, e = 'Z';
    float f = 1.23;

    printf("Hello to %d", c);
    
    a = b + 100;

    if (c > 100){
        printf("Greater");
    }

    while (c > 0) {
        printf("Hello to Lex!");
        c -= 1;
    }


    //a is GREATER than b!
    /* Multi-line 
    comment */

    return 0;
}
