/* Cu part */
%{
#include <stdio.h>
#include <string.h>
#include "bison.tab.h"
%}
       

/* RegExes and Tokens */ 
%%

#include.*				{  }

"int"|"double"|"float"|"bool"|"char"|"void" { strcpy(yylval.variable, yytext); return TYPE; }

"main"					{ strcpy(yylval.lexems, yytext); return MAIN; }
"return"				{ strcpy(yylval.lexems, yytext); return RETURN; }
"printf"				return PRINTF;
"puts"					return PUTS;
"exit"					return EXIT;
"if"					{ strcpy(yylval.lexems, yytext); return IF; }
"else"					{ strcpy(yylval.lexems, yytext); return ELSE; }
"for"					{ strcpy(yylval.lexems, yytext); return FOR; }
"while"					{ strcpy(yylval.lexems, yytext); return WHILE; }
"true"					{ strcpy(yylval.lexems, yytext); return TRUE; }
"false"					{ strcpy(yylval.lexems, yytext); return FALSE; }

[0-9]+					{ yylval.intNumber = atoi(yytext); return NUMBER; }
[0-9]+\.[0-9]+				{ yylval.floatNumber = atof(yytext); return FLOAT_NUMBER; }
[_a-zA-Z][_a-zA-Z0-9]*         	 	{ strcpy(yylval.variable, yytext); return NAME; }
[ \t\r\n]      				{  }

"("					{ strcpy(yylval.ops, yytext); return OPAREN; }
")"					{ strcpy(yylval.ops, yytext); return EPAREN; }
"{"					{ strcpy(yylval.ops, yytext); return OBRACE; }
"}"					{ strcpy(yylval.ops, yytext); return EBRACE; }
";"					{ strcpy(yylval.ops, yytext); return SEMICOLON; }
","					{ strcpy(yylval.ops, yytext); return COMMA; }
"."					{ strcpy(yylval.ops, yytext); return POINT; }

"="					{ strcpy(yylval.ops, yytext); return ASSIGN; }
"+="					{ strcpy(yylval.ops, yytext); return ADD_ASSIGN; }
"/="					{ strcpy(yylval.ops, yytext); return DIV_ASSIGN; }
"++"					{ strcpy(yylval.ops, yytext); return INCREMENT; }
"--"					{ strcpy(yylval.ops, yytext); return DECREMENT; }

"+"                                     { strcpy(yylval.ops, yytext); return PLUS; }
"-"                                     { strcpy(yylval.ops, yytext); return MINUS; }
"*"                                     { strcpy(yylval.ops, yytext); return MULTIPLY; }
"/"                                     { strcpy(yylval.ops, yytext); return DIVIDE; }
"%"                                     { strcpy(yylval.ops, yytext); return MODULO; }

"=="					{ strcpy(yylval.ops, yytext); return EQUALS; }
"!="					{ strcpy(yylval.ops, yytext); return NEQUALS; }
">"					{ strcpy(yylval.ops, yytext); return MORE; }
"<"					{ strcpy(yylval.ops, yytext); return LESS; }
"<="					{ strcpy(yylval.ops, yytext); return LESSEQUAL; }
">="					{ strcpy(yylval.ops, yytext); return MOREEQUAL; }
"&&"					{ strcpy(yylval.ops, yytext); return AND; }
"||"					{ strcpy(yylval.ops, yytext); return OR; }
"!"					{ strcpy(yylval.ops, yytext); return NOT; }

["][^"].*["]				{ strcpy(yylval.data, yytext); return STRING_LITERAL; }

%%



/* Other C code */

int yywrap() {return 1;}