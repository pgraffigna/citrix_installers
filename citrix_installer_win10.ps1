$URL_CERT = "http://www2.mecon.gov.ar/camecon2/cacert.crt"

mkdir C:\Temp
Invoke-WebRequest -URI https://www.citrix.com/es-mx/downloads/citrix-receiver/windows/receiver-for-windows-latest.html -UseBasicParsing -OutFile "C:\Temp\url"
$URL_CITRIX =(type "C:\Temp\url" | findstr 'downloads.citrix.com/14726/CitrixReceiver.exe?__gda__=' | %{ $_.Split('=')[6]; } | %{ $_.Split('"')[0]; })

Write-Output ''
Write-Host "[!!]1.Descarga el certificado + inicia el instalador" -ForegroundColor "yellow"
Invoke-WebRequest -URI $URL_CERT -OutFile "C:\Temp\cacert.crt"
Start-Process -FilePath "C:\Temp\cacert.crt" -ArgumentList "/S /v/qn"

Write-Output ''
Write-Host "[!!]2.Descarga citrix 4.12 + inicia el instalador" -ForegroundColor "yellow"
Invoke-WebRequest -URI https://downloads.citrix.com/14726/CitrixReceiver.exe?__gda__=$URL_CITRIX -OutFile "C:\Temp\CitrixReceiver.exe"
Start-Process -FilePath "C:\Temp\CitrixReceiver.exe" -ArgumentList "/S /v/qn" 

Write-Output ''
Write-Host "[!!]No te olvides de verificar en el navegador el certificado!!!" -ForegroundColor "green"


