#!/bin/bash
#script para instalar Citrix Workspace en Ubuntu 20.04
#https://xenit.se/tech-blog/how-to-install-citrix-workspace-on-ubuntu/

#Colores
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
endColour="\033[0m\e[0m"

CITRIX_DEPS=(http://launchpadlibrarian.net/344880892/libwebkitgtk-1.0-0_2.4.11-3ubuntu3_amd64.deb)
CITRIX=icaclient_21.11.0.20_amd64.deb
CERT="http://www2.mecon.gov.ar/camecon2/cacert.crt"

#trap "rm *.deb workspace-app-for-linux-latest.html" EXIT

trap ctrl_c INT
function ctrl_c(){
        echo -e "\n${redColour}Programa Terminado ${endColour}"
        exit 0
}

function citrix_deps(){
echo -e "${yellowColour}Instalando dependencias de citrix ${endColour}"
sudo apt-get update -qq; for i in "${CITRIX_DEPS[@]}"; do wget -q --show-progress --progress=bar:force 2>&1 "$i";done \
	&& sudo dpkg -i *.deb &>/dev/null
}

function citrix_install(){
echo -e "${yellowColour}Descarga el instalador ${endColour}"
wget -q --show-progress --progress=bar:force 2>&1 https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html

local URL_CITRIX=$(grep -i '//downloads.citrix.com/20098/icaclient_21.11.0.20_amd64.deb?__gda__=' workspace-app-for-linux-latest.html | awk '{print $8}' | cut -d'"' -f2)

wget -q --show-progress --progress=bar:force 2>&1 "https:$URL_CITRIX" -O "$CITRIX"

echo -e "${yellowColour}Instalando el paquete ${endColour}"
sudo DEBIAN_FRONTEND=noninteractive dpkg -i "$CITRIX" &>/dev/null; sudo apt-get install -y -f &>/dev/null
}

function cert_install(){
echo -e "${yellowColour}Descargar el certificado ${endColour}"
sudo wget -q --show-progress --progress=bar:force 2>&1 "$CERT" -O /usr/share/ca-certificates/mozilla/cacert.crt

echo -e "${yellowColour}Link simbolico a certificados ${endColour}"
sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/ 2>&1
sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/ 2>/dev/null
sudo ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/firefox-addons/plugins/npica.so 2>&1
}

function mapping(){
# global
sudo sed -i '/IgnoreErrors/a DrivePathH=$HOME\nDriveEnabledH=True\nDriveReadAccessH=0\nDriveWriteAccessH=0\n' /opt/Citrix/ICAClient/nls/es/wfclient.template
# por usuario
# sudo sed -i '/IgnoreErrors/a DrivePathH=$HOME\nDriveEnabledH=True\nDriveReadAccessH=0\nDriveWriteAccessH=0\n' /home/usuario/.ICAClient/wfclient.ini
}

citrix_deps
citrix_install
cert_install
mapping

echo -e "${greenColour}Todos los procesos terminaron correctamente!! ${endColour}"
