#!/bin/bash
#script para instalar Citrix Workspace en Ubuntu 20.04
#https://xenit.se/tech-blog/how-to-install-citrix-workspace-on-ubuntu/

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

CITRIX=icaclient_21.1.0.14_amd64.deb
CERT="http://www2.mecon.gov.ar/camecon2/cacert.crt"

echo -e "${yellowColour}Instalando dependencias ${endColour}"
sudo apt update && sudo apt install -y wget curl

echo -e "${yellowColour}Descarga el instalador ${endColour}"
wget -q https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html

URL_CITRIX=$(grep -i '//downloads.citrix.com/19130/icaclient_21.1.0.14_amd64.deb?__gda__=' workspace-app-for-linux-latest.html | awk '{print $8}' | cut -d= -f3 | tr '"' " ")

curl -H "User-Agent:'bot 1.0'" "https://downloads.citrix.com/19130/icaclient_21.1.0.14_amd64.deb?__gda__=${URL_CITRIX}" --output "$CITRIX"

echo -e "${yellowColour}Instalando el paquete ${endColour}"
sudo dpkg -i "$CITRIX" && sudo apt install -y -f

echo -e "${yellowColour}Descargar el certificado ${endColour}"
sudo wget -q "$CERT" -O /usr/share/ca-certificates/mozilla/cacert.crt

echo -e "${yellowColour}Link simbolico a certificados ${endColour}"
sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/
sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/ 2>/dev/null
sudo ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/firefox-addons/plugins/npica.so

echo -e "${greenColour}Todos los procesos terminaron correctamente!! {endColour}"
