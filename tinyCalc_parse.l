/* Name: Samreet Kaur
   Date: Mar 11, 2025
   CSCI 3415 - 001 */

%{
#include "calc.tab.h"
#include <stdio.h>
%}

%%

[0-9]+(\.[0-9]+)?  { yylval.num = atof(yytext); return NUM; }
[+]                { return PLUS; }
[-]                { return MINUS; }
[*]                { return TIMES; }
[/]                { return DIVIDE; }
\^                 { return EXP; }
\(                 { return OPENPAREN; }
\)                 { return CLOSEPAREN; }
=                  { return ASSIGN; }  
[ \t]              { /* skip whitespace */ }
[A-Za-z][A-Za-z0-9]* { yylval.str = strdup(yytext); return VAR; }
\n                 { return '\n'; }

%%

int yywrap(void) {
    return 1;
}
