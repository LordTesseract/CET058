/* 
Crie um Analisador Léxico utilizando Flex que consiga gerar os tokens
do arquivo de entrada "exercicio01.in" que consiste em um código na
linguagem C. O analisador deverá identificar todos os tokens referentes a:

1. Identificadores
2. Números Inteiros
3. Números de Ponto Flutuante
4. Palavras reservadas
5. Operadores Matemáticos e Relacionais
6. Chaves, Colchetes e Chaves

utilize os exemplos no diretório "flex" como ponto de partida.
*/

/* colocando identificadores */



%{
	#include "parser.tab.h"
%}

TIPO					"int"|"float"|"char"
PALAVRAS_RESERVADAS		"break"|"return"
IF						"if"
ELSE					"else"
WHILE					"while"
TYPE_INTEGER				([0-9]+)
TYPE_FLOAT					([0-9]+)*[.]([0-9]+)
ID   					[_a-zA-Z][_a-zA-Z0-9]*
LOGICO_AND				"&&"
LOGICO_OR				"||"
LOGICO_COMPARACAO 		"=="
LOGICO_NOT				"!"
LOGICO_NOT_EQ			"!="
OP_LOGICA				"<"|">"|"<="|">="
ATRIBUICAO				"="
ABRE_PAR				"\("
FECHA_PAR				"\)"
ABRE_CHAVE				"\{"
FECHA_CHAVE				"\}"
ABRE_COLCHETE			"\["
FECHA_COLCHETE			"\]"
TYPE_STRING				\"(\\.|[^"\\])*\"
CARACTER 				(\')(.)(\')
%%

{TIPO}					{strncpy(yylval.simbolo, yytext, 50); return TIPO;}
{ELSE}					{return ELSE;}
{PALAVRAS_RESERVADAS}	{return PALAVRAS_RESERVADAS;}
{IF} 					{strncpy(yylval.simbolo, yytext, 50); return IF;}
{WHILE}					{strncpy(yylval.simbolo, yytext, 50); return WHILE;}
{TYPE_INTEGER}			{strncpy(yylval.simbolo, yytext, 50); return TYPE_INTEGER;}
{TYPE_FLOAT}			{strncpy(yylval.simbolo, yytext, 50); return TYPE_FLOAT;}
{ID}					{strncpy(yylval.simbolo, yytext, 50); return ID;}
"\+"					{return SOMA;}
"\*"					{return MUL;}
"/"						{return DIV;}
"\-"					{return SUB;}
"\,"                    {return VIRGULA;}
{OP_LOGICA}				{strncpy(yylval.simbolo, yytext, 50); return OP_LOGICA;}
{LOGICO_AND}			{return LOGICO_AND;}
{LOGICO_OR}				{return LOGICO_OR;}
{LOGICO_COMPARACAO}		{return LOGICO_COMPARACAO;}
{LOGICO_NOT}			{return LOGICO_NOT;}
{LOGICO_NOT_EQ}			{return LOGICO_NOT_EQ;}
{ATRIBUICAO}			{return ATRIBUICAO;}
{ABRE_PAR}				{return ABRE_PAR;}
{FECHA_PAR}				{return FECHA_PAR;}
{ABRE_CHAVE}			{return ABRE_CHAVE;}
{FECHA_CHAVE}			{return FECHA_CHAVE;}
{ABRE_COLCHETE}			{return ABRE_COLCHETE;}
{FECHA_COLCHETE}		{return FECHA_COLCHETE;}
{TYPE_STRING}			{strncpy(yylval.simbolo, yytext, 50); return TYPE_STRING;}
{CARACTER}				{strncpy(yylval.simbolo, yytext, 50); return CARACTER;}
"\n"                    {return EOL;}

%%

int yywrap() {}