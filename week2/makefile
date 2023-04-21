test.out: test.l test.y
	yacc -d test.y
	lex test.l
	gcc -o test.out lex.yy.c y.tab.c -ll