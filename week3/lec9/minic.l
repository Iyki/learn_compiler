%{
	#include <stdio.h>
	#include "ast.h"
	#include "y.tab.h"
	#include <string.h>
%}
letter [a-zA-Z]
digit [0-9]
alphanum_us [a-zA-Z0-9_]
%%
"int"										{return INT;}
"void"									{return VOID;}
"read"									{return READ;}
"print"									{return PRINT;}
"return"								{return RET;}
"if"										{return IF;}
"else"									{return ELSE;}
"while"									{return WHILE;}
"extern"									{return WHILE;}

{letter}{alphanum_us}*	{ yylval.idname = strdup(yytext);
													return ID;}
[1-9]{digit}+						{ yylval.ival = atoi(yytext);
													return NUM;}
"+"|"-"|"*"|"/"				  {return yytext[0];}		 
"="|";"|"("|")"|"{"|"}"			{return yytext[0];}		 
">"										  {return GT;}
"<"										  {return LT;}
"=="										{return EQ;}
">="										{return GE;}
"<="										  {return LE;}
.|[ \t\n]
%%

int yywrap(){
	return 1;
}

