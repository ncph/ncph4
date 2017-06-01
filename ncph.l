%{
/* All code has been dedicated to the public domain by the authors. Anyone is
 * free to copy, modify, publish, use, compile, sell or distribute this file
 * for any purpose, commercial or non-commerical, and by any means. */

#include "y.tab.h"

extern int lineno;
%}

NUMBER	[0-9]+
STRING	[A-Za-z][A-Za-z0-9]*

%%

clip		return CLIP;
film		return FILM;
volume		return VOLUME;
NUMBER		{ yylval.n = atoi(yytext); return NUMBER; }
STRING		{ yylval.s = strdup(yytext); return STRING; }
#[^\n]*
[ \t]
\n		++lineno;
