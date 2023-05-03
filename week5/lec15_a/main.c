#include<stdio.h>

int func(int);

int main(){
	int i = func(20);
	printf("In main printing return value of test: %d\n", i);
	return 0;
}
