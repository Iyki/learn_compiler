/*
A grammar that has a shift-reduce conflict and it is resolved 
by defining precedence using %nonassoc and %pred.
*/
%{
#include <stdio.h>
extern int yylex();
extern int yylex_destroy();
extern int yywrap();
int yyerror(char *);
extern FILE *yyin;
%}

%token NAME NUM
%nonassoc NUM
%nonassoc TAG
%start scores
%%
scores : scores score
				|score
score	 : NAME ':' NUM ':'| NUM ':' | NAME ':' %prec TAG
%%
int main(int argc, char** argv){
	if (argc == 2){
  	yyin = fopen(argv[1], "r");
		yyparse();
  	fclose(yyin);
	}
	yylex_destroy();
	
	return 0;
}

int yyerror(char * message){
	fprintf(stderr, "%s\n", message);
}
