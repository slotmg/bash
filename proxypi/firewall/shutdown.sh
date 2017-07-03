#/bin/bash

data=`date +%d/%m/%Y - %H:%M:%S`
log="/var/log/manager/shutdown.log"
codigo=`echo $RANDOM`

clear
echo "Tem certeza que deseja DESLIGAR o servidor? [s/N]"
read resposta

echo "#===" >> $log
echo >> $log
echo "Data.: $data" >> $log

if [ "$resposta" = "S" ] || [ "$resposta" = "s" ];then
	clear
	echo "Digite o codigo $codigo para DESLIGAR o servidor."
	read resposta

		if [ "$resposta" = "$codigo" ];then
			 echo "Qual o motivo do desligamento do servidor?"
			 read motivo
                         echo "Desligando o servidor...."
			 sleep 5
                         echo "Servidor desligado com sucesso. Motivo.: $motivo" >> $log
			 echo "Pressione [Enter] para continuar."
                         read
			 sudo /sbin/init 0
                         exit
		else
                                echo "Codigo errado! Tente novamente."
                        fi

                else

                                echo "Operacao cancelada! Pressione [Enter] Para sair."
                                read
                                exit

                fi

                		echo "Digite o codigo $codigo para DESLIGAR o servidor."
                                read resposta

                        while [ "$resposta" != "$codigo" ]
                                do

                                echo "Codigo errado! Tente novamente."

                		echo "Digite o codigo $codigo para DESLIGAR o servidor."
                                read resposta

					if [ "$resposta" = "$codigo" ]
                		        then
                                			echo "Qual o motivo do desligamento do servidor?"
                                 			read motivo
                                 			echo "Desligando o servidor...."
                                 			sleep 5
                                 			echo "Servidor desligado com sucesso. Motivo.: $motivo" >> $log
                                 			echo "Pressione [Enter] para continuar."
                                 			read
                                 			sudo /sbin/init 0
                                 			exit

					fi

done
