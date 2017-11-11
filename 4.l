%{
	#include <stdlib.h>
	int numbers[100];
	int i=-1;
	int error1=0;
	int error2=0;
	int newpow(int x,int y){
		int result=1;
		for(int j=0;j<y;j++){
			result*=x;
		}
		return result;
	} 
%}

%%
\n		{
			if(error2){
				printf("Error: wrong sign\n");
			}else if(i!=0){
				printf("Error: not enough operators\n");
			}else if(error1){
				printf("Error: not enough arguments\n");
			}else{
				printf("= %d\n",numbers[0]);
			}
			error1=0;
			error2=0;
			i=-1;
		}
[0-9]+|-[0-9]+		{
			++i;
			numbers[i]=atoi(yytext);
		}
[+]		{
			if(i>0){
				numbers[i-1]=numbers[i-1]+numbers[i];
				i--;
			}else{
				error1=1;
			}
		}
[-]		{
			if(i>0){
				numbers[i-1]=numbers[i-1]-numbers[i];
				i--;
			}else{
				error1=1;
			}
		}
[*]		{
			if(i>0){
				numbers[i-1]=numbers[i-1]*numbers[i];
				i--;
			}else{
				error1=1;
			}
		}
[/]		{
			if(i>0){
				numbers[i-1]=numbers[i-1]/numbers[i];
				i--;
			}else{
				error1=1;
			}
		}
"^"		{
			if(i>0){
				numbers[i-1]=newpow(numbers[i-1],numbers[i]);
				i--;
			}else{
				error1=1;
			}
		}
[%]		{
			if(i>0){
				numbers[i-1]=numbers[i-1]%numbers[i];
				i--;
			}else{
				error1=1;
			}
		}
[ ]		{
			;
		}
.		{
			error2=1;
		}
%%
int yywrap(){
	return 1;
}

int main()
{
	yylex();
	
}
