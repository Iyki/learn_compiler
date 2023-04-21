%{
#include <stdio.h>
extern int yylex();
extern int yylex_destroy();
extern int yywrap();
int yyerror();
extern FILE *yyin;
%}

%union{
		int ival;
		char *sname;
		double dval;
}

%token <ival> NUM
%token <sname> NAME
%type <ival> scores score

%start scores
%%
scores : scores score {$$ = $1 + $2;
												printf("Total: %d\n", $$ );}
				|score {$$ = $1;}
score : NAME ':' NUM {$$ = $3;}
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

int yyerror(){
	fprintf(stderr, "Syntax error\n");
}
