#//bin/bash

clear
if [ $(ls /var/run/firewall.pid | wc -l ) = 1 ]; then
	echo "Firewall executando com o PID $(cat /var/run/firewall.pid)"
	sleep 2
	clear
	echo "Deseja visualizar as regras de Firewall? [s/N]"
	read resposta

	if [ "$resposta" = "s" ] || [ "$resposta" = "S" ]; then
		echo "Nota.: Utilize as setas de navegacao para visualizar as regras. Para sair, pressione a letra q"
		sudo nft list ruleset | less
	else
		exit
	fi
else
	clear
	echo "O Firewall nao esta em execucao!"
	sleep 2
fi
