/* C part */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 
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
	char variable[64];
	char lexems[128];
	char nonterm[64];
	char single_chars[2];
	char data[512];
}

%token<number> NUMBER 
%token<variable> TYPE NAME 
%token<lexems> PRINTF MAIN INT RETURN EXIT
%token<data> OPAREN EPAREN OBRACE EBRACE SEMICOLON STRING_LITERAL

%type<nonterm> prog rules rule_func func_decl body statements printf_expr expression func_call

%start prog


/* Instructions */

%%

prog: 
	rules {
		fprintf(yyout, "class HelloWorld {\n");
		fprintf(yyout, "\t%s", $1);
		fprintf(yyout, "}\n");
	}
	;

rules:
	rule_func { sprintf($$, "%s\n", $1); } 
	|
	rules rule_func { sprintf($$, "%s\n%s", $1, $2); }
	;

rule_func:
	func_decl OPAREN EPAREN OBRACE EBRACE {	sprintf($$, "%s\n\t%s", $1, $5); }
  	|
	func_decl OPAREN EPAREN OBRACE body EBRACE { sprintf($$, "%s %s\n%s\n\n%s\n", $1, $4, $5, $6); }
	;

func_decl:
	TYPE NAME { sprintf($$, "public %s %s() {\n", $1, $2); }
	|
	TYPE MAIN { sprintf($$, "public static void %s(String[] args)", $2); }
	;


body:
	statements { sprintf($$, "\t%s", $1);  }
	| 
	body statements { sprintf($$, "%s\n%s", $1, $2); }
	;


statements:
	func_call { sprintf($$, "%s", $1); }
	|
	expression { sprintf($$, "\t%s", $1); }
	;

func_call:
	PRINTF OPAREN printf_expr EPAREN SEMICOLON { sprintf($$, "System.out.println%s%s%s%s\n", $2, $3, $4, $5); }
	|
	EXIT OPAREN expression EPAREN SEMICOLON { }
	|
	RETURN expression SEMICOLON { sprintf($$, "\t%s %s%s", $1, $2, $3); }
	;


printf_expr: 
	expression { sprintf($$, "%s", $1); }
	;

expression:
	STRING_LITERAL { sprintf($$, "%s", $1); }	
	|
	NUMBER { sprintf($$, "%d", $1); };		

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


		/* Deleting '0' from 'return 0;' */
/*		if (strcmp($2, "main") == 0) {
			char* p = strstr($6, "return");
			if (p != NULL) {
				*(p + 7) = ' ';
			}		
		}
*/
