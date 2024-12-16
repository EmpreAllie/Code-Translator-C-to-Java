#include <stdio.h>
#include <stdlib.h>

int main() {
	printf("Hello World");
	printf("Hello World 2");

	int a;
	double b = 5;
	a = 4;
	
	a += 3;
	a /= 3;

	if (a == 2) {
		printf("a == 2");
	}
	else if (a == 1) {
		printf("a == 1");
	}
	else {
		a = 4;
		printf("a == 4");
	}

	for (int i = 0; i < a; i++) {
		printf("loopin...");
	}
	
	exit(0);
}