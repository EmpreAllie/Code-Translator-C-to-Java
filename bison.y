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

int tablvl = 0;
char* gen_tabs();

%}


/* Token declarations */

%union{
	int number;
	char variable[64];
	char lexems[128];
	char nonterm[1024];
	char ops[4];
	char data[512];
}

%token<number> NUMBER 
%token<variable> TYPE NAME 
%token<lexems> PRINTF MAIN INT RETURN EXIT IF ELSE FOR
%token<data> STRING_LITERAL
%token<ops> OPAREN EPAREN OBRACE EBRACE SEMICOLON COMMA INCREMENT ASSIGN ADD_ASSIGN DIV_ASSIGN
%token<ops> EQUALS MORE LESS

%type<nonterm> prog rules rule_func func_decl body statements printf_expr expression func_call 
%type<nonterm> var_operation var_declar var_init var_assign
%type<nonterm> branching logical_expr logical_operator if_stmt elif_stmt else_stmt
%type<nonterm> loop for_loop var_assign_in_for

%start prog


/* Instructions */

%%

prog: 
	rules {
		fprintf(yyout, "class HelloWorld {\n");
		fprintf(yyout, "%s", $1);
		fprintf(yyout, "}\n");
	}
	;

rules:
	rule_func { tablvl++; char* tabs = gen_tabs(); sprintf($$, "%s%s\n", tabs, $1); free(tabs); tablvl--; } 
	|
	rules rule_func { 
		char* tabs = gen_tabs();
		sprintf($$, "%s\n%s%s", $1, tabs, $2); 
		free(tabs);
	}
	;

rule_func:
	func_decl OPAREN EPAREN OBRACE EBRACE {			
		sprintf($$, "%s\n%s", $1, $5); 
	}
  	|
	func_decl OPAREN EPAREN OBRACE body EBRACE { 
		tablvl--;
		sprintf($$, "%s %s\n%s%s", $1, $4, $5, $6);
	}
	;

func_decl:
	TYPE NAME { sprintf($$, "public %s %s() {\n", $1, $2); }
	|
	TYPE MAIN { sprintf($$, "public static void %s(String[] args)", $2); }
	;


body:
	statements { 
		tablvl++;
		char* tabs = gen_tabs();
		sprintf($$, "%s%s", tabs, $1);  
		free(tabs);
		tablvl--;
	}
	| 
	body statements { 
		tablvl++;
		char* tabs = gen_tabs();
		sprintf($$, "%s\n%s%s", $1, tabs, $2); 
		free(tabs);
		tablvl--;
	}
	;


statements: {tablvl++;}
	|
	func_call { 
//		tablvl++;
		char* tabs = gen_tabs();
		sprintf($$, "%s%s", tabs, $1); 
		free(tabs);
//		tablvl--;
	}
	|
	expression { 
//		tablvl++; 
		char* tabs = gen_tabs(); 
		sprintf($$, "%s%s", tabs, $1);
		free(tabs);
//		tablvl--;
	}
	|
	var_operation {
//		tablvl++; 
		char* tabs = gen_tabs(); 
		sprintf($$, "%s%s", tabs, $1);
		free(tabs);
//		tablvl--;
	}
	|
	branching {
//		tablvl++;
		char* tabs = gen_tabs(); 
		sprintf($$, "%s%s", tabs, $1);
		free(tabs);
	}
	|
	loop {
		char* tabs = gen_tabs(); 
		sprintf($$, "%s%s", tabs, $1);
		free(tabs);		
	}
	;

func_call:
	PRINTF OPAREN printf_expr EPAREN SEMICOLON { sprintf($$, "System.out.println%s%s%s%s", $2, $3, $4, $5); }
	|
	EXIT OPAREN expression EPAREN SEMICOLON { sprintf($$, ""); }
	|
	RETURN expression SEMICOLON { sprintf($$, "%s %s%s", $1, $2, $3); }
	;


var_operation:
	var_declar {sprintf($$, "%s", $1);}
	|
	var_init {sprintf($$, "%s", $1);}
	|
	var_assign {sprintf($$, "%s", $1);}
	;

var_declar:
	TYPE NAME SEMICOLON { sprintf($$, "%s %s%s", $1, $2, $3); }
	;

var_init:
	TYPE NAME ASSIGN expression SEMICOLON {sprintf($$, "%s %s %s %s%s", $1, $2, $3, $4, $5);}
	;

var_assign:
	NAME ASSIGN expression SEMICOLON {sprintf($$, "%s %s %s%s", $1, $2, $3, $4);}
	|
	NAME ADD_ASSIGN expression SEMICOLON {sprintf($$, "%s %s %s%s", $1, $2, $3, $4);}
	|
	NAME DIV_ASSIGN expression SEMICOLON {sprintf($$, "%s %s %s%s", $1, $2, $3, $4);}
	|
	NAME INCREMENT SEMICOLON { sprintf($$, "%s%s%s", $1, $2, $3); }	
	;

var_assign_in_for:
	NAME ADD_ASSIGN expression {sprintf($$, "%s %s %s", $1, $2, $3);}
	|
	NAME DIV_ASSIGN expression {sprintf($$, "%s %s %s", $1, $2, $3);}
	|
	NAME INCREMENT { sprintf($$, "%s%s", $1, $2); }	
	;



branching:
	if_stmt {sprintf($$, "%s", $1);}
	|
	elif_stmt {sprintf($$, "%s", $1);}
	|
	else_stmt {sprintf($$, "%s", $1);}
	;

if_stmt:
	IF OPAREN logical_expr EPAREN OBRACE body EBRACE {
//		tablvl++; 
		char* tabs = gen_tabs(); 
		sprintf($$, "%s %s%s%s %s\n%s\n%s%s", $1, $2, $3, $4, $5, $6, tabs, $7);
		free(tabs);
//		tablvl--; 
	}
	;

elif_stmt:
	ELSE IF OPAREN logical_expr EPAREN OBRACE body EBRACE {
        	sprintf($$, "%s %s %s%s%s %s\n%s\n%s", $1, $2, $3, $4, $5, $6, $7, $8);
	}
	;

else_stmt:
	ELSE OBRACE body EBRACE {
		sprintf($$, "%s %s\n%s\n%s", $1, $2, $3, $4);
	}
	;


loop:
	for_loop {
		sprintf($$, "%s", $1);
	}
	;

for_loop:
	FOR OPAREN var_init logical_expr SEMICOLON var_assign_in_for EPAREN OBRACE body EBRACE {
		sprintf($$, "%s %s%s %s%s %s%s %s\n%s\n%s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10);	
	}
	|
	FOR OPAREN var_assign logical_expr SEMICOLON var_assign_in_for EPAREN OBRACE body EBRACE {
		sprintf($$, "%s %s%s %s%s %s%s %s\n%s\n%s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10);	
	}

	;



logical_expr:
	expression logical_operator expression { sprintf($$, "%s %s %s", $1, $2, $3); }
	;

logical_operator:
	EQUALS {sprintf($$, "%s", $1);}
	|
	MORE {sprintf($$, "%s", $1);}
	|
	LESS {sprintf($$, "%s", $1);}
	;

expression:
	STRING_LITERAL { sprintf($$, "%s", $1); }	
	|
	NUMBER { sprintf($$, "%d", $1); };
	|
	NAME {sprintf($$, "%s", $1);}
	;

printf_expr: 
	expression { sprintf($$, "%s", $1); }
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

char* gen_tabs() {
	char* result = malloc(tablvl * sizeof(char) + 1);
	for (int i = 0; i < tablvl; i++)
		result[i]='\t';

	result[tablvl]='\0';
	return result;
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
