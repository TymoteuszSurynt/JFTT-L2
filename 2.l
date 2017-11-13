%{
int doc=0;
int comment1=0;
int comment2=0;
int comment3=0;
int commentdoc=0;
int word=0;
int sAtBegin=0;
int quote=0;
int begining=1;
%}

COMMENT1 "/*"
COMMENTEND [ \t]*"*/"
COMMENT2 "//"
COMMENT3 "///"
DOCCOMMENT "/**"
QUOTE	\"
%%
{COMMENT3}		{
			if(!quote){
				if(!commentdoc){
					comment3=1;
				}else if (commentdoc && doc){
					printf("%s",yytext);
				}
			}else{
				printf("%s",yytext);
			}
		}
^[ \t]+"*"		{
			
			if(begining){
				sAtBegin=1;
				begining=0;
			}
			word=1;
			if(!commentdoc){
				if(!comment1 && !comment2 && !comment3){
					printf("%s", yytext);
				}else if(comment3 && doc){
					printf("%s", yytext);
				}
			}else if(commentdoc && doc && sAtBegin){
				printf("%s", yytext);
			}
			
		}
[\\][ \t]*\n		{
			if(comment2){
				sAtBegin=0;
				begining=1;
			}else if(comment3){				
				sAtBegin=0;
				begining=1;
				if(doc){
					printf("%s",yytext);
				}
			}else{
				printf("%s", yytext);
				sAtBegin=0;
				begining=1;
				
			}	
		}
\n		{
			if(word){
				printf("\n");
				word=0;
			}
			begining=1;
			comment2=0;
			comment3=0;
			sAtBegin=0;
		}
{COMMENT1}	{
			if(!quote){
				if(!comment2 &&!comment3 && !commentdoc){
					comment1=1;
				}else if(comment3 && doc){
					printf("%s",yytext);
				}else if(commentdoc && doc && sAtBegin){
					printf("/*");
				}	
			}else{
				printf("/*");
			}
		}	
{COMMENT2}	{
			if(!quote){
				if(!comment3){
					if(!commentdoc){
						comment2=1;
					}else if (commentdoc && doc){
						printf("//");
					}
				}else if(comment3 && doc){
					printf("%s",yytext);
				}
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
					printf("%s", yytext);	
					comment1=0;
					commentdoc=0;
					word=1;		
				}else if(comment1 || commentdoc){
					comment1=0;
					commentdoc=0;				
				}else{
					if(!comment3 && !comment2){
						printf("%s", yytext);
					}else if(comment3 && doc){
						printf("%s", yytext);
					}
				}	
			}else{
				printf("%s",yytext);
			}
		}
"\\\""			{
				printf("%s",yytext);
			}
{QUOTE}		{
			if(quote){
				quote=0;
				printf("\"");
			}else{
				if(!comment1 && !comment2 && !comment3 && !commentdoc){
					quote=1;
					printf("\"");
				}else if(comment3 && doc){
					printf("%s", yytext);
				}else if(commentdoc && doc && sAtBegin){
					printf("\"");
				}
			}
			
		}

.		{
			begining=0;
			if(commentdoc){
				if(sAtBegin && doc){
					printf("%s",yytext);
					word=1;
				}
			}else if(!comment3 && !comment2  && !comment1){
				word=1;
				printf("%s",yytext);
			}else if(comment3 && doc){
				printf("%s", yytext);
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
