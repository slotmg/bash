#!/bin/bash
# vi:si:et:sw=4:sts=4:ts=4
#===============================================================================
# AUTOR       : Gustavo Soares <gustavo@ontic.com.br>
# DATA        : Seg 28/Abr/2014 hs 15:05
# SHELL       : |FILENAME| 
# DESCRICAO   : ler o changelog do kernel.org
# DEPENDENCIA : 
#===============================================================================
echo "Verificando ultima versao disponivel no www.kernel.org"
curl --silent --output /tmp/$$ https://www.kernel.org 
versao=$(egrep "ChangeLog" /tmp/$$ | head -n1 | cut -d "-" -f2 | cut -d "\"" -f1)
echo "Ultima versao: ${versao}"
echo "Versao instalada: $(uname -r)"
URL="https://www.kernel.org/pub/linux/kernel/v4.x/ChangeLog-${versao}"
curl --silent ${URL} | egrep -A 2 "Date:" | egrep -v "(^$|--|Date:)" | less
rm -f /tmp/$$
echo "wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-${versao}.tar.xz"
