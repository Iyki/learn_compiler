int func(int i){
	int a;
	int b;
	int c;
	
	a = 100;
	b = 20;
	
	while (i < a){
			a = 50;
			i = i + 10;	
	}
	
	c = a + b;
	
	return c+i;
}
