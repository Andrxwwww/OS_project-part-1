#!/bin/bash
export SHOW_DEBUG=1    ## Comment this line to remove @DEBUG statements

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2022/2023
##
## Aluno: Nº: 110993       Nome: André Simões Soares 
## Nome do Módulo: menu.sh
## Descrição/Explicação do Módulo: 
##
##
###############################################################################

# os echos a baixo vao apresentar o menu com as opcoes
#5.1.1
echo "MENU:"
echo "1: Regista / Atualiza saldo utilizador"
echo "2: Compra produto"
echo "3: Reposição de stock"
echo "4: Estatísticas"
echo "0: Sair"
echo

# validação da opcao escolhida
#5.2
#5.2.1
echo -n "Opção: "
read opt

if [[ $opt =~ ^[0-4]{1}$ ]]; then
    # verifica se a opcao é valida (se começa por um digito entre 0 a 4)
    ./success 5.1.1 "$opt"
else 
    ./error 5.1.1 "$opt"
fi

#5.2.2

case $opt in 

    1) 
    echo "Regista / Atualiza saldo utilizador:"
    echo "Indique o nome do utilizador: ";read nome
    echo "Indique a senha do utilizador: ";read senha
    echo "Para registar o utilizador, insira o NIF do utilizador: ";read contribuinte
    echo "Indique o saldo a adicionar do utilizador: ";read saldo
    ./regista_utilizador.sh "$nome" "$senha" "$saldo" "$contribuinte"
    ./success 5.2.2.1
    ;;

    2) 
    echo "Compra Produto"
    ./compra.sh
    ./success 5.2.2.2
    ;;

    3)
    echo "Reposição de stock"
    ./refill.sh
    ./success 5.2.2.3
    ;;

    4) 
    echo "Estatísticas:"
    echo "1: Listar utilizadores que já fizeram compras "
    echo "2: Listar os produtos mais vendidos "
    echo "3: Histograma de vendas "
    echo "0: Voltar ao menu principal "
    echo 
    echo -n "Sub-Opção: ";read subopt 
    if [[ $subopt =~ ^[0-3]{1}$ ]]; then
        # verifica se a subopcao é valida (se começa por um digito entre 0 a 3)
        case $subopt in

            1)
            echo "1: Listar utilizadores que já fizeram compras"
            ./stats.sh listar
            ;;

            2)
            echo "Listar os produtos mais vendidos:"
            echo "Indique o número de produtos mais vendidos a listar: ";read popularNR
            ./stats.sh popular $popularNR
            ;;

            3)
            echo "3: Histograma de vendas"
            ./stats.sh histograma
            ;;

            0) 
            echo "Voltar ao menu principal"
            ;;

            *)
            echo "opção nao existente"
            ;;
        esac
        ./success 5.2.2.4
    else
        ./error 5.2.2.4
    fi
;;
    0)
    exit
    ;;

    *) 
    echo "Opção nao existente"
    ;;

esac


