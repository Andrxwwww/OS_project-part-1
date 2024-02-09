#!/bin/bash
export SHOW_DEBUG=1    ## Comment this line to remove @DEBUG statements

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2022/2023
##
## Aluno: Nº: 110993       Nome: Andre Simoes Soares 
## Nome do Módulo: stats.sh
## Descrição/Explicação do Módulo: 
##  explicado em cada alinea :)
##
###############################################################################

stat_opt=$1

# 4.1
# 4.1.1

if [[ $# == 1 && $1 = listar ]] || [[ $# == 1 && $1 = histograma ]] || [[ $# == 2 && $1 = popular ]]; then
# "$stat_opt" =~ ^popular\ [0-9]+$  neste caso o =~iguala o argumento passado a começar com popular e seguido de digitos entre 1-9 e positivos
    ./success 4.1.1
else
    ./error 4.1.1
    exit 1
fi

# 4.2

> stats.txt
# apaga o que esta dentro e depois atualiza pelos dados que a funcao a baixo der

case $stat_opt in

# 4.2.1
"listar")
    n_utilizadores=$(wc -l < utilizadores.txt)
    #retirar o nºde utilizadores que existem = nº de linhas
    for (( it=1; it<=$n_utilizadores; it++)); do
        n_compras=$(cut -d':' -f3 relatorio_compras.txt | grep -c $it)
        #para cada "it" ( ou seja cada id ) conta quantas linhas e que o id aparece no campo 3
        nome_p_stats=$(grep ^$it utilizadores.txt | cut -d':' -f2)
        #associado ao id vai buscar o nome ao utilizadores.txt
        if [[ $n_compras -eq 1 ]]; then
        #se aparecer so 1 vez no relatorio de compras o id , significa que so fez 1 compra por, por isso sera compra e plural se for >1
            echo "$nome_p_stats:" $n_compras compra >> stats.txt 
        elif [[ $n_compras -gt 1 ]]; then
            echo "$nome_p_stats:" $n_compras compras >> stats.txt 
        fi
    done
    sortednames=$(sort -t: -k2,2nr stats.txt)
    echo "$sortednames" > stats.txt

if [ $? -eq 0 ]; then
    ./success 4.2.1 
else   
    ./error 4.2.1
    exit 1
fi
;;

# 4.2.2
"popular")
        nr_popular=$2
    if [[ $2 =~ ^[0-9]*$ ]]; then
        # retiro o numero do argumento passado "popular <numero>"
        n_produtos=$(wc -l < produtos.txt)
        # quantidade de produtos disponiveis
        produto=$(cut -d":" -f1 produtos.txt)
        #retiro o nome dos produtos do produtos.txt
        for (( ite=1; ite<=$n_produtos; ite++)); do
            nome_produto_stat=$(awk -v ite=$ite 'NR==ite' produtos.txt | cut -d":" -f1)
            # para cada linha  vou retirar o nome do produto no campo 1
            n_compra_produto=$(cut -d':' -f1 relatorio_compras.txt | grep -c "$nome_produto_stat")
            # aqui vou retirar o nome do produto a ser iterado no relatorio de compras e depois "conto" quantas vezes é que esse produto aparece no relatorio_compras
            if (( $n_compra_produto != 0 )) && (( $n_compra_produto <= $nr_popular )); then
                if (( $n_compra_produto == 1 )); then
            #se aparecer so 1 vez no relatorio de compras o id , significa que so fez 1 compra por, por isso sera compra e plural se for >1
                    echo "$nome_produto_stat:" "$n_compra_produto" compra >> stats.txt
                elif (( $n_compra_produto > 1 )); then
                    echo "$nome_produto_stat:" "$n_compra_produto" compras >> stats.txt
                fi
            fi
        done
        sortednamespopular=$(sort -t: -k2,2nr stats.txt)
        # ordeno o ficheiro stats a partir do field 2 com uma separacao de field com o ":" , e da forma descrecente (r -> reverse)
        echo "$sortednamespopular" > stats.txt
        ./success 4.2.2
    else
        ./error 4.2.2
        exit 1
    fi

;;


# 4.2.3
"histograma")

    categ=$(cut -d":" -f2 produtos.txt | sort | uniq)
    # vais buscar o field 2 do produtos.txt (categoria) depois da sort e retira as repeticoes ficando assim as 4 unicas categorias dos produtos.txt 
    n_de_cat_produto=$(echo $categ | awk -F" " '{print NF}')
    # com as linha dos produtos feita , retiro o numero de categorias disponiveis
    for (( j=1; j<=$n_de_cat_produto; j++)); do
        # loop sobre o nmr de categorias disponiveis
        asteriscos=""
        categoria_unica=$(echo $categ | cut -d" " -f$j)
        # da lista de categorias disponiveis no produtos.txt
        n_cat_vendas=$(cut -d":" -f2 relatorio_compras.txt | grep -c "$categoria_unica")
        # por fim volto a ficar com o field 2 do relatorio_compras e procuro quantas linhas e que contém esse nome
        for (( k=0; k<$n_cat_vendas; k++)); do
        # loop para passar o n de vendas de cada categoria para *
            asteriscos+="*"
        done
        if [ $n_cat_vendas != 0 ]; then
            # se uma categoria tiver 0 vendas eu nao quero que apareça no ficheiro stats
            echo "$categoria_unica" "$asteriscos" >> stats.txt
        fi
    done

if [ $? -eq 0 ]; then
    ./success 4.2.3 
else   
    ./error 4.2.3
    exit 1
fi
;;

*) ./error 4.1.1 # nsei se e este erro
    exit 1
;;

esac
