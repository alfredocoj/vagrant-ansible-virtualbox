#!/bin/bash

# Passo a passo para utilizar este script.
# 1. Abra o terminal linux através do atalho: Crt+T
# 2. No terminal, execute o comando: $ sudo su
# 3. Copie esse arquivo para a pasta de sua preferência; ex.: $ cp instalacao_dev.sh /home/seu_usuario/
# 4. Acesse a pasta onde está o arquivo instalacao_dev.sh; ex.: $ cd /home/seu_usuario/
# 5. Execute o comando: $ chmod +x instalacao_dev.sh
# 5. Execute o script através do comando: sudo bash instalacao_dev.sh


usage="$(basename "$0") [-h] [-k] [-s n] -- script for basic installation of It Happens development environment.

where:
    -h  show this help text
    -k  create key ssh
    -s  set the seed value (default: 42)"

seed=42
export sshParam=0

while getopts ':hks:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    k) echo "O script irá criar automaticamente sua chave ssh"
        sshParam=1
       ;;
    s) seed=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

sudo unlink /etc/localtime

sudo ln -s /usr/share/zoneinfo/America/Fortaleza /etc/localtime

printf "\n\rINICIANDO SCRIPT DE INSTALAÇÃO PARA DESENVOLVEDORES DA IT HAPPENS - GRUPO MATEUS ... \n\r"

# atualização dos indices dos pacotes
if ! sudo apt update -y
then
    printf "Não foi possível atualizar os repositórios. Verifique seu arquivo /etc/apt/sources.list\n\r"
    exit 1
fi

echo "Atualização de repositório feita com sucesso\n\r"


# compiladores do c++
if ! sudo apt install build-essential -y
then
    printf "Não foi possível instalar o pacote build-essential\n\r"
    exit 1
fi
printf "Instalação dos compilador do c++ finalizada\n\r"


# driver para conectar ao sql server, postgresql
if ! sudo apt install unixodbc unixodbc-dev freetds-dev freetds-bin tdsodbc postgresql-server-dev-all -y
then
    printf "Não foi possível instalar os drivers para conectar ao sql server, postgresql\n\r"
    exit 1
fi
printf "Instalação dos drivers sqlserver, postgresql finalizada...\n\r"

# stack trace do compilador do c++
if ! sudo apt install libx11-xcb-dev libdw1 libdw-dev -y
then
    printf "Não foi possível instalar as libs libdw1 libdw-dev\n\r"
    exit 1
fi
printf "Instalação das libs libdw1 libdw-dev finalizada...\n\r"

# libs extras
if ! sudo apt install libcurl4-openssl-dev -y
then
    printf "Não foi possível instalar as bibliotecas libcurl4-openssl-dev\n\r"
    exit 1
fi
printf "Instalação das bibliotecas libcurl4-openssl-dev finalizada...\n\r"

# bibliotecas para exibição de gráficos opengl para o qtcreator funcionar a compilação
if ! sudo apt install libgl1-mesa-dev -y
then
    printf "Não foi possível instalar as bibliotecas para exibição gráficas\n\r"
    exit 1
fi
printf "Instalação das bibliotecas para exibição gráficas finalizada...\n\r"

# instalar o icecc - compilação distribuida
if ! sudo apt install icecc -y
then
    printf "Não foi possível instalar o icecc\n\r"
    exit 1
fi
printf "Instalação do icecc finalizada...\n\r"

# instalaca  do sublime
if ! sudo apt install sublime-text -y
then
    printf "Não foi possível instalar o sublime\n\r"
    exit 1
fi
printf "Instalação do sublime finalizada...\n\r"

# sistema de controle de versões
if ! sudo apt install git-all -y
then
    printf "Não foi possível instalar o git\n\r"
    exit 1
fi
printf "Instalação do git finalizada...\n\r"

if ! sudo apt-get install yakuake -y
then
    printf "Não foi possível instalar o terminal yakuake\n\r"
    exit 1
fi
printf "Instalação do git yakuake...\n\r"

if ! sudo apt-get install htop -y
then
    printf "Não foi possível instalar o terminal htop\n\r"
    exit 1
fi
printf "Instalação do git htop...\n\r"

echo "Configuração do IECC iniciada...\n\r"
sudo sed -i 's/ICECC_NETNAME=""/ICECC_NETNAME="node"/' /etc/icecc/icecc.conf


sudo sed -i 's/ICECC_SCHEDULER_HOST=""/ICECC_SCHEDULER_HOST="icecc.mateus"/' /etc/icecc/icecc.conf
echo "Configuração do IECC finalizado...\n\r"

echo "Configuração do Drive ODBC iniciada...\n\r"
echo -e "[freetds]\r\ndescription    = v0.63 with protocol v8.0\r\ndriver    = /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so\r\nsetup    = /usr/lib/x86_64-linux-gnu/odbc/libtdss.so\r\nusagecount    = 1" >> /etc/odbcinst.ini
echo "Configuração do Drive ODBC finalizada...\n\r"

printf "\n\rSCRIPT FINALIZADO ... \n\r"
