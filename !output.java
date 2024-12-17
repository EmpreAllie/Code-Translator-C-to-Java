class HelloWorld {
	public static void main(String[] args) {
		System.out.print("Hello World");
		System.out.print("Hello World 2");
		int a;
		double b = 5.234;
		float c = 3.000;
		a = 4;
		a += 3;
		a /= 3;
		if (a == 2 && c == 3) {
		System.out.print("a == 2\n");
		}
		else if (a == 1 || b == 5.233) {
		System.out.print("a == 1\n");
		}
		else {
		a = 4;
		System.out.print("a == 4\n");
		}
		for (int i = 0; i < a; i++) {
		System.out.println("loopin...");
		}
		boolean f = false;
		f = !f;
		while (f) {
		a--;
		++b;
		if (a <= 0) {
		c = c + 10 * 2;
		f = false;
		}
		}
		double d = (10 % 2) / (3 * 4) + 1.200;
		System.out.println("Bye-Bye!");
		
}
}
