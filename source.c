#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int main() {
	printf("Hello World");
	printf("Hello World 2");

	int a;
	double b = 5.234;
	float c = 3.0;
	a = 4;
	
	a += 3;
	a /= 3;

	if (a == 2 && c == 3) {
		printf("a == 2\n");
	}
	else if (a == 1 || b == 5.233) {
		printf("a == 1\n");
	}
	else {
		a = 4;
		printf("a == 4\n");
	}

	for (int i = 0; i < a; i++) {
		puts("loopin...");		
	}

	bool f = false;
	f = !f;
	while (f) {
		a--;
		++b;
		if (a <= 0) {
			c = c + 10 * 2;
			f = false;
		}
	}

	double d = (10 % 2) / (3 * 4) + 1.2;
	puts("Bye-Bye!");
	
	exit(0);
}