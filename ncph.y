%{
/* All code has been dedicated to the public domain by the authors. Anyone is
 * free to copy, modify, publish, use, compile, sell or distribute this file
 * for any purpose, commercial or non-commerical, and by any means. */

#include <err.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>

void		yyerror(const char *);
int		yywrap(void);
static int	usage(void);

const char		*clipdir = "clips";
const char		*clipfile = "ncphclips";
const char		*film;
int			lineno = 1;
extern FILE		*yyin;
extern const char	*__progname;
%}

%union {
	int n;
	char *s;
};

%token	FILM CLIP VOLUME NUMBER STRING
%type	<n> NUMBER
%type	<s> STRING

%%

films
	: /* empty */
	| films FILM STRING NUMBER '{' clips '}' {
		film = yylval.s;
	}
	;

clips
	: /* empty */
	| clips CLIP STRING clipopts
	;

clipopts
	: /* empty */
	| VOLUME NUMBER
	;

%%

int
main(int argc, char* argv[])
{
	int ch;

	while ((ch = getopt(argc, argv, "d:f:")) != -1) {
		switch (ch) {
			case 'd':
				clipdir = optarg;
				break;
			case 'f':
				clipfile = optarg;
				break;
			default:
				usage();
		}
	}
	argc -= optind;
	argv += optind;

	if (strcmp(clipfile, "-") == 0)
		yyin = stdin;
	else if ((yyin = fopen(clipfile, "r")) == NULL)
		err(1, "fopen %s", clipfile);

	yyparse();
	fclose(yyin);
	return 0;
}

void
yyerror(const char* s)
{
	errx(1, "%s:%d: %s\n", clipfile, lineno, s);
}

int
yywrap(void)
{
	return 1;
}

static int
usage(void)
{
	fprintf(stderr, "Usage: %s [-d clipdir] [-f ncphclips]", __progname);
	exit(1);
}
