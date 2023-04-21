%{
#include <stdio.h>
#include <math.h>
#include "y.tab.h"
%}

%option yylineno
letter	[a-zA-Z]
alphanum [a-zA-Z0-9]
alphanum_us 	[a-zA-Z0-9_]
filename 	{letter}{alphanum_us}*{alphanum}+
file_ext		([\.]{letter}+)*

%%
"gcc"		{printf("%s", yytext); 
				 return COMND;}
"yacc"	{printf("%s", yytext); 
				 return COMND;}
"lex"		{printf("%s", yytext); 
				 return COMND;}
"rm"		{printf("%s", yytext); 
				 return COMND;}
{letter}{alphanum}* {printf("%s", yytext); 
										return FNAME;}
{filename} { printf("%s", yytext); 
						 return FNAME;}
{file_ext} {printf("%s", yytext); 
						return EXT;}
\-{letter}+	{printf("%s", yytext); 
						 return OPTIONS;}
"=" 	{printf("%s", yytext); 
			 return yytext[0];}
":"		{printf("%s", yytext); 
			 return yytext[0];}
"\n"	{printf("%s", yytext); 
			 return yytext[0];}
"$"		{printf("%s", yytext); 
			 return yytext[0];}
"("		{printf("%s", yytext); 
			 return yytext[0];}
")"		{printf("%s", yytext); 
       return yytext[0];}
[\t]+		{printf("%s", yytext); 
				 return TAB;}
%%

int yywrap(){
	return 1;
}
