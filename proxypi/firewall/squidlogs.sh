#//bin/bash

clear
echo "Digite o endero IP do computador que deseja vericar os Logs de acesso a Internet (Realtime)."
read ip
clear
tput setaf 1
echo "[ATENCAO] Para fechar a tela de logs, pressione as teclas ctrl+c."
sleep 3
tput reset

	sudo $(which tailf) /var/log/squid/access.log | $(which grep) --color $ip
