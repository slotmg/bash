#!/bin/bash
# vi:si:et:sw=4:sts=4:ts=4
#===============================================================================
# AUTOR       : Gustavo Soares <gustavo@ontic.com.br>
# DATA        : Seg 28/Abr/2014 hs 15:05
# SHELL       : |FILENAME| 
# DESCRICAO   : compila o ultimo kernel para os servidores.
# DEPENDENCIA : 
#===============================================================================
echo "AGUARDE: Verificando ultima versao disponivel no www.kernel.org"
curl --silent --output /tmp/$$ https://www.kernel.org 
versao=$(egrep "ChangeLog" /tmp/$$ | head -n1 | cut -d "-" -f2 | cut -d "\"" -f1)
corrente=$(uname -r)
ncpu=$(lscpu -pcpu | tail -n1)
[[ "${corrente}" != "${versao}" ]] && {
    echo "AGUARDE: Fazendo download do kernel ${versao}."
    wget --continue https://www.kernel.org/pub/linux/kernel/v4.x/linux-${versao}.tar.xz -O /tmp/linux-${versao}.tar.xz
    echo "AGUARDE: Descompactando."
    tar Jxf /tmp/linux-${versao}.tar.xz -C /usr/src
    cp /boot/config-$(uname -r) /usr/src/linux-${versao}/.config
    cd /usr/src/linux-${versao}
    echo "AGUARDE: Executando oldconfig."
    make oldconfig
    echo -e "\n\nAGUARDE: Executando all."
    make -j${ncpu} all 
    echo "AGUARDE: Executando modules_install."
    make -j${ncpu} modules_install 
    echo "AGUARDE: Copiando arquivos."
    cp .config /boot/config-${versao}
    cp System.map /boot/System.map-${versao}
    cp arch/x86_64/boot/bzImage /boot/vmlinuz-${versao}
    cd /lib/modules/$versao
    find . -name *.ko -exec strip --strip-unneeded {} +
    cd /lib/modules
    mkinitramfs -o /boot/initrd.img-${versao} ${versao}
    echo "AGUARDE: Rodando update-grub2"
    update-grub2
}
