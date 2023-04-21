%token EXTERN VOID INT IF ELSE WHILE RETURN EQ GEQ LEQ GT LT

%{
#include <stdio.h>
#include <stack>
#include "ast.h"
void yyerror(const char *);
extern int yylex();
extern int yylex_destroy();
extern FILE *yyin;
extern int yylineno;
extern char* yytext;

astNode* astRoot;
%}

%start program
%nonassoc IF
%nonassoc ELSE

%union {
  astNode* node;
  vector<astNode*>* nodeVec;
  char* str;
  int num;
}

%token <str> ID READ PRINT
%token <num> NUM
%type <node> program term add_expr sub_expr mul_expr div_expr expr condition 
eq_cond gt_cond lt_cond geq_cond leq_cond asgn_stmt if_stmt stmt block_stmt
if_else_stmt while_loop call_statement return_statement decl 
func_header function_def externs extern_read extern_print

%type <nodeVec> var_decls stmts

/*define that for tokens, make statemtent list for those that are not astNode types*/
%%
program: externs function_def { 
        $$ = $1; $$->prog.func = $2; 
        printNode($$); 
        astRoot = $$;
        // freeNode($$); 
        }


externs: extern_read extern_print  { $$ = createProg($1, $2, NULL); }
       | extern_print extern_read  { $$ = createProg($1, $2, NULL); }
extern_read: EXTERN type PRINT '(' type ')' ';' { $$ = createExtern($3); }
extern_print: EXTERN type READ '(' ')' ';'      { $$ = createExtern($3); }

type: INT | VOID

function_def: func_header block_stmt  { $$ = $1; $$->func.body = $2;      }
func_header: type ID '(' ')'          { $$ = createFunc($2, NULL, NULL);  }
          | type ID '(' type ID ')'   { 
            $$ = createFunc($2, createVar($5), NULL);    
            }

block_stmt: '{' var_decls stmts '}'   { 
            vector<astNode*>* stmt_list = $2;
            stmt_list->insert(stmt_list->end(), $3->begin(), $3->end());
            $$ = createBlock(stmt_list);
            }


var_decls:                  { $$ = new vector<astNode*>(); }
          | var_decls decl  { $$ = $1; $$->push_back($2);  }
decl: type ID ';'           { $$ = createDecl($2);         }


stmts: stmt         { $$ = new vector<astNode*>(); $$->push_back($1);  }
    | stmts stmt    { $$ = $1; $$->push_back($2);                      }
stmt: asgn_stmt                 { $$ = $1; }
    | if_stmt %prec IF          { $$ = $1; }
    | if_else_stmt %prec ELSE   { $$ = $1; }
    | while_loop                { $$ = $1; }
    | block_stmt                { $$ = $1; }
    | call_statement            { $$ = $1; }
    | return_statement          { $$ = $1; }


asgn_stmt: ID '=' expr ';'          { $$ = createAsgn(createVar($1), $3);   }
        | ID '=' call_statement     { $$ = createAsgn(createVar($1), $3);   }
if_stmt: IF '(' condition ')' stmt  { $$ = createIf($3, $5);                }
if_else_stmt: if_stmt ELSE stmt     { $$ = $1; $$->stmt.ifn.else_body = $3; }

while_loop: WHILE '(' condition ')' stmt  { $$ = createWhile($3, $5);   }
call_statement: READ '(' ')' ';'          { $$ = createCall($1, NULL);  }
              | PRINT '(' expr ')' ';'    { $$ = createCall($1, $3);    }
return_statement: RETURN ';'              { $$ = createRet(NULL);       }
                | RETURN expr ';'         { $$ = createRet($2);         }


expr: add_expr { $$ = $1; }
    | sub_expr { $$ = $1; }
    | mul_expr { $$ = $1; }
    | div_expr { $$ = $1; }
    | term     { $$ = $1; }


term: ID        { $$ = createVar($1);           } 
    | NUM       { $$ = createCnst($1);          } 
    | '-' term  { $$ = createUExpr($2, uminus); } 

add_expr: term '+' term     { $$ = createBExpr($1, $3, add);    }
        | '(' add_expr')'   { $$ = $2; }
sub_expr: term '-' term     { $$ = createBExpr($1, $3, sub);    }
        | '(' sub_expr')'   { $$ = $2; }
mul_expr: term '*' term     { $$ = createBExpr($1, $3, mul);    }
        | '(' mul_expr')'   { $$ = $2; }
div_expr: term '/' term     { $$ = createBExpr($1, $3, divide); }
        | '(' div_expr')'   { $$ = $2; }


condition: eq_cond { $$ = $1; }
        | gt_cond  { $$ = $1; }
        | lt_cond  { $$ = $1; }
        | geq_cond { $$ = $1; }
        | leq_cond { $$ = $1; }


eq_cond: term EQ term     { $$ = createRExpr($1, $3, eq); }
      | '(' eq_cond ')'   { $$ = $2; }
gt_cond: term GT term     { $$ = createRExpr($1, $3, gt); }
      | '(' gt_cond ')'   { $$ = $2; }
lt_cond: term LT term     { $$ = createRExpr($1, $3, lt); }
      | '(' lt_cond ')'   { $$ = $2; }
geq_cond: term GEQ term   { $$ = createRExpr($1, $3, ge); }
      | '(' geq_cond ')'  { $$ = $2; }
leq_cond: term LEQ term   { $$ = createRExpr($1, $3, le); }
      | '(' leq_cond ')'  { $$ = $2; }


%%

void semanticAnalysis(astNode* program);

int main(int argc, char** argv){
	if (argc == 2){
		yyin = fopen(argv[1], "r");
	}

	yyparse();
  semanticAnalysis(astRoot);

	if (yyin != stdin)
		fclose(yyin);

	yylex_destroy();
	
	return 0;
}


void yyerror(const char *){
	fprintf(stdout, "Syntax error %d %s\n", yylineno, yytext);
}


void semanticAnalysis(astNode* program){
  std::stack<astNode*> st;
  st.push(program);
  printNode(st.top());
}
