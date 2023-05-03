//live variable analysis
int func(int i){
	int a;
	int b;
	int c;
	
	a = 100;
	b = 20;
	
	if (i < a){
			a = b + i;
	}
	else {
			a = b + 10;	
	}
	
	c = a + b;
	
	return c+i;
}
