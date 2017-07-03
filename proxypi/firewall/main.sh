#!/bin/bash


Principal()
{

opcao=`dialog  --stdout  \
--backtitle "Rasp Firewall Manager  " \
 --nocancel --menu "Menu" 0 73  13 \
1 "Liberar endereco IP (Computador)" \
2 "Bloquear endereco IP (Computador)" \
3 "Iniciar Firewall" \
4 "Parar Firewall" \
5 "Reiniciar Firewall" \
6 "Verificar Status do Firewall" \
7 "Testar conexao (velocidade de download/upload) com a Internet" \
8 "Visualizar Logs de acesso a Internet (Realtime)" \
9 "Alterar senha de acesso" \
10 "Desligar o servidor" \
11 "Reiniciar o servidor" \
12 "Sair." `

case $opcao in
    1) addip  ;;
    2) delip  ;;
    3) start_firewall ;;
    4) stop_firewall ;;
    5) restart_firewall ;;
    6) status_firewall ;;
    7) test_internet ;;
    8) logs ;;
    9) change_password ;;
    10) shutdown ;;
    11) reboot ;;
    12) clear ; exit ;;

    *) Principal ;;
esac
Principal

}

#=== Global Variables

export firewall="sudo bash /etc/scripts/firewall/firewall.sh"
export semproxy="/etc/scripts/firewall/acls/sem_proxy/hosts.lst"

addip()
{
source addip.sh
}

delip()
{
source delip.sh
}

start_firewall()
{
source start.sh
}

stop_firewall()
{
source stop.sh
}

restart_firewall()
{
source restart.sh
}

status_firewall()
{
source status.sh
}

test_internet()
{
clear
sudo python speedtest.py

if [ $? != 0 ];then
	echo "Nao foi possivel calcular as taxas de Download e Upload. Reveja sua conexao com a Internet."
	sleep 3
else
	echo "Pressione Enter para sair..."
	read
fi
}

logs()
{
source squidlogs.sh
}

change_password()
{
source password.sh
}

shutdown()
{
source shutdown.sh
}

reboot()
{
source reboot.sh
}

#=== Remove Global Variables

export $firewall
export $semproxy

Principal
