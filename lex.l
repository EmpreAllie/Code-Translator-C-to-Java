/* C  part */
%{
#include <stdio.h>
#include <string.h>
#include "bison.tab.h"
%}
       

/* RegExes and Tokens */ 
%%

#include.*			{ ; }

"int"				{ yylval.variable = strdup(yytext); return TYPE; }
"main"				{ yylval.lexems = strdup(yytext); return MAIN; }
"return"			{ yylval.lexems = strdup(yytext); return RETURN; }
"printf"			return PRINTF;

[0-9]+				{ yylval.number = atoi(yytext); return NUMBER; }
[_a-zA-Z][_a-zA-Z0-9]*          { strcpy(yylval.variable, yytext); return NAME; }
[ \t\r\n]      			{ ; }

"("				{ yylval.data = strdup(yytext); return OPAREN; }
")"				{ yylval.data = strdup(yytext); return EPAREN; }
"{"				{ yylval.data = strdup(yytext); return OBRACE; }
"}"				{ yylval.data = strdup(yytext); return EBRACE; }
";"				{ yylval.data = strdup(yytext); return SEMICOLON; }

%%



/* Other C code */

int yywrap() {return 1;}