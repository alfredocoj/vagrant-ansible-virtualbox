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

if [ "$sshParam" -eq "0" ];
then

    unlink /etc/localtime

    ln -s /usr/share/zoneinfo/America/Fortaleza /etc/localtime

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


	# Install basic software support
	if ! sudo apt update && sudo apt install --yes software-properties-common
	then
		printf "Não foi possível instalar basic software support\n\r"
		exit 1
	fi
	printf "Instalação dos basic software support foi finalizada...\n\r"


	# removendo openjdk
	if ! sudo apt remove openjdk* -y
	then
		printf "Não foi possível remover o openjdk ou ele não está instalado em seu computador\n\r"
		exit 1
	fi
	printf "A remoção do openjdk final\n\r"

	# Add the JDK 8 and accept licenses (mandatory)
	add-apt-repository ppa:webupd8team/java && \
	    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

	# Accept the Oracle License
	echo "oracle-java7-installer  shared/accepted-oracle-license-v1-1 boolean true" > /tmp/oracle-license-debconf
	/usr/bin/debconf-set-selections /tmp/oracle-license-debconf
	rm /tmp/oracle-license-debconf

	# Install Java 8
	if ! sudo apt update && sudo apt install --yes oracle-java8-installer
	then
		printf "Não foi possível instalar Java 8 Oracle\n\r"
		exit 1
	fi
	printf "Instalação do Java 8 Oracle finalizada...\n\r"

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

	if ! sudo apt-get install openssh-server -y
	then
		printf "Não foi possível instalar o terminal openssh-server\n\r"
		exit 1
	fi
	printf "Instalação do git openssh-server...\n\r"

	sudo service sshd start

	echo "Configuração do IECC iniciada...\n\r"
	sudo sed -i 's/ICECC_NETNAME=""/ICECC_NETNAME="node"/' /etc/icecc/icecc.conf


	sudo sed -i 's/ICECC_SCHEDULER_HOST=""/ICECC_SCHEDULER_HOST="icecc.mateus"/' /etc/icecc/icecc.conf
	echo "Configuração do IECC finalizado...\n\r"

	echo "Configuração do Drive ODBC iniciada...\n\r"
	echo -e "[freetds]\r\ndescription    = v0.63 with protocol v8.0\r\ndriver    = /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so\r\nsetup    = /usr/lib/x86_64-linux-gnu/odbc/libtdss.so\r\nusagecount    = 1" >> /etc/odbcinst.ini
	echo "Configuração do Drive ODBC finalizada...\n\r"

	printf "\n\rSCRIPT FINALIZADO ... \n\r"

	if [ -z "$1" ]
	then
	  QT_VERSION=5.12.2
	else
	  QT_VERSION=$1
	fi
	QT_VERSION_FRIST="$(cut -d'.' -f1 <<<"$QT_VERSION")"
	QT_VERSION_SECOND="$(cut -d'.' -f2 <<<"$QT_VERSION")"
	QT_VERSION_MAJOR=$QT_VERSION_FRIST.$QT_VERSION_SECOND

	printf "VERSAO QT A SER INSTALADA: "$QT_VERSION"\n"

	# Compile and install Qt Base

	QT_DIST=/home/$(whoami)/Qt"$QT_VERSION"
	QT_BASE_SRC=https://download.qt.io/official_releases/qt/"$QT_VERSION_MAJOR"/"$QT_VERSION"/submodules/qtbase-opensource-src-"$QT_VERSION".tar.xz
	QT_BASE_DIR=/qtbase-opensource-src-"$QT_VERSION"

	wget https://download.qt.io/archive/qt/${QT_VERSION_MAJOR}/${QT_VERSION}/qt-opensource-linux-x64-${QT_VERSION}.run

	chmod +x qt-opensource-linux-x64-${QT_VERSION}.run

	./qt-opensource-linux-x64-${QT_VERSION}.run --script qt-noninteractive.qs  #-platform minimal

else
	printf 'Criando sua chave ssh...\r\n';

	cd /home/$(whoami)

	ssh-keygen -t rsa

	# mv id_rsa* /home/$(whoami)/.ssh/

	# chmod 0400 /home/$(whoami)/.ssh/id_rsa*

	eval "$(ssh-agent -s)"

	ssh-add /home/$(whoami)/.ssh/id_rsa

	printf 'Sua chave ssh foi criada com sucesso!\r\n';

	ls -la /home/$(whoami)/.ssh/id_rsa*
fi