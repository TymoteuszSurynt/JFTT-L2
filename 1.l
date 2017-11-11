%{

int check=0;
int wasWordInLine = 0;
int words = 0;
int lines = 0;
%}

WHITESIGN [ \t]
WORD [^\n\t ]+
%%

\n {
		if(check)
		{
			printf("\n");
			wasWordInLine = 0;
			lines++;
			check=0;
		}	
		wasWordInLine=0;	
	}

{WHITESIGN} {
		if(wasWordInLine)
		{
			printf(" ");
			wasWordInLine=0;
		}
	}

{WORD} {
		wasWordInLine = 1;
		words++;
		check=1;
		printf("%s", yytext);
	}

%%
int yywrap(){
	return 1;
}

int main()
{
	yylex();
	printf("\nlines: %d, words: %d\n", lines, words);
}
