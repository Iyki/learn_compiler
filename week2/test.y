// yacc file
%{
#include <stdio.h>
extern int yylex();
extern int yywrap();
void yyerror();
FILE *yyin;  
%}

%union{
  int ival;
  char *sname;
  double dval;
}


%token <ival> NAME 
%token <sname> NUM
%start score
%%
// left recursion preferred over right recursion (base case is last item?). because yacc works based on a stack. With right recursion, stack gets very very big
scores: scores score
        | score
score: NAME ':' NUM
%%
int main(int argc, char** argv){
  if (argc==2) {
    yyin=fopen(argv[1], "r");
  }
  yyparse();
  yylex_destroy();
  fclose(yyin);
  return 0;
}

void yyerror(){
  fprintf(stderr, "Syntax error\n");
}