gci Cert:\LocalMachine\My

ipconfig

appcmd set site /site.name:"Test" /+bindings.[protocol='https',]

appcmd list site

.\appcmd.exe set site /site.name:”Test” "/+bindings.[protocol=’https’,bindingInformation=’102.101.2.4:443:’].BindingInformation='102.101.2.4:443:Test'"


.\appcmd.exe set site --% /site.name:Test /bindings.[protocol='https',bindingInformation='102.101.2.4:443:'].bindingInformation:102.101.2.4:443:Test

gi Cert:\LocalMachine\My\D70930BB790F89C04C728D9285B64F5FB0258FC7 | New-Item IIS:\SslBindings\!443!test4

New-WebBinding -Name Test -Protocol https -Port 443 -HostHeader test4 -IPAddress 192.168.1.108

F86E26D1ED7BFFC305F6969A06C5B14AE520C62F

netsh --% http add sslcert hostnameport=test4:443 certhash=d70930bb790f89c04c728d9285b64f5fb0258fc7 appid={01010101-0101-0101-0101-010101010101} certstorename=MY

netsh --% http add sslcert hostnameport=test4:443 certhash=d70930bb790f89c04c728d9285b64f5fb0258fc7 appid={01010101-0101-0101-0101-010101010101} certstorename=MY

New-ItemProperty IIS:\sites\Test -name bindings -value @{protocol="https";bindingInformation="192.168.1.108:443:Test4"}

Get-ItemProperty -Path "IIS:\Sites\Test" -Name Bindings



Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.applicationHost/sites/site[@name='Test']/bindings" -name "." -value @{protocol='https';bindingInformation='192.168.1.108:443:test4'}

Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/sites/siteDefaults/bindings" -name "." -value @{protocol='https';bindingInformation='192.168.1.108:443:Test4'}





Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/sites/site[@name='Test']/bindings/binding[@protocol='https' and @bindingInformation='192.168.1.108:80:test4']" -name "bindingInformation" -value "192.168.1.108:443:test4"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/sites/site[@name='Test']/bindings/binding[@protocol='https' and @bindingInformation='192.168.1.108:443:test4']" -name "sslFlags" -value 1

Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/sites/site[@name='Test']/bindings" -name "." -value @{protocol='https';bindingInformation=':443:test4';sslFlags=1}

Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/sites/site[@name='Test4']/bindings" -name "." -value @{protocol='https';bindingInformation='192.168.1.108:443:test4'}


Add-WebConfiguration -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/sites/site[@name='Test']/bindings/binding[@protocol='https' and @bindingInformation='192.168.1.108:80:test4']" -name "bindingInformation" -value "192.168.1.108:443:test4"
Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/sites/site[@name='Test']/bindings/binding[@protocol='https' and @bindingInformation='192.168.1.108:443:test4']" -name "sslFlags" -value 1
