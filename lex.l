/* Cu part */
%{
#include <stdio.h>
#include <string.h>
#include "bison.tab.h"
%}
       

/* RegExes and Tokens */ 
%%

#include.*			{  }

"int"				{ strcpy(yylval.variable, yytext); return TYPE; }
"main"				{ strcpy(yylval.lexems, yytext); return MAIN; }
"return"			{ strcpy(yylval.lexems, yytext); return RETURN; }
"printf"			return PRINTF;
"exit"				return EXIT;

[0-9]+				{ yylval.number = atoi(yytext); return NUMBER; }
[_a-zA-Z][_a-zA-Z0-9]*          { strcpy(yylval.variable, yytext); return NAME; }
[ \t\r\n]      			{  }

"("				{ strcpy(yylval.single_chars, yytext); return OPAREN; }
")"				{ strcpy(yylval.single_chars, yytext); return EPAREN; }
"{"				{ strcpy(yylval.single_chars, yytext); return OBRACE; }
"}"				{ strcpy(yylval.single_chars, yytext); return EBRACE; }
";"				{ strcpy(yylval.single_chars, yytext); return SEMICOLON; }

["][^"].*["]			{ strcpy(yylval.data, yytext); return STRING_LITERAL; }

%%



/* Other C code */

int yywrap() {return 1;}