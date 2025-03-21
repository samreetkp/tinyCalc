/* Name: Samreet Kaur
   Date: Mar 11, 2025
   CSCI 3415 - 001 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
extern int yylex(void);
void yyerror(const char *s);

#define MAX_VARS 100

typedef struct {
    char name[64];
    double value;
} Variable;

Variable variables[MAX_VARS];
int num_vars = 0;
int error_occurred = 0;
int calc_count = 1;  // Counter for calculations

double get_variable_value(const char* name) {
    for (int i = 0; i < num_vars; i++) {
        if (strcmp(variables[i].name, name) == 0) {
            return variables[i].value;
        }
    }
    return NAN; // Variable not found
}

void set_variable_value(const char* name, double value) {
    for (int i = 0; i < num_vars; i++) {
        if (strcmp(variables[i].name, name) == 0) {
            variables[i].value = value;
            return;
        }
    }
    if (num_vars < MAX_VARS) {
        strcpy(variables[num_vars].name, name);
        variables[num_vars].value = value;
        num_vars++;
    }
}
%}

%union {
    double num;
    char* str;
}

%type <num> expr line
%token <num> NUM
%token PLUS MINUS TIMES DIVIDE EXP OPENPAREN CLOSEPAREN ASSIGN
%token <str> VAR

%left PLUS MINUS
%left TIMES DIVIDE
%left EXP
%right UMINUS UPLUS

%%

input:
    | input line
    ;

line:
    expr '\n' { 
        printf("= %.10g\n\n", $1); 
        printf("[%d] ", ++calc_count);  // Increment and print the calculation number
    }
    | VAR ASSIGN expr '\n'  { 
        if (!error_occurred && !isnan($3)) {  // Check if no error and result is valid
            set_variable_value($1, $3); 
            printf("Variable %s is assigned to %.10g.\n\n", $1, $3);
        }
        free($1);
        error_occurred = 0;  // Reset error flag
        printf("[%d] ", ++calc_count);  // Increment and print the calculation number
    }
    | error '\n' { 
        yyerrok; 
        error_occurred = 0;  
        printf("[%d] ", ++calc_count);
    }
    ;

expr:
      NUM                     { $$ = $1; }
    | VAR { 
        $$ = get_variable_value($1); 
        if (isnan($$)) { 
            fprintf(stderr, "Error: Variable '%s' not found!\n\n", $1); 
            error_occurred = 1; 
        } 
    }
    | expr PLUS expr          { $$ = $1 + $3; }
    | expr MINUS expr         { $$ = $1 - $3; }
    | expr TIMES expr         { $$ = $1 * $3; }
    | expr DIVIDE expr        { 
        if ($3 == 0) { 
            yyerror("divide by zero !!"); 
            error_occurred = 1;  // Set error flag
            $$ = NAN;  // Return NaN
        } else {
            $$ = $1 / $3; 
        }
    }
    | expr EXP expr           { $$ = pow($1, $3); }
    | OPENPAREN expr CLOSEPAREN { $$ = $2; }
    | MINUS expr %prec UMINUS { $$ = -$2; }
    | PLUS expr %prec UPLUS   { $$ = $2; }
    ;

%%

int main(void) {
    printf("Enter any Arithmetic Expression or Assignment Statement. Press ^D to exit.\n\n");
    printf("[%d] ", calc_count);  // Print first calculation prompt
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n\n", s);
}
