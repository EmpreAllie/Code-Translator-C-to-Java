bison -d bison.y
flex lex.l
gcc bison.tab.c -o !run