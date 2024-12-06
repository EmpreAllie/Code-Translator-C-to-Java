/* C part */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lex.yy.c"
 
extern FILE* yyin;
extern FILE* yyout;

int yylex();
void yyerror(char *str);
int yyparse(void);

int yydebug = 1;

%}

/* Token declarations */


%union{
	int number;
	char* variable;
	char* lexems;
	char* data;
	char nonterm[64];
	char single_chars[2];
}

%token<number> NUMBER 
%token<variable> TYPE NAME
%token<lexems> PRINTF MAIN INT RETURN
%token<data> OPAREN EPAREN OBRACE EBRACE SEMICOLON

%type<nonterm> prog rule rule_func func_decl body statements

%start prog


/* Instructions */

%%

prog: 
	rule {
		fprintf(yyout, "class HelloWorld {\n");
		fprintf(yyout, "\t%s", $1);
		fprintf(yyout, "}\n");
	}
	;

rule:
	rule_func {
		sprintf($$, "%s", $1); 
	}
	;

rule_func:
	func_decl OPAREN EPAREN OBRACE EBRACE {
		sprintf($$, "%s\n\t%s", $1, $5);
	}
  	|
	func_decl {
		sprintf($$, "%s", $1);
	}
	;

func_decl:
	TYPE NAME{
		sprintf($$, "private %s %s() {\n", $1, $2);
	}
	|
	TYPE MAIN OPAREN EPAREN OBRACE body EBRACE {
		/* Deleting '0' from 'return 0;' */
		printf("%s\n%s\n%s %s %s %s", $$, $1, $2, $3, $4, $5);
		if (strcmp($2, "main") == 0) {
			char* p = strstr($6, "return");
			if (p != NULL) {
				*(p + 7) = ' ';
			}		
		}
		sprintf($$, "private static void %s(String[] args) %s\n%s\n\t%s\n", $2, $5, $6, $7);	
	}
	;

body:
	statements {
		sprintf($$, "\t%s", $1);	
	}
	;

statements:
	RETURN NUMBER SEMICOLON {		
		sprintf($$, "\t%s %d%s", $1, $2, $3);
	}
	;

%%



/* C part (continued) */

int main()
{
	system("chcp 1251");
	yyin = fopen("source.c", "r");
	yyout = fopen("!output.java", "w");

	yyparse();

	fclose(yyin);
	fclose(yyout);
	return 0;
} 

void yyerror(char* s)
{
	fprintf (stderr, "line: %s\n", s);
}
