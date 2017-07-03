#//bin/bash

clear
echo "Qual o computador deseja BLOQUEAR o acesso total a INTERNET? Digite o seu endereco IP
Ex.: 192.168.1.10"
read ip
clear

echo "Aguarde, aplicando as configuracoes..."
sleep 2

sudo sed -i "/^$ip/d" $semproxy

$firewall restart 
clear

if [ $? = 0 ];then
	tput setaf 2
	echo "[SUCESSO]. Acesso a Internet BLOQUEADO com sucesso para o endereco IP $ip"
	sleep 4
	clear
else
	tput setaf 1
	echo "[ERROR]. Nao foi possivel aplicar as configuracoes. Efetue o processo novamente. Se o problemas perscistir, contact o suporte tecnico."
	sleep 3
	tput reset
	clear
fi
