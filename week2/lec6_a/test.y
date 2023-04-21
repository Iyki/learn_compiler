%token FNAME OPTIONS EXT TAB COMND

%{
#include <stdio.h>
void yyerror(const char *);
extern int yylex();
extern int yylex_destroy();
extern FILE *yyin;
extern int yylineno;
extern char* yytext;

%}

%start targets

%%
targets: | targets target | targets assignment

assignment: FNAME '=' FNAME '\n'

target: filename ':' filenames '\n' statements

statements: | statements statement
statement: tabs COMND options filenames '\n'

filenames: | filenames filename
filename: FNAME | '$''(' FNAME ')' EXT | FNAME EXT

tabs: tabs TAB | TAB
options: | options OPTIONS

%%

int main(int argc, char** argv){
	if (argc == 2){
		yyin = fopen(argv[1], "r");
	}

	yyparse();

	if (yyin != stdin)
		fclose(yyin);

	yylex_destroy();
	
	return 0;
}


void yyerror(const char *){
	fprintf(stdout, "Syntax error %d %s\n", yylineno, yytext);
}
