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
    int tipo;
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
int esta_na_tabela_de_simbolos(char*);
void inserir_na_tabela_de_simbolos(RegistroTS);

%}

/* Declaração de Tokens no formato %token NOME_DO_TOKEN */
%union 
{
    int number;
    char simbolo[50];
    struct No* no;
}
%token NUM
%token ADD
%token SUB
%token MUL
%token DIV
%token APAR
%token FPAR
%token ACHAVE
%token FCHAVE
%token EOL
%token ID
%token TIPO
%token ATTR
%token PV
%token IF
%token WHILE

%type<no> termo
%type<no> fator
%type<no> exp
%type<no> const
%type<no> sttmt
%type<no> atrib
%type<no> prog
%type<no> dec

%type<simbolo> ID
%type<simbolo> NUM
%type<simbolo> TIPO
%type<simbolo> MUL
%type<simbolo> DIV
%type<simbolo> SUB
%type<simbolo> ADD
%type<simbolo> ATTR
%type<simbolo> PV



%%
/* Regras de Sintaxe */

prog: 
    prog sttmt PV{
                            imprimir_arvore($2);printf("\n\n");
                            imprimir_tabela_de_simbolos(tabela_de_simbolos);
                            }
;

sttmt: sttmt

    | WHILE APAR fator FPAR ACHAVE sttmt FCHAVE {

                            No** filhos = (No**) malloc(sizeof(No*)*8);
                            filhos[0] = novo_no("while", NULL, 0);
                            filhos[1] = novo_no("(", NULL, 0);
                            filhos[2] = $3;
                            filhos[3] = novo_no(")", NULL, 0);
                            filhos[4] = novo_no("{", NULL, 0);
                            filhos[5] = $6;
                            filhos[6] = novo_no("}", NULL, 0);
                            
                            No* raiz_prog = novo_no("while", filhos, 7); 
                            $$ = raiz_prog;

                            
                            }
    
    | IF APAR fator FPAR ACHAVE sttmt FCHAVE {
                            No** filhos = (No**) malloc(sizeof(No*)*8);
                            filhos[0] = novo_no("if", NULL, 0);
                            filhos[1] = novo_no("(", NULL, 0);
                            filhos[2] = $3;
                            filhos[3] = novo_no(")", NULL, 0);
                            filhos[4] = novo_no("{", NULL, 0);
                            filhos[5] = $6;
                            filhos[6] = novo_no("}", NULL, 0);
                            
                            No* raiz_prog = novo_no("if", filhos, 7); 
                            $$ = raiz_prog;

                            
                            }
    | atrib
    | dec

    ;


termo: fator               
   | termo ADD fator       {
                            
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("+", NULL, 0);
                            filhos[2] = $3;
                            No* raiz_stmt = novo_no("termo", filhos, 3); 
                            $$ = raiz_stmt;
                         }
   | termo SUB fator       { 
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("-", NULL, 0);
                            filhos[2] = $3;
                            No* raiz_stmt = novo_no("termo", filhos, 3); 
                            $$ = raiz_stmt;
                        }
   ;

fator: const | ID            
     | fator MUL const  { 
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("*", NULL, 0);
                            filhos[2] = $3;
                            No* raiz_termo = novo_no("fator", filhos, 3); 
                            $$ = raiz_termo;
                        }
     | fator DIV const  {  
                            No** filhos = (No**) malloc(sizeof(No*)*3);
                            filhos[0] = $1;
                            filhos[1] = novo_no("/", NULL, 0);
                            filhos[2] = $3;
                            No* raiz_termo = novo_no("fator", filhos, 3); 
                            $$ = raiz_termo;
                        }
     ;


    
    dec:  TIPO ID {
            int var_existe = esta_na_tabela_de_simbolos($2);
            if (!var_existe) { 
                $$ = novo_no($1, NULL, 0);
                RegistroTS registro;
                strncpy(registro.token, "ID", 50);
                strncpy(registro.lexema, $2, 50);
                registro.tipo = INT;
                registro.endereco = prox_mem_livre;
                prox_mem_livre += 4;
                inserir_na_tabela_de_simbolos(registro);
            }
            else {
                printf("Erro! Múltiplas declarações de variável");
                exit(1);
            }
            imprimir_tabela_de_simbolos(tabela_de_simbolos);
        }
        ;

    atrib: ID ATTR const{}
        ;

        const: NUM { $$ = novo_no($1, NULL, 0); };
%%

/* Código C geral, será adicionado ao final do código fonte 
 * C gerado.
 */

No* allocar_no(int num_filhos) {
    No* no = (No*) malloc(sizeof(No));
    no->num_filhos = num_filhos;
    if (no->num_filhos == 0) {
        no->filhos = NULL;
    }

    return no;
    
}

void liberar_no(No* no) {
    free(no);
}

No* novo_no(char token[50], No** filhos, int num_filhos) {
   No* no = allocar_no(num_filhos);
   no->filhos = filhos;
   snprintf(no->token, 50, "%s", token);

   return no;
}

int esta_na_tabela_de_simbolos(char *variavel) {
    for(int i = 0; i < prox_posicao_livre; i++) {
            if( strncmp(tabela_de_simbolos[i].lexema, variavel, 50) == 0) {
            return 1;
        }
    }
    return 0;
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
        printf("Erro! Tabela de Símbolos Cheia!");
        return;
    }
    tabela_de_simbolos[prox_posicao_livre] = registro;
    prox_posicao_livre++;
}

void imprimir_tabela_de_simbolos(RegistroTS *tabela_de_simbolos) {
    printf("----------- Tabela de Símbolos ---------------\n");
    for(int i = 0; i < prox_posicao_livre; i++) {
        printf("{%s} -> {%s} -> {%d} -> {%x}\n", tabela_de_simbolos[i].token, \
                                               tabela_de_simbolos[i].lexema, \
                                               tabela_de_simbolos[i].tipo, \
                                               tabela_de_simbolos[i].endereco);
        printf("---------\n");
    }
    printf("----------------------------------------------\n");
}

int main(int argc, char** argv) {
    yyparse();
}

yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}

