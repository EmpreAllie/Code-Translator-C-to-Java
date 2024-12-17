/* C part */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAB "\t"
 
extern FILE* yyin;
extern FILE* yyout;

int yylex();
void yyerror(char *str);
int yyparse(void);

int yydebug = 1;

int tablvl = 1;
char* gen_tabs();

%}


/* Token declarations */

%union{
	int intNumber;
	double floatNumber;
	char variable[64];
	char lexems[128];
	char nonterm[1024];
	char ops[4];
	char data[512];
}

%token<intNumber> NUMBER
%token<floatNumber> FLOAT_NUMBER

%token<variable> TYPE NAME 

%token<lexems> PRINTF PUTS MAIN RETURN EXIT IF ELSE FOR WHILE TRUE FALSE

%token<data> STRING_LITERAL

%token<ops> OPAREN EPAREN OBRACE EBRACE SEMICOLON COMMA POINT 
%token<ops> PLUS MINUS MULTIPLY DIVIDE MODULO
%token<ops> INCREMENT DECREMENT ASSIGN ADD_ASSIGN DIV_ASSIGN
%token<ops> EQUALS NEQUALS MORE LESS LESSEQUAL MOREEQUAL AND OR NOT

%type<nonterm> prog rules rule_func func_decl body statements printf_expr expression func_call 
%type<nonterm> var_operation var_declar var_init var_assign sign
%type<nonterm> branching logical_expr logical_operator if_stmt elif_stmt else_stmt
%type<nonterm> loop for_loop var_assign_in_for while_loop

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
		tablvl = 0;
		char* tabs = gen_tabs();
		sprintf($$, "%s %s\n%s\n%s%s", $1, $4, $5, tabs, $6);
		free(tabs);
	}
	;

func_decl:
	TYPE NAME { sprintf($$, "public %s %s() {\n", $1, $2); }
	|
	TYPE MAIN { sprintf($$, "public static void %s(String[] args)", $2); }
	;


body:
	statements { 
		char* tabs = gen_tabs();
		sprintf($$, "%s%s", tabs, $1);  
		free(tabs);
	}
	| 
	body statements {
		char* tabs = gen_tabs();
		sprintf($$, "%s\n%s%s", $1, tabs, $2); 
		free(tabs);
	}
	;


statements:
	|
	func_call { 
		char* tabs = gen_tabs();
		sprintf($$, "%s%s", tabs, $1); 
		free(tabs);
	}
	|
	expression { 
		char* tabs = gen_tabs(); 
		sprintf($$, "%s%s", tabs, $1);
		free(tabs);
	}
	|
	var_operation {
		char* tabs = gen_tabs(); 
		sprintf($$, "%s%s", tabs, $1);
		free(tabs);
	}
	|
	branching {
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
	PRINTF OPAREN printf_expr EPAREN SEMICOLON { sprintf($$, "System.out.print%s%s%s%s", $2, $3, $4, $5); }
	|
	PUTS OPAREN STRING_LITERAL EPAREN SEMICOLON { sprintf($$, "System.out.println%s%s%s%s", $2, $3, $4, $5); }
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
	TYPE NAME SEMICOLON { 
		if (strcmp($1, "bool") == 0) {
			sprintf($1, "boolean");
		}	
		sprintf($$, "%s %s%s", $1, $2, $3); 
	}
	;

var_init:
	TYPE NAME ASSIGN expression SEMICOLON {
		if (strcmp($1, "bool") == 0) {
			sprintf($1, "boolean");
		}				
		sprintf($$, "%s %s %s %s%s", $1, $2, $3, $4, $5);
	}
	;

var_assign:
	NAME ASSIGN expression SEMICOLON {sprintf($$, "%s %s %s%s", $1, $2, $3, $4);}
	|
	NAME ADD_ASSIGN expression SEMICOLON {sprintf($$, "%s %s %s%s", $1, $2, $3, $4);}
	|
	NAME DIV_ASSIGN expression SEMICOLON {sprintf($$, "%s %s %s%s", $1, $2, $3, $4);}
	|
	NAME INCREMENT SEMICOLON { sprintf($$, "%s%s%s", $1, $2, $3); }
	|
	NAME DECREMENT SEMICOLON { sprintf($$, "%s%s%s", $1, $2, $3); }	
	|
	INCREMENT NAME SEMICOLON { sprintf($$, "%s%s%s", $1, $2, $3); }
	|
	DECREMENT NAME SEMICOLON { sprintf($$, "%s%s%s", $1, $2, $3); }	
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
		tablvl++; 
		char* tabs = gen_tabs(); 
		sprintf($$, "%s %s%s%s %s\n%s\n%s%s", $1, $2, $3, $4, $5, $6, tabs, $7);
		free(tabs);
		tablvl--; 
	}
	;

elif_stmt:
	ELSE IF OPAREN logical_expr EPAREN OBRACE body EBRACE {
		tablvl++; 
		char* tabs = gen_tabs(); 
        	sprintf($$, "%s %s %s%s%s %s\n%s\n%s%s", $1, $2, $3, $4, $5, $6, $7, tabs, $8);
		free(tabs);
		tablvl--; 
	}
	;

else_stmt:
	ELSE OBRACE body EBRACE {
		tablvl++; 
		char* tabs = gen_tabs(); 
		sprintf($$, "%s %s\n%s\n%s%s", $1, $2, $3, tabs, $4);
		free(tabs);
		tablvl--; 
	}
	;


loop:
	for_loop {
		sprintf($$, "%s", $1);		
	}
	|
	while_loop {
		sprintf($$, "%s", $1);
	}
	;

for_loop:
	FOR OPAREN var_init logical_expr SEMICOLON var_assign_in_for EPAREN OBRACE body EBRACE {
		tablvl++; 
		char* tabs = gen_tabs(); 		
		sprintf($$, "%s %s%s %s%s %s%s %s\n%s\n%s%s", $1, $2, $3, $4, $5, $6, $7, $8, $9, tabs, $10);	
		free(tabs);
		tablvl--; 
	}
	|
	FOR OPAREN var_assign logical_expr SEMICOLON var_assign_in_for EPAREN OBRACE body EBRACE {
		tablvl++; 
		char* tabs = gen_tabs(); 		
		sprintf($$, "%s %s%s %s%s %s%s %s\n%s\n%s%s", $1, $2, $3, $4, $5, $6, $7, $8, $9, tabs, $10);	
		free(tabs);
		tablvl--; 
	}
	;

while_loop:
	WHILE OPAREN logical_expr EPAREN OBRACE body EBRACE {
		tablvl++; 
		char* tabs = gen_tabs(); 		
		sprintf($$, "%s %s%s%s %s\n%s\n%s%s", $1, $2, $3, $4, $5, $6, tabs, $7);
		free(tabs);
		tablvl--; 
	}
	;

logical_expr:
	logical_expr logical_operator logical_expr { sprintf($$, "%s %s %s", $1, $2, $3); }
	|
	expression logical_operator expression { sprintf($$, "%s %s %s", $1, $2, $3); }
	|
	expression {sprintf($$, "%s", $1);}
	;

logical_operator:
	EQUALS {sprintf($$, "%s", $1);}
	|
	MORE {sprintf($$, "%s", $1);}
	|
	LESS {sprintf($$, "%s", $1);}
	|
	LESSEQUAL {sprintf($$, "%s", $1);}
	|
	MOREEQUAL {sprintf($$, "%s", $1);}
	|
	AND {sprintf($$, "%s", $1);}
	|
	OR {sprintf($$, "%s", $1);}
	;

expression:
	STRING_LITERAL { sprintf($$, "%s", $1); }	
	|
	NUMBER { sprintf($$, "%d", $1); }
	|
	FLOAT_NUMBER { sprintf($$, "%.3lf", $1); }
	|
	NAME { sprintf($$, "%s", $1); }
	|
	TRUE { sprintf($$, "%s", $1); }
	|
	FALSE { sprintf($$, "%s", $1); }
	|
	expression sign expression { sprintf($$, "%s %s %s", $1, $2, $3); }
	|
	NOT expression {sprintf($$, "%s%s", $1, $2);}
	|
	OPAREN expression EPAREN {sprintf($$, "%s%s%s", $1, $2, $3);}
	;

sign:
	PLUS { sprintf($$, "%s", $1); }
	|
	MINUS { sprintf($$, "%s", $1); }
	|
	MULTIPLY { sprintf($$, "%s", $1); }
	|
	DIVIDE { sprintf($$, "%s", $1); }
	|
	MODULO { sprintf($$, "%s", $1); }
	
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
	char* result = calloc(tablvl, sizeof(char));
	for (int i = 0; i < tablvl; i++)
		result[i]='\t';

//	result[tablvl]='\0';
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
