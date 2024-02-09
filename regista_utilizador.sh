#!/bin/bash
export SHOW_DEBUG=1    ## Comment this line to remove @DEBUG statements

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2022/2023
##
## Aluno: Nº: 110993      Nome: André Soares
## Nome do Módulo: regista_utilizador.sh
## Descrição/Explicação do Módulo:
## explicado em cada alinea :)
##
##############################################################################

nome=$1
senha=$2
saldo=$3
contribuinte=$4

# 1.1
# 1.1.1
if [[ $# -eq 3 || $# -eq 4 ]]; then 
# se o nºargs for menor ou igual a 3 OU for greater ou equal a 4 :
    ./success 1.1.1
else 
    ./error 1.1.1
    exit 1
fi

# 1.1.2 
nome_verified=$(cut -d":" -f5 /etc/passwd | sed 's/,//g' | grep -w "$nome")
# vai buscar o campo 5 na pasta /etc/passwd depois substitui as "," e mete "" depois vais buscar o nome igual(-w) ao que o utilizador introduziu
if [ "$nome_verified" = "$nome" ]; then
    ./success 1.1.2
else
    ./error 1.1.2
    exit 1
fi
# 1.1.3

if [[ $saldo =~ ^[0-9]+$ ]]; then 
# o saldo tem de ser format "number" e tem de ter valores entre 0-9 e têm de ser positivos
    ./success 1.1.3
else 
    ./error 1.1.3
    exit 1
fi

# 1.1.4

if [ -z $contribuinte ] || [[ $contribuinte =~ ^[0-9]{9}$ ]]; then 
# se o contribuinte for "empty" OU o contribuinte tiver valores entre 0-9 (pos) e estiver limitado por 9 digitos entao -> success se nao error
    ./success 1.1.4
else
    ./error 1.1.4
    exit 1
fi

# 1.2.1 + 1.2.2

if [ -e utilizadores.txt ]; then
# verifica se o utilizadores.txt existe se der error cria o utilizadores.txt
    ./success 1.2.1
else
    ./error 1.2.1
    #1.2.2
    touch utilizadores.txt
    if [ -e utilizadores.txt ]; then
        ./success 1.2.2
    else
        ./error 1.2.2
        exit 1
    fi
fi

# 1.2.3 => se for success segue este sequencia 1.3->1.3.1->1.3.2 se for error segue esta 1.2.4->1.2.5->1.2.6->1.2.7

if ( grep "$nome" "utilizadores.txt" ); then 
# vai buscar a linha correspondente ao nome inserido verificando se existe no ficheiro utilizadores
    ./success 1.2.3

    # 1.3.1
    user_senha=$(grep "$nome" utilizadores.txt | cut -d':' -f3) 
    # vai buscar a linha onde esta o nome e extrai o 3 campo (o da senha)
    if [ "$senha" = "$user_senha" ]; then
        ./success 1.3.1
    else
        ./error 1.3.1
        exit 1
    fi

    # 1.3.2 
    saldo_anterior=$(grep "$nome" utilizadores.txt | cut -d':' -f6)
    # vai buscar o saldo associado ao nome ( que esta no campo 6)
    saldo_adicionar=$(($saldo_anterior+$saldo))
    IDteste=$(grep "$nome" utilizadores.txt | cut -d':' -f1)
    # tambem associado ao mesmo nome vou buscar o ID associado
    updated_data=$(awk -F":" -v IDteste="$IDteste" -v saldo_anterior="$saldo_anterior" -v saldo_adicionar="$saldo_adicionar" -v OFS=":" '$1 == IDteste {gsub(saldo_anterior,saldo_adicionar,$6); print}' utilizadores.txt)
    # inicializo as variaveis no awk , OFS ->  output field separator , 
    # se o 1 campo (que é o id) corresponder ao ID do utilizador que esta a adicionar saldo corresponder
    # entao (usando a funcao implimentada do AWK gsub -> permite mudar qualquer num campo escolhido) mudo o saldo anterior pelo saldo novo no campo 6 , mantendo os restos dos dados
    sed -i "/$nome/ s/.*/$updated_data/g" utilizadores.txt
    # ecnontrado a linha correspondente ao nome troca essa linha toda pela nova "data" do utilizador , neste caso o saldo novo
    if [ $? -eq 0 ]; then
        ./success 1.3.2 "$saldo_adicionar"
    else
        ./error 1.3.2
    fi


else 
    ./error 1.2.3

    # 1.2.4
    if [ ! -z "$contribuinte" ]; then
    # se o contribuinte nao for vazia , entao significa que é para registar o utilizador
        ./success 1.2.4
    else
        ./error 1.2.4
        exit 1
    fi

    # 1.2.5
    if [ -s "utilizadores.txt" ]; then
    # se o ficheiro tiver informacao ( nao ter 0 kb )
        last_ID=$(tail -n 1 "utilizadores.txt" | cut -d':' -f1)
        # vai buscar o ultimo ID e soma + 1 se nao mete o ID a 1
        ID=$((last_ID+1))
        ./success 1.2.5 "$ID"
    else
        ./error 1.2.5 "1"
        ID=1
    fi

    # 1.2.6 
    primeiro_nome_email=$(awk '{print tolower($1)}' <<< $nome) 
    ultimo_nome_email=$(awk '{print tolower($NF)}' <<< $nome) 
    if [[ "$primeiro_nome_email" != "$ultimo_nome_email" ]]; then
        email=$primeiro_nome_email.$ultimo_nome_email@kiosk-iul.pt
        ./success 1.2.6 "$email"
    else 
        ./error 1.2.6
        exit 1
    fi

    # 1.2.7
    user_data="$ID:$nome:$senha:$email:$contribuinte:$saldo"
    echo $user_data >> "utilizadores.txt"
    if [ $? -eq 0 ]; then
        ./success 1.2.7 "$user_data"
    else   
        ./error 1.2.7
    fi
fi

# 1.4
# 1.4.1
sort -t: -k6,6nr "utilizadores.txt" > "saldos-ordenados.txt"
# field separator - ":" e ordena a partir do campo 6 pela ordem descrescente o ficheiro utilizadores e mete no ficheiro saldos-ordenados
if [ $? -eq 0 ]; then
    ./success 1.4.1
else   
    ./error 1.4.1
fi