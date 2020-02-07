1.Introdução
    
Um [compilador](https://pt.wikipedia.org/wiki/Compilador) é um programa de computador (ou um grupo de programas) que, a partir de um código fonte escrito em uma linguagem compilada, cria um programa semanticamente equivalente, porém escrito em outra linguagem, código objeto. 
    
    Sua função se resume em ler o código fonte conhecido, identificar possíveis erros de linguagem, definir seus simbolos, preparar suas instruções e codificá-las em código de máquina.
    
    Sua primeira parta, a [análise léxica](https://en.wikibooks.org/wiki/Compiler_Construction/Lexical_analysis) consiste no início da compilação. Nela, temos a definição dos símbolos, registrados em tokens. Estes símbolos podem ser:
    * Definidos pela linguagem, sendo que estes podem ser:
        * palavras reservadas e comandos da linguagem;
        * símbolos relacionais, ariméticos e lógicos;
    * Definidos pelo usuário, podendo ser váriáveis e constantes.
    
    Estas sequencias de símbolos poder ser formadas por letras e outros caracteres, definidos pelo construtor do compilador. Nessa fase, todos os símbolos são separados e distribuídos em tokens, que não podem se repetir. As váriáveis declaradas são colocadas em uma tabela definindo seu tamanho, bem como os outros símbolos da linguagem.

    Após esta etapa, temos a [análise sintática](https://en.wikipedia.org/wiki/Parsing) ou *parsing*, que é onde o compilador vai ver se todas as expressões e instruções escritas estão de acordo com a definição da linguagem, bem como conferir se as contruções estão corretas e se faltam símbolos na escrita do códiogo.

    Geralmente nessa parte, uma [árvore de análise sintática] (https://en.wikipedia.org/wiki/Parse_tree), também chamada de *Parsing Tree* é construída, para que seja análisada mais facilmente. Essa árvore consiste na quebra de todos os comandos e tokens de forma organizada, para suprir as requisições da linguagem.

    Ambos conceitos foram estudados exaustivamente para a construção do trabalho, além dos conceitos de escrita de [FLEX](https://github.com/westes/flex) para análise léxica  e tabelas de símbolos e [BISON](https://www.gnu.org/software/bison/) para construção das árvores de derivação. Apesar de serem bem documentados, sua escrita ainda é um pouco confisa e complexa, e demanda algum estudo mais aprofundado e prático.

2. Ferramentas

    Como anteriormente citado, foram usados o [FLEX](https://github.com/westes/flex) e o [BISON](https://www.gnu.org/software/bison/). 
    Ambos são complementares e seus fontes podem ser facilmente interpretados pelo compilador [GCC](https://gcc.gnu.org/). Após feita a análise léxica, gerando tokens e tabelas, alguns códigos fontes são gerados. Os códigos fontes de FLEX são na forma *arquivo.l*, e sua compilação gera algumas bibliotecas e um novo fonte em C, para a compilação no GCC. tendo feito seu trabalho, o FLEX passa para o BISON tokens que são usados para criar as regras da linguagem e definir a escrita. O BISON cria [parsers GLR](https://en.wikipedia.org/wiki/GLR_parser), ou seja, a linguagem deverá ser pensada com comandos da esquerda para a direita.

    A documentação completa do bison *em inglês* pode ser encontrada [aqui](https://www.gnu.org/software/bison/manual/bison.html), e a do FLEX está em sua [pagina do GitHub](https://github.com/westes/flex).

3. A solução Proposta

    Por demanda, a o parser deveria conter as seguintes propostas:
    
    * declaração de variáveis
    * atribuição
    * expressões aritméticas básicas
    * expressões relacionais e lógicas
    * contenha uma estrutura de seleção (ex, if...else)
    * contenha uma estrutura de repetição (ex, for)
    * vetores
    * Criar a tabela de símbolos

    nos quais todas foram implementadas, excetuando os vetores. 
    Entretanto, a cada nova funcionalidade, várias partes do código tinham que ser mexidas, e talvez pela inexperiência ou pela falta de prática (e um pouco de excesso de outros trabalhos) não foi possivel terminar a solução satisfatóriamente no tempo hábil.
    Ela se encontra 80% pronta, mas ainda não faz completamente, e as vezes, erros que não deveriam ocorrer e linhas que fazem parte da linguagem, criada, ocorrem.

    Por definição, a linguagem da solução é a seguinte:
    * apesar de identificar, a linguagem não define o tamanho das váriáveis corretamente pelo seu tipo, que pode ser *FLOAT, CHAR, INT* e *String*;
    * a linguagem possui apenas o condicional *IF*, sem else;
    * a linguagem possui interpretação aritmética, lógica (and, or, not) e relacional (<, >, <=, >=, ==, !=);
    * a linguagem interpreta o LOOP *WHILE*.

    Como dito, apesar de tudo o trabalho não foi concluído.


4. Conclusão

    Apesar de certamente ser necessário saber como funciona um compilador, criação de compiladores servem para fins específicos. Notadamente, a maioria das linguagens de programação atual possuem bons compiladores. Entretanto pode ser necessário que alguma linguagem não tenha um recurso e que a pessoa precise de um compulador específico.
Inclusive, grandes empresas como [google](https://golang.org/) e [Facebook](https://hacklang.org/) possuem linguagens de programação para atender a demandas da empresa. 
