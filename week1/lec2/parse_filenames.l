%{
#include<stdio.h>
int count_words=0;
int count_nums=0;
%}
%%
"all" {printf("found keyword %s\n", yytext);}
"clean" {printf("found keyword %s\n", yytext);}
"gcc" {printf("found keyword %s\n", yytext);}
"lex" {printf("found keyword %s\n", yytext);}
"-rf" {printf("found keyword %s\n", yytext);}
-[a-zA-Z]+ {printf("found keyword %s\n", yytext);}

[$\(\)]*[a-zA-Z]+[[.$_\-\(\)]*[0-9a-zA-Z]+]* {printf("should be filename %s\n", yytext);}

.|[ \t\n]
%%
int yywrap(){
	return(1);
}

int main(){
	yylex();
	// printf("Words:%d, Nums:%d\n",count_words, count_nums);
  // [a-zA-Z]+[.]*[-]*[_]*[0-9]*[a-zA-Z]* 
	return(0);
}

