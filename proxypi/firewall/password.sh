#//bin/bash

clear
echo "Tem certeza que deseja realizar a troca de sua senha de acesso? [s/N]"
read resposta

if [ "$resposta" = "s" ] || [ "$resposta" = "S" ];then
	clear
	tput setaf 1
	echo "[ATENCAO].
	Para sua seguranca, utilize senhas fortes, contendo letras, numeros e caracteres especiais.
	Ex.: #Modificar@2017$"
	sleep 3
	clear
	
	sudo passwd test

	if [ $? = 0 ];then
		clear
		tput setaf 2
		echo "[SUCESSO]. Sua senha foi alterada."
		sleep 3
		tput reset
	else
		clear
		tput setaf 1
		echo "[ERROR]. Sua senha nao foi alterada. Refaca o procedimento. Se o problema perscistir, contact o suporte."
		sleep 3
		tput reset
	fi
else
	exit
fi
