#   POC script by tim saja v20180823.1
#   Added to githum v20220321.1
#
#           Pre Reqs Only
# MIT License

# Copyright (c) 2022 Unisys, inc.

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
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
if ($dnsIP -ne "") {
    Set-DnsClientServerAddress -InterfaceAlias $netAdapterName -ServerAddresses ($dnsIP)
}
if ($netAdapterName -ne "") {
    Disable-NetAdapterBinding -InterfaceAlias $netAdapterName -ComponentID ms_tcpip6
}
$oReturn=[System.Windows.Forms.MessageBox]::Show("Add EMadmin to log on a a service","Title",[System.Windows.Forms.MessageBoxButtons]::OKCancel)
