#!/bin/bash
#script para instalar Citrix Workspace en Ubuntu 20.04
#https://www.comoinstalarlinux.com/citrix-ica-client-para-linux-ubuntu-y-linux-mint/

#Colores
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
blueColour="\e[0;34m\033[1m"
purpleColour="\e[0;35m\033[1m"
endColour="\033[0m\e[0m"

trap ctrl_c INT
function ctrl_c(){
        echo -e "\n${redColour}Programa Terminado {endColour}"
        exit 0
}

CITRIX=icaclient_13.10.0.20_amd64.deb
CERT="http://www2.mecon.gov.ar/camecon2/cacert.crt"

echo -e "${yellowColour}Instalando dependencias ${endColour}"
sudo apt update && sudo apt install -y wget curl

echo -e "${yellowColour}Descarga el instalador ${endColour}"
wget -q https://www.citrix.com/es-mx/downloads/citrix-receiver/linux/receiver-for-linux-latest.html

URL_CITRIX=$(grep -i '//downloads.citrix.com/14822/icaclient_13.10.0.20_amd64.deb?__gda__=' receiver-for-linux-latest.html | awk '{print $8}' | cut -d= -f3 | tr '"' " ")

curl -H "User-Agent:'bot 1.0'" "https://downloads.citrix.com/14822/icaclient_13.10.0.20_amd64.deb?__gda__=${URL_CITRIX}" --output "$CITRIX"

echo -e "${yellowColour}Instalando el paquete ${endColour}"
sudo dpkg -i "$CITRIX"; sudo apt install -f -y

echo -e "${yellowColour}Descargar el certificado ${endColour}"
sudo wget -q "$CERT" -O /usr/share/ca-certificates/mozilla/cacert.crt

echo -e "${yellowColour}Link simbolico a certificados ${endColour}"
sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/
sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/ 2>/dev/null
sudo ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/firefox-addons/plugins/npica.so

echo -e "${greenColour}Todos los procesos terminaron correctamente!! {endColour}"
