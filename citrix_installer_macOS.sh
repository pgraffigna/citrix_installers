#!/bin/bash
#script para instalar Citrix Receiver en macOS

URL="https://downloads.citrix.com/14596/CitrixReceiver.dmg?__gda__=exp=1632328536~acl=/*~hmac=c75f6c63b516d2ae5b474180bcb5412e6eea91a46cf5c41b46dc0fbd1ea125a5"
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
hdiutil mount $CITRIX
}

function cert_install(){
echo -e "${yellowColour}Descargar el certificado ${endColour}"
curl -s $CERT 
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $CERT_NAME

echo -e "${greenColour}Todos los procesos terminaron correctamente!! ${endColour}"
}

citrix_install
cert_install
