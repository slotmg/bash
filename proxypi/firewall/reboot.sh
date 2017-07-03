#!/bin/bash

data=`date`
log="/var/log/manager/reboot.log"
codigo=`echo $RANDOM`

clear
echo "Tem certeza que deseja REINICIAR o servidor? [S/N]"
read resposta

echo "#===" >> $log
echo >> $log
echo "Data.: $data" >> $log

        if [ "$resposta" = "S" ] || [ "$resposta" = "s" ]
                then
                clear
                echo "Digite o codigo $codigo para REINICIAR o servidor."
                read resposta

                        if [ "$resposta" = "$codigo" ]
                        then
				 echo "Qual o motivo do restart do servidor?"
				 read motivo
                                 echo "Reiniciando o servidor...."
				 sleep 5
                                 echo "Servidor reiniciado com sucesso. Motivo.: $motivo" >> $log
				 echo "Pressione [Enter] para continuar."
                                 read
				 sudo $(which reboot)
                                 exit
                        else
                                echo "Codigo errado! Tente novamente."
                        fi

                else

                                echo "Operacao cancelada! Pressione [Enter] Para sair."
                                read
                                exit

                fi

                		echo "Digite o codigo $codigo para REINICIAR o servidor."
                                read resposta

                        while [ "$resposta" != "$codigo" ]
                                do

                                echo "Codigo errado! Tente novamente."

                		echo "Digite o codigo $codigo para REINICIAR o servidor."
                                read resposta

					if [ "$resposta" = "$codigo" ]
                		        then
                                			echo "Qual o motivo do restart do servidor?"
                                 			read motivo
                                 			echo "Reiniciando o servidor...."
                                 			sleep 5
                                 			echo "Servidor reiniciado com sucesso. Motivo.: $motivo" >> $log
                                 			echo "Pressione [Enter] para continuar."
                                 			read
				 			sudo $(which reboot)
	                               			exit

                        		fi

                        done
