#   POC script by tim saja v20180823.1
#   Added to githum v20220321.1
#
#           Pre Reqs Only
#===============================================
param ($netAdapterName,$dnsIP)

Import-Module Servermanager
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# ==================== Add Windows Features ===========================================================================================
Add-WindowsFeature net-framework-45-core
add-windowsfeature net-wcf-http-activation45
Add-WindowsFeature web-common-http
Add-Windowsfeature MSMQ
Add-WindowsFeature RSAT-AD-PowerShell,RSAT-AD-AdminCenter
add-windowsfeature NET-WCF-HTTP-Activation45,NET-WCF-MSMQ-Activation45 
# ===============================================================================



$registryPath = "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\"

# =================== If needed create "ZONES" key ====================================================================================
if (!(Test-Path ($registryPath))) {
New-Item -Path ($registryPath)
}
#--------------------------------------------------------------------------------------------------------------------------------------


# =================== set active scripting in Intranet  ===============================================================================
if (!(Test-Path ($registryPath+"1"))) {
New-Item -Path ($registryPath+"1")
}
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" -Name "1400" -Value 0 
#--------------------------------------------------------------------------------------------------------------------------------------

# ==================== set active scripting in Internet ===============================================================================
if (!(Test-Path ($registryPath+"3"))) {
New-Item -Path ($registryPath+"3")
}
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Name "1400" -Value 0 
#--------------------------------------------------------------------------------------------------------------------------------------

# ==================== Set use TLS 1.2 only ===========================================================================================
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\" -Name "SecureProtocols" -Value 0x800 
#--------------------------------------------------------------------------------------------------------------------------------------


# At this sec pol you need to grant the EMAdmin user the LOGON As A Service right

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
if $dnsIP <> "" {
    Set-DnsClientServerAddress -InterfaceAlias $netAdapterName -ServerAddresses ($dnsIP)
}
if $netAdapterName <> "" {
    Disable-NetAdapterBinding -InterfaceAlias $netAdapterName -ComponentID ms_tcpip6
}
$oReturn=[System.Windows.Forms.MessageBox]::Show("Add EMadmin to log on a a service","Title",[System.Windows.Forms.MessageBoxButtons]::OKCancel)
