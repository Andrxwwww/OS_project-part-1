#!/bin/bash
export SHOW_DEBUG=1    ## Comment this line to remove @DEBUG statements

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2022/2023
##
## Aluno: Nº: 110993       Nome: André Simões Soares
## Nome do Módulo: refill.sh
## Descrição/Explicação do Módulo: 
## explicado em cada alinea :)
##
###############################################################################

# 3.1
# 3.1.1

if [ -e produtos.txt ] && [ -e reposicao.txt ]; then 
# se o ficheiro produtos e reposicao existir (-e) então :
    ./success 3.1.1
else
    ./error 3.1.1
    exit 1
fi

# 3.1.2
function reposicao {
while IFS=: read product _ stock_adicionar; do
# TODO TIRAR O SUCCESS NO LOOP
# loop que passa pelo ficheiro reposicao e a cada vez que há ":"(field separator) ele associa a cada formato (product:categoria:stock_max)
# o comando read faz com que ler os valores nos 3 campos
    if [[ ! $stock_adicionar =~ ^[0-9]+$ ]]; then
    # se o stock max for menor ou igual entao:
        ./error 3.1.2 "$product"
        exit 1
    fi
done < reposicao.txt
./success 3.1.2
}
reposicao

# 3.2.1

echo "**** Produtos em falta em $(date +'%F') ****" > produtos-em-falta.txt
# escreve no final da linha (dando overwrite) a string na echo
awk -F: '{ if($4 < $5) print $1": "$5-$4" unidades"}' produtos.txt >> produtos-em-falta.txt
# se o campo 5 (stockmaximo) for maior que o campo 4 (stockatual) entao imprime o campo 1 (nome do produto e faz a diferenca entre os stocks , que da os stock necessarios para repor)
if [ $? -eq 0 ]; then
    ./success 3.2.1
else   
    ./error 3.2.1
    exit 1
fi

# 3.2.2

update_dados_pos_rep=$(awk 'BEGIN {FS=OFS=":"} 
(getline < "produtos.txt") {produto=$1; tipo=$2; preco=$3; stockat=$4; stockmax=$5}
(getline < "reposicao.txt") {stockad=$3; conta=stockat+stockad}
{if (conta < stockmax) stockat=conta; else stockat=stockmax}
{print produto, tipo, preco, stockat, stockmax}' produtos.txt)
# começamos com field separator e o output field separator a serem os mesmos
# de seguida a cada linha do ficheiro "produtos.txt" (funcao getline implementada do awk) atribuimos variaveis a cada um dos fields [o mesmo para a reposicao.txt]
# condicao para atualizar o stock no ficheiro produtos
# por fim da print da linha do ficheiro produtos.txt e atualiza o stock

echo "$update_dados_pos_rep" > "produtos.txt"
# atualiza os dados para o ficheiro

if [ $? -eq 0 ]; then
# verificaçao de escrita no ficheiro produtos.txt
    ./success 3.2.2
else   
    ./error 3.2.2
    exit 1
fi

