#!/bin/bash
#script para instalar Citrix Receiver en macOS

#Colores
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
endColour="\033[0m\e[0m"

URL="https://downloads.citrix.com/14596/CitrixReceiver.dmg?__gda__=exp=1632316414~acl=/*~hmac=b40654cba0a8d7acc93edff05af0ff47ec5d00d7d541cba97c5e59dca1d9bd6c"
CITRIX=CitrixReceiver.dmg
CERT="http://www2.mecon.gov.ar/camecon2/cacert.crt"
CERT_NAME=cacert.crt

trap ctrl_c INT
function ctrl_c(){
        echo -e "\n${redColour}Programa Terminado ${endColour}"
        exit 0
}

function citrix_install(){
echo -e "${yellowColour}Descarga el instalador ${endColour}"
curl -s $URL -o $CITRIX

echo -e "${yellowColour}Instalando el paquete ${endColour}"
hdiutil attach $CITRIX
cp -R /Volumes/CitrixReceiver/CitrixReceiver.app /Applications
hdiutil unmount /Volumes/CitrixReceiver
}

function cert_install(){
echo -e "${yellowColour}Descargar el certificado ${endColour}"
curl -s $CERT 
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $CERT_NAME

echo -e "${greenColour}Todos los procesos terminaron correctamente!! ${endColour}"
}

citrix_install
cert_install
