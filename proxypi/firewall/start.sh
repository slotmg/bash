#//bin/bash

clear
if [ $( ls /var/run/firewall.pid | wc -l) = 0 ]; then
	clear
	echo "Aguarde, iniciando Firewall..."
	sleep 2
	$firewall start
	clear
	tput setaf 2
	echo "[SUCESSO] - Firewall inicializado com sucesso"
	sleep 3
else
	tput setaf 1
	echo "[ERROR] - O Firewall encontra-se em execucao. Pare e depois inicie novamente, ou execute com a opcao restart"
	sleep 3
	tput reset
fi
