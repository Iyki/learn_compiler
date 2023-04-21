/*
A grammar that has a reduce-reduce conflict
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
%start scores

%%
scores	 : scores score1
					| score1 | score2
score1	: NAME ':' NUM
score2 	: NAME ':' NUM

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
