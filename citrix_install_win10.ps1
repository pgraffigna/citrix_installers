$URL_CERT = "http://www2.mecon.gov.ar/camecon2/cacert.crt"
$URL_BASE = "https://downloads.citrix.com/14726/CitrixReceiver.exe?__gda__=exp=1648481292~acl=/*~hmac="
$ID = "3a43fe47e36e46412604f7f39877f4f61e34f0442dcc353f579911422af5f0dc"

#tener en cuenta de chequear el numero despues de exp= porque es dinámico
#tener en cuenta de chequer el valor de la variable $ID porque es dinámica

Write-Output ''
Write-Host "[!!]1.Descarga el certificado + inicia el instalador" -ForegroundColor "yellow"
Invoke-WebRequest -URI $URL_CERT -OutFile "$env:HOMEPATH\Desktop\cacert.crt"
Start-Process -FilePath "$env:HOMEPATH\Desktop\cacert.crt" -ArgumentList "/S /v/qn"

Write-Output ''
Write-Host "[!!]2.Descarga citrix 4.12 + inicia el instalador" -ForegroundColor "yellow"
Invoke-WebRequest -URI $URL_BASE$ID -OutFile $env:HOMEPATH\Desktop\CitrixReceiver.exe 
Start-Process -FilePath $env:HOMEPATH\Desktop\CitrixReceiver.exe -ArgumentList "/S /v/qn" -Wait

Write-Output ''
Write-Host "[!!]3.Limpiando el Escritorio" -ForegroundColor "yellow"
Remove-Item "$env:HOMEPATH\Desktop\cacert.crt", "$env:HOMEPATH\Desktop\CitrixReceiver.exe"

Write-Output ''
Write-Host "[!!]No te olvides de verificar en el navegador el certificado!!!" -ForegroundColor "green"

