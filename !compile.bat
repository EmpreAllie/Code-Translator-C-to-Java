bison -d bison.y
flex lex.l
gcc lex.yy.c bison.tab.c -o !run
