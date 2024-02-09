#!/bin/bash
export SHOW_DEBUG=1    ## Comment this line to remove @DEBUG statements

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2022/2023
##
## Aluno: Nº: 110993      Nome: André Simoes Soares
## Nome do Módulo: compra.sh
## Descrição/Explicação do Módulo: 
## explicado em cada alinea :)
##
###############################################################################

# 2.1.1
if [ -e produtos.txt ] && [ -e utilizadores.txt ]; then
    ./success 2.1.1
else
    ./error 2.1.1
    exit 1
fi

# 2.1.1 a especie de menu escolha ?
function maquina_venda {
    # lê o ficheiro produtos e se o stock for > 0 mostra na STDOUT
    i=1
    while read linha;
    do
    produto=$(echo $linha | cut -d':' -f1)
    preco=$(echo $linha  | cut -d':' -f3)
    stock=$(echo $linha | cut -d':' -f4)
        if [ "$stock" -gt 0 ]; then
                product_info=$"$i: $produto: $preco EUR"
                echo $product_info
                ((i++))
        fi
    done < produtos.txt
    echo "0: Sair"
}
# executa a funcao a cima
maquina_venda

maquina_de_venda=$(maquina_venda)

# 2.1.2
echo "Insira a sua opcao:"
read i_inserido

n_produtos=$(wc -l < produtos.txt)
# retira o n de linhas do produtos.txt = a quantidade de produtos
i_doproduto=$(echo "$maquina_de_venda" |  grep "^$i_inserido" | cut -d':' -f1)
nome_do_produto=$(echo "$maquina_de_venda" |  grep "^$i_inserido" | cut -d':' -f2)
# stock_i=$(echo "$maquina_de_venda" | grep "^$i_inserido" | cut -d':' -f4 | cut -d' ' -f1)
stock_i=$(awk -F: 'BEGIN{i=0} { if ($4<=0 && i='$i_inserido') {i++} print}' produtos.txt)

case $i_inserido in 

    $stock_i)
    ./error 2.1.2
    exit 1
    ;;

    [1-$n_produtos])
        ./success 2.1.2 "$nome_do_produto"
    ;;

    0)
        ./success 2.1.2
        exit 0
    ;;

    *) 
    ./error 2.1.2
    exit 1
    ;;

esac

# 2.1.3

echo "Insira o seu ID:"
read ID_inserido

user_ID=$(grep "^$ID_inserido" utilizadores.txt | cut -d':' -f1)
user_name=$(grep "^$ID_inserido" utilizadores.txt | cut -d':' -f2)
# vao buscar o nome associado ao ID e verifica se o ID existe

if [ ! -z $user_ID ]; then
    ./success 2.1.3 "$user_name"
else
    ./error 2.1.3
    exit 1
fi

# 2.1.4

echo "Insira a sua senha:"
read senha_inserida

ID_senha=$(grep "^$ID_inserido" utilizadores.txt | cut -d':' -f3) 

if [ "$senha_inserida" = "$ID_senha" ]; then
    ./success 2.1.4
 else
    ./error 2.1.4
    exit 1
fi

# 2.2
# 2.2.1

saldo_user=$(grep "^$ID_inserido" utilizadores.txt | cut -d':' -f6)
preco_produto=$(echo "$maquina_de_venda" | grep "^$i_inserido" | cut -d':' -f3 | cut -d' ' -f2)

if (( $saldo_user >= $preco_produto )); then
    ./success 2.2.1 "$preco_produto" "$saldo_user"
else
    ./error 2.2.1 "$preco_produto" "$saldo_user"
    exit 1
fi

# 2.2.2

saldo_descontado=$(($saldo_user-$preco_produto))
updated_saldo_pos_compra=$(awk -F":" -v saldo_user="$saldo_user" -v saldo_descontado="$saldo_descontado" -v ID_inserido="$ID_inserido" -v OFS=":" '$1 == ID_inserido {gsub(saldo_user,saldo_descontado,$6); print}' utilizadores.txt) 
sed -i "/^$ID_inserido/ s/.*/$updated_saldo_pos_compra/g" utilizadores.txt
# mesma ideia da alinea 1.3.1 do script regista utilizador

if [ $? -eq 0 ]; then
    ./success 2.2.2 
else
    ./error 2.2.2
    exit 1
fi

# 2.2.3
stock_atual=$(sed -n "$i_inserido"p produtos.txt | cut -d':' -f4)
# a partir do id inserido vai buscar a linha associada ao ID e retira o campo 4
stock_pos_compra=$(($stock_atual-1))
produto_nome=$(sed -n "$i_inserido"p produtos.txt | cut -d':' -f1)

if [ $stock_pos_compra -lt 0 ]; then
    ./error 2.2.3
    exit 1
else
    updated_stock=$(awk -F":" -v stock_pos_compra="$stock_pos_compra" -v stock_atual="$stock_atual" -v produto_nome="$produto_nome" -v OFS=":" '$1 == produto_nome {gsub(stock_atual,stock_pos_compra,$4); print}' produtos.txt) 
    sed -i "/$produto_nome/ s/.*/$updated_stock/g" produtos.txt
    # mesma ideia da alinea 1.3.1 do script regista utilizador
    ./success 2.2.3 
fi

# 2.2.4

produto_cat=$(sed -n "$i_inserido"p produtos.txt | cut -d':' -f2)

registo_compra="$produto_nome:$produto_cat:$ID_inserido:$(date +'%F')"
echo $registo_compra >> "relatorio_compras.txt"
if [ $? -eq 0 ]; then
    ./success 2.2.4 
else   
    ./error 2.2.4
    exit 1
fi

# 2.2.5

nome_para_lista=$(grep "^$ID_inserido" utilizadores.txt | cut -d':' -f2) 
echo "**** $(date +'%F'): Compras de $nome_para_lista ****" > lista-compras-utilizador.txt
awk -F':' '$3 == '$ID_inserido' {print $1",",$4}' relatorio_compras.txt >> lista-compras-utilizador.txt

if [ $? -eq 0 ]; then
    ./success 2.2.5
    exit 0
else
    ./error 2.2.5
    exit 1
fi