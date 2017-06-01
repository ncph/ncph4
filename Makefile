a.out: lex.yy.c y.tab.c y.tab.h
	cc ${CFLAGS} lex.yy.c y.tab.c

y.tab.c y.tab.h: ncph.y
	yacc -d ncph.y

lex.yy.c: y.tab.h ncph.l
	flex ncph.l

clean:
	rm -f a.out lex.yy.c y.tab.{h,c}
