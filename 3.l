%{
	int comment=0;
	int begincom=0;
	int begin=0;
	int header=0;
	int tag=0;
%}

BEGINCOMM	"\\begin{comment}"
BEGIN		"\\begin{"
ENDCOMM		"\\end{comment}"
END		"\\end{"

%%
\n		{	
			if(!header && !comment && !begincom && !tag){
				printf("\n");
			}
			comment=0;
			tag=0;
		}
[%]		{
			comment=1;
		}
{BEGINCOMM}	{
			if(begin){
				begincom=1;
				tag=1;
			}	
		}
{BEGIN}		{
			header=1;
			begin=1;
			tag=1;
		}
[}]		{
			if(header){
				header=0;
				tag=1;
			}else{
				printf("}");
			}
		}
{ENDCOMM}	{
			if(begin && begincom){
				begincom=0;
				tag=1;
			}
		}
{END}		{
			begin=0;
			begincom=0;
			header=1;
			tag=1;
		}
.		{
			if(!comment && !header && !begincom){
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
