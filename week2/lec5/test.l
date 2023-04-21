%{
	#include <stdio.h>
	#include "y.tab.h"
%}
letter [a-zA-Z]
%%
{letter}+	{return NAME;}
[0-9]+		{return NUM;}
":"				{return yytext[0];}		 
.|[ \t\n]
%%

int yywrap(){
	return 1;
}

