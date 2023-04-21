%{
  #include<stdio.h>
  int count_words=0;
  int count_nums=0;
}%
%%
[a-zA-Z]+ {count_words++;}
[0-9]+ {count_nums++;}
.|[ \t\n]
%%
int yywrap() {
  return (1);
}

int main() {
  yylex();
  printf("Words: %d, Nums:%d\n", count_words, count_nums);
  return(0);
}