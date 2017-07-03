#//bin/bash

clear
echo "Qual o computador deseja liberar o acesso total a INTERNET? Digite o seu endereco IP
Ex.: 192.168.1.10"
read ip
clear

echo "Qual o usuario que utiliza este computador?
Ex.: Joao"
read nome
clear

echo "$ip|$nome" >> "$semproxy"

echo "Aguarde, aplicando as configuracoes..."
sleep 2
$firewall restart 
clear

if [ $? = 0 ];then
	tput setaf 2
        echo "[SUCESSO]. Acesso a Internet liberado com sucesso"
        sleep 3
        clear
else
        tput setaf 1
        echo "[ERROR]. Nao foi possivel aplicar as configuracoes. Efetue o processo novamente. Se o problemas perscistir, contact o suporte tecnico."
        sleep 3
        tput reset
        clear
    
	#=== Remove input error
	
	sed -i '$d' "$semproxy"
       
fi
