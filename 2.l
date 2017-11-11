%{
int doc=1;
int comment1=0;
int comment2=0;
int commentdoc=0;
int word=0;
int sAtBegin=0;
int quote=0;
%}

COMMENT1 "/*"
COMMENTEND "*/"
COMMENT2 "//"
DOCCOMMENT "/**"
QUOTE	"\""
%%
^[*]+		{
			sAtBegin=1;
			word=1;
			if(doc){
				printf("%s", yytext);
			}
		}
\n		{
			if(word){
				printf("\n");
				word=0;
			}
			comment2=0;
			sAtBegin=0;
		}
{QUOTE}		{
			if(quote){
				quote=0;
			}else{
				quote=1;
			}
			printf("\"");
		}
{COMMENT1}	{
			if(!quote){
				comment1=1;
			}else{
				printf("/*");
			}
		}	
{COMMENT2}	{
			if(!quote){
				comment2=1;
			}else{
				printf("//");
			}
		}
{DOCCOMMENT}	{
			if(!quote){
				if(doc){
					printf("/**");		
				}
				commentdoc=1;
				sAtBegin=1;
			}else{
				printf("/**");
			}
		}
{COMMENTEND}	{
			
			if(!quote){
				if(doc && commentdoc){
					printf("*/\n");	
					comment1=0;
					commentdoc=0;		
				}else if(comment1 || commentdoc){
					comment1=0;
					commentdoc=0;				
				}else{
					printf("*/");
				}	
			}else{
				printf("*/");
			}
		}
.		{
			if(commentdoc){
				if(sAtBegin && doc){
					printf("%s",yytext);
					word=1;
				}
			}else if(!comment2 && !comment1){
				word=1;
				printf("%s",yytext);
			}
		}
%%
int yywrap(){
	return 1;
}

int main()
{
	yylex();
	
}
