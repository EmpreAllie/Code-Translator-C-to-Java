/* Cu part */
%{
#include <stdio.h>
#include <string.h>
#include "bison.tab.h"
%}
       

/* RegExes and Tokens */ 
%%

#include.*			{  }

"int"|"double"			{ strcpy(yylval.variable, yytext); return TYPE; }

"main"				{ strcpy(yylval.lexems, yytext); return MAIN; }
"return"			{ strcpy(yylval.lexems, yytext); return RETURN; }
"printf"			return PRINTF;
"exit"				return EXIT;
"if"				{ strcpy(yylval.lexems, yytext); return IF; }
"else"				{ strcpy(yylval.lexems, yytext); return ELSE; }
"for"				{ strcpy(yylval.lexems, yytext); return FOR; }

[0-9]+				{ yylval.number = atoi(yytext); return NUMBER; }
[_a-zA-Z][_a-zA-Z0-9]*          { strcpy(yylval.variable, yytext); return NAME; }
[ \t\r\n]      			{  }

"("				{ strcpy(yylval.ops, yytext); return OPAREN; }
")"				{ strcpy(yylval.ops, yytext); return EPAREN; }
"{"				{ strcpy(yylval.ops, yytext); return OBRACE; }
"}"				{ strcpy(yylval.ops, yytext); return EBRACE; }
";"				{ strcpy(yylval.ops, yytext); return SEMICOLON; }
","				{ strcpy(yylval.ops, yytext); return COMMA; }
"="				{ strcpy(yylval.ops, yytext); return ASSIGN; }
"+="				{ strcpy(yylval.ops, yytext); return ADD_ASSIGN; }
"/="				{ strcpy(yylval.ops, yytext); return DIV_ASSIGN; }
"++"				{ strcpy(yylval.ops, yytext); return INCREMENT; }
"=="				{ strcpy(yylval.ops, yytext); return EQUALS; }
">"				{ strcpy(yylval.ops, yytext); return MORE; }
"<"				{ strcpy(yylval.ops, yytext); return LESS; }


["][^"].*["]			{ strcpy(yylval.data, yytext); return STRING_LITERAL; }

%%



/* Other C code */

int yywrap() {return 1;}