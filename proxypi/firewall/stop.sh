#//bin/bash

clear
if [ $(ls /var/run/firewall.pid | wc -l ) = 1 ]; then
	echo "Aguarde, parando o Firewall..."
	sleep 2
	$firewall stop
	clear
	tput setaf 2
	echo "[SUCESSO] - Firewall finalizado com sucesso"
	sleep 3
else
	clear
	tput setaf 1
	echo "[ERROR] - O Firewall nao enontra-se em execucao"
	sleep 3
	tput reset
fi
