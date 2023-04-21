%{
#include <stdio.h>
#include <math.h>
#include "ast.h"
#include "y.tab.h"
%}

%option yylineno
letter	[a-zA-Z]
num     [0-9]
alphanum [a-zA-Z0-9]
alphanum_us 	[a-zA-Z0-9_]
name 	{letter}{alphanum_us}*{alphanum}*
file_ext		([\.]{letter}+)*



%%
"extern"		{printf("%s", yytext); 
				  return EXTERN;}
"void"		  {printf("%s", yytext); 
				  return VOID;}
"int"	      {printf("%s", yytext); 
				  return INT;}
"if"		    {printf("%s", yytext); 
				  return IF;}
"else"	    {printf("%s", yytext);
          return ELSE;}
"while"	    {printf("%s", yytext);
          return WHILE;}
"return"	  {printf("%s", yytext);
          return RETURN;}
"print"     {printf("%s", yytext);
              yylval.str = strndup(yytext, yyleng);
              return PRINT;}
"read"      {printf("%s", yytext);
              yylval.str = strndup(yytext, yyleng);
              return READ;}
{name}      { printf("%s", yytext);
              yylval.str = strndup(yytext, yyleng);
              return ID;}
              
{num}+		  {printf("%s", yytext);
              yylval.num = atoi(yytext);
              return NUM;}
"\:"		{printf("%s", yytext); 
			 return yytext[0];}
"\;"		{printf("%s", yytext); 
			 return yytext[0];}
"\+"		{printf("%s", yytext);
        return yytext[0];}
"\-"		{printf("%s", yytext);
        return yytext[0];}
"\/"		{printf("%s", yytext);
        return yytext[0];}
"\*"		{printf("%s", yytext); 
        return yytext[0];}
"\=" 	  {printf("%s", yytext); 
			  return yytext[0];}
"\<"		{printf("%s", yytext);
        return LT;}
"\>"		{printf("%s", yytext);
        return GT;}
"<="		{printf("%s", yytext);
        return LEQ;}
">="	  {printf("%s", yytext);
        return GEQ;}
"=="	  {printf("%s", yytext);
        return EQ;}
"\("		{printf("%s", yytext); 
			  return yytext[0];}
"\)"		{printf("%s", yytext); 
        return yytext[0];}
"\{"		{printf("%s", yytext);
        return yytext[0];}
"\}"		{printf("%s", yytext);
        return yytext[0];}

[ \t\n] {printf("%s", yytext); }

%%

int yywrap(){
	return 1;
}
