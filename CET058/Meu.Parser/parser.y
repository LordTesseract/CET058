%{

/* Código C, use para #include, variáveis globais e constantes
 * este código ser adicionado no início do arquivo fonte em C
 * que será gerado.
 */

#include <stdio.h>
#include <stdlib.h>

typedef struct No {
    char token[50];
    int num_filhos;
    struct No** filhos;
} No;

enum tipos{INT, FLOAT, CHAR, STRING};

typedef struct registro_da_tabela_de_simbolo {
    char token[50];
    char lexema[50];
    char tipo[50];
    int endereco;
} RegistroTS;

#define TAM_TABELA_DE_SIMBOLOS 1024

RegistroTS tabela_de_simbolos[TAM_TABELA_DE_SIMBOLOS];
int prox_posicao_livre = 0;
int prox_mem_livre = 0;

No* allocar_no();
void liberar_no(No* no);
void imprimir_arvore(No* raiz);
No* novo_no(char[50], No**, int);
void imprimir_tabela_de_simbolos(RegistroTS*);
void inserir_na_tabela_de_simbolos(RegistroTS);

%}

/* Declaração de Tokens no formato %token NOME_DO_TOKEN */

%union 
{
    int number;
    char simbolo[50];
    struct No* no;
}

%token TIPO
%token TYPE_INTEGER
%token TYPE_FLOAT
%token ID
%token PALAVRAS_RESERVADAS
%token IF
%token ELSE
%token WHILE
%token OP_LOGICA
%token SOMA
%token MUL
%token SUB
%token DIV
%token LOGICO_AND
%token LOGICO_OR
%token LOGICO_COMPARACAO
%token LOGICO_NOT
%token LOGICO_NOT_EQ
%token ATRIBUICAO
%token ABRE_PAR
%token ABRE_CHAVE
%token ABRE_COLCHETE
%token FECHA_PAR
%token FECHA_CHAVE
%token FECHA_COLCHETE
%token TYPE_STRING
%token CARACTER
%token FUNCAO
%token ARRAY
%token TAM_ARRAY
%token EOL
%token VIRGULA
%token PV

%type<no> prog
%type<no> fator
%type<no> exp
%type<no> termo
%type<no> statement
%type<no> sttmt
%type<no> operador
%type<no> abrir
%type<no> fechar
%type<no> tipo
%type<no> args
%type<no> arg
%type<no> else

%type<simbolo> WHILE
%type<simbolo> OP_LOGICA
%type<simbolo> ATRIBUICAO
%type<simbolo> SOMA
%type<simbolo> MUL
%type<simbolo> DIV
%type<simbolo> IF
%type<simbolo> ABRE_PAR
%type<simbolo> ABRE_CHAVE
%type<simbolo> ABRE_COLCHETE
%type<simbolo> FECHA_PAR
%type<simbolo> FECHA_CHAVE
%type<simbolo> FECHA_COLCHETE
%type<simbolo> SUB
%type<simbolo> LOGICO_AND
%type<simbolo> LOGICO_OR
%type<simbolo> LOGICO_COMPARACAO
%type<simbolo> LOGICO_NOT
%type<simbolo> LOGICO_NOT_EQ  
%type<simbolo> TIPO
%type<simbolo> ID
%type<simbolo> TYPE_INTEGER
%type<simbolo> TYPE_FLOAT
%type<simbolo> TYPE_STRING
%type<simbolo> CARACTER
%type<simbolo> FUNCAO
%type<simbolo> ELSE
%type<simbolo> VIRGULA
%type<simbolo> PV


%%
/* Regras de Sintaxe */

prog:                     
    | prog statement EOL       { imprimir_arvore($2); 
                            printf("\n");
                            imprimir_tabela_de_simbolos(tabela_de_simbolos);
                            printf("\n"); }
    ;

statement: sttmt                 {
                            No** filhos = (No**) malloc(sizeof(No*) * 1);
                            filhos[0] = $1;

                            $$ = novo_no("sttmt", filhos, 1);
}
    | sttmt statement           {
                            No** filhos = (No**) malloc(sizeof(No*) * 2);
                            filhos[0] = $1;
                            filhos[1] = $2;

                            $$ = novo_no("statement", filhos, 2);
    }
;

sttmt: exp
    | IF abrir exp fechar sttmt {
                            No** filhos = (No**) malloc(sizeof(No*) * 3);
                            filhos[0] = novo_no("if", NULL, 0);
                            filhos[1] = $3;
                            filhos[2] = $5;

                            $$ = novo_no("sttmt", filhos, 3);
    }
    | IF abrir exp fechar abrir sttmt fechar {
                            No** filhos = (No**) malloc(sizeof(No*) * 3);
                            filhos[0] = novo_no("if", NULL, 0);
                            filhos[1] = $3;
                            filhos[2] = $5;

                            $$ = novo_no("sttmt", filhos, 3);
    }
    | IF abrir exp fechar abrir sttmt fechar else{
                            No** filhos = (No**) malloc(sizeof(No*) * 3);
                            filhos[0] = novo_no("if", NULL, 0);
                            filhos[1] = $3;
                            filhos[2] = $5;

                            $$ = novo_no("sttmt", filhos, 3);
    }
    | WHILE abrir exp fechar abrir sttmt fechar{
                            No** filhos = (No**) malloc(sizeof(No*) * 3);
                            filhos[0] = novo_no("while", NULL, 0);
                            filhos[1] = $3;
                            filhos[2] = $6;

                            $$ = novo_no("sttmt", filhos, 3);
    }
    | termo abrir fechar  {                          
                            No** filhos = (No**) malloc(sizeof(No*));
                            filhos[0] = novo_no($1, NULL, 0);
                            $$ = novo_no("funcao", filhos, 1); 
    }
    | termo abrir args fechar  {
                            No** filhos = (No**) malloc(sizeof(No*) * 2);
                            filhos[0] = $1;
                            filhos[1] = $3;

                            $$ = novo_no("funcao", filhos, 2);
    }
    | tipo fator abrir args fechar abrir sttmt fechar {
                            No** filhos = (No**) malloc(sizeof(No*) * 4);
                            filhos[0] = novo_no($2, NULL, 0);
                            filhos[1] = $4;
                            filhos[2] = $5;
                            filhos[3] = $7;

                            $$ = novo_no("funcao", filhos, 4);
    }
    | tipo fator abrir fechar abrir sttmt  fechar {
                            No** filhos = (No**) malloc(sizeof(No*) * 2);
                            filhos[0] = novo_no($2, NULL, 0);
                            filhos[1] = $6;

                            $$ = novo_no("funcao", filhos, 2);
    }
;
else:
    | ELSE abrir sttmt fechar {
                            No** filhos = (No**) malloc(sizeof(No*) * 2);
                            filhos[0] = novo_no("if", NULL, 0);
                            filhos[1] = $3;

                            $$ = novo_no("sttmt", filhos, 2);
    }
;
args: arg                   {
                            No** filhos = (No**) malloc(sizeof(No*) * 1);
                            filhos[0] = $1;

                            $$ = novo_no("args", filhos, 1);
}
    | args VIRGULA arg     {
                            No** filhos = (No**) malloc(sizeof(No*) * 2);
                            filhos[0] = $1;
                            filhos[1] = $3;

                            $$ = novo_no("args", filhos, 2);

}
;
arg:                   
    | tipo termo {
                        No** filhos = (No**) malloc(sizeof(No*) * 2);
                        filhos[0] = $1;
                        filhos[1] = novo_no($2, NULL, 0);;

                        $$ = novo_no("arg", filhos, 2);
    }
    | termo             {
                        No** filhos = (No**) malloc(sizeof(No*) * 1);
                        filhos[0] = $1;

                        $$ = novo_no("arg", filhos, 1);
    }
exp: fator
    | exp SOMA fator  {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("+", NULL, 0);
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);
                            }
    | exp SUB fator  {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("-", NULL, 0);
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);
                            }
    | exp LOGICO_AND fator  {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("&&", NULL, 0);
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);
    }
    | exp LOGICO_OR fator  {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("||", NULL, 0);
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);
    }
    | exp LOGICO_COMPARACAO fator {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("==", NULL, 0);
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);
    }
    | exp LOGICO_NOT_EQ fator {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("!=", NULL, 0);
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);
    }
    | tipo fator ATRIBUICAO sttmt {
                            No** filhos = (No**) malloc(sizeof(No*)*4);
                            filhos[0] = $1;
                            filhos[1] = $2;
                            filhos[2] = novo_no("=", NULL, 0);
                            filhos[3] = $4;

                            for(int i = 0; i < prox_posicao_livre; i++){
                                if(!strcmp($2, tabela_de_simbolos[i].lexema)){
                                    printf("Atencao: Variavel ja declarada! %s", $2);
                                    return;
                                }
                            }

                            RegistroTS registro;
                            strncpy(registro.token, "ID", 50);
                            strncpy(registro.lexema, $2, 50);
                            strncpy(registro.tipo, $1, 50);
                            registro.endereco = prox_mem_livre;
                            inserir_na_tabela_de_simbolos(registro);
                            prox_mem_livre += 4;

                            $$ = novo_no("exp", filhos, 4);
    }
    | exp ATRIBUICAO sttmt  {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("=", NULL, 0);
                            filhos[2] = $3;

			    			for(int i = 0; i < prox_posicao_livre; i++){
                                if(!strcmp($2, tabela_de_simbolos[i].lexema)){
                                    printf("Atencao: Variavel ja declarada! %s", $2);
                                    return;
                                }
                            }

                            $$ = novo_no("exp", filhos, 3);
    }
    | exp operador fator  {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = $2;
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);
    }
    | abrir exp fechar  {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = $2;
                            filhos[2] = $3;

                            $$ = novo_no("exp", filhos, 3);  
    }
    | tipo fator  {
                            No** filhos = (No**) malloc(sizeof(No*)*2);
                            filhos[0] = $1;
                            filhos[1] = $2;

                            for(int i = 0; i < prox_posicao_livre; i++){
                                if(!strcmp($2, tabela_de_simbolos[i].lexema)){
                                    printf("Variavel ja declarada! %s", $2);
                                    return;
                                }
                            }
                            RegistroTS registro;
                            strncpy(registro.token, "ID", 50);
                            strncpy(registro.lexema, $2, 50);
                            strncpy(registro.tipo, $1, 50);
                            registro.endereco = prox_mem_livre;
                            inserir_na_tabela_de_simbolos(registro);
                            if(strcmp($1, "int") == 0){
                                prox_mem_livre += 4;
                                break;
                            }
                            if(strcmp($1, "float") == -3){
                                prox_mem_livre += 8;
                                break;
                            }
                            if(strcmp($1, "char") == -5){
                                prox_mem_livre += 1;
                                break;
                            }
                            
                            

                            $$ = novo_no("exp", filhos, 2);  
    }
    |tipo fator abrir fator fechar {
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = $3;
                            filhos[2] = $5;

                            for(int i = 0; i < prox_posicao_livre; i++){
                                if(!strcmp($2, tabela_de_simbolos[i].lexema)){
                                    printf("Variavel ja declarada! %s", $5);
                                    return;
                                }
                            }
                            RegistroTS registro;
                            strncpy(registro.token, "ID", 50);
                            strncpy(registro.lexema, $2, 50);
                            strncpy(registro.tipo, $1, 50);
                            registro.endereco = prox_mem_livre;
                            inserir_na_tabela_de_simbolos(registro);
                            if(strcmp($1, "int") == 0){
                                prox_mem_livre += (4 * atoi($4));
                                break;
                            }
                            if(strcmp($1, "float") == -3){
                                prox_mem_livre += (32 * atoi($4));
                                break;
                            }
                            if(strcmp($1, "char") == -5){
                                prox_mem_livre += (1 * atoi($4));
                                break;
                            }
                            if(strcmp($1, "char") == -6){
                                prox_mem_livre += (1 * atoi($4));
                                break;
                            }

                            $$ = novo_no("exp", filhos, 3);  
    }
    | termo abrir termo fechar ATRIBUICAO exp {
                            No** filhos = (No**) malloc(sizeof(No*)*4);
                            filhos[0] = $2;
                            filhos[1] = $4;
                            filhos[2] = novo_no("=", NULL, 0);
                            filhos[3] = $6;

                            $$ = novo_no("exp", filhos, 4);
    }
    ;

fator: termo 
    | fator MUL termo {
                                No** filhos = (No**) malloc(sizeof(No*)*3);
                                filhos[0] = $1;
                                filhos[1] = novo_no("*", NULL, 0);
                                filhos[2] = $3;

                                $$ = novo_no("termo", filhos, 3);


                                }
    | fator DIV termo {
                                No** filhos = (No**) malloc(sizeof(No*)*3);
                                filhos[0] = $1;
                                filhos[1] = novo_no("/", NULL, 0);
                                filhos[2] = $3;

                                $$ = novo_no("termo", filhos, 3);
                                }
    
    ;

tipo: TIPO { $$ = novo_no($1, NULL, 0); }
    ;
abrir: ABRE_PAR { $$ = novo_no($1, NULL, 0); }
    | ABRE_CHAVE { $$ = novo_no($1, NULL, 0); }
    | ABRE_COLCHETE { $$ = novo_no($1, NULL, 0); }
    ;
fechar: FECHA_PAR { $$ = novo_no($1, NULL, 0); }
    | FECHA_CHAVE { $$ = novo_no($1, NULL, 0); }
    | FECHA_COLCHETE { $$ = novo_no($1, NULL, 0); }
    ;
operador: OP_LOGICA { $$ = novo_no($1, NULL, 0); }
    ;
termo: TYPE_INTEGER { $$ = novo_no($1, NULL, 0);}
    | TYPE_FLOAT { $$ = novo_no($1, NULL, 0); }
    | ID { $$ = novo_no($1, NULL, 0); }
    | TYPE_STRING { $$ = novo_no($1, NULL, 0); }
    ;

%%

/* Código C geral, será adicionado ao final do código fonte 
 * C gerado.
 */

No* allocar_no(int num_filhos) {
    return (No*) malloc(sizeof(No)* num_filhos);
}

void liberar_no(No* no) {
    free(no);
}

No* novo_no(char token[50], No** filhos, int num_filhos) {
    No* no = allocar_no(1);    
    snprintf(no->token, 50, "%s", token);
    no->num_filhos= num_filhos;
    no->filhos = filhos;

    return no;
}

void imprimir_arvore(No* raiz) {
    
     if(raiz->filhos != NULL) {
        printf("[%s", raiz->token);
        for(int i = 0; i < raiz->num_filhos; i++) {
            imprimir_arvore(raiz->filhos[i]);
        }
        printf("]");
    }
    else {
        printf("[%s]", raiz->token);
    }
}

void inserir_na_tabela_de_simbolos(RegistroTS registro) {
    if (prox_posicao_livre == TAM_TABELA_DE_SIMBOLOS) {
        printf("Impossivel adicionar! Tabela de Simbolos Cheia!");
        return;
    }
    tabela_de_simbolos[prox_posicao_livre] = registro;
    prox_posicao_livre++;
}

void imprimir_tabela_de_simbolos(RegistroTS *tabela_de_simbolos) {
    printf("----------- Tabela de Simbolos ---------------\n");
    for(int i = 0; i < prox_posicao_livre; i++) {
        printf("{%s} -> {%s} -> {%s} -> {%x}\n", tabela_de_simbolos[i].token, \
                                               tabela_de_simbolos[i].lexema, \
                                               tabela_de_simbolos[i].tipo, \
                                               tabela_de_simbolos[i].endereco);
        printf("---------\n");
    }
    printf("----------------------------------------------\n");
    printf("%d - %d", prox_mem_livre, prox_posicao_livre);
}

int main(int argc, char** argv) {
    yyparse();
}

yyerror(char *s) {
    fprintf(stderr, "ERRO: %s\n", s);
}

