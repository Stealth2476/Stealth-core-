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
#   POC script by tim saja v20160921.1

# ==================== Add EMAdmin to the Domain and add to the domain admins group ===================================================
Import-Module ActiveDirectory
new-aduser EMAdmin -AccountPassword (ConvertTo-SecureString -AsPlainText "Administer4Me!" -Force) -Enabled $true -Path 'CN=Users,DC=stealth,DC=local' -PasswordNeverExpires $true
$user = Get-ADUser -filter {name -like "EMAdmin"}
$group = Get-ADGroup -Filter {name -like "Domain Admins"}
Add-ADGroupMember $group -Member $user 
$object = New-Object System.Security.Principal.NTAccount("EMAdmin")
$SID = $object.Translate([System.Security.Principal.SecurityIdentifier])


# ==================== Add Windows Features ===========================================================================================
Add-WindowsFeature net-framework-45-core
add-windowsfeature net-wcf-http-activation45
Add-WindowsFeature web-common-http

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

secpol
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
$netAdapterName = "Ethernet"
#Set-DnsClientServerAddress -InterfaceAlias $netAdapterName -ServerAddresses ("10.0.0.1","10.0.0.2")
Disable-NetAdapterBinding -InterfaceAlias $netAdapterName -ComponentID ms_tcpip6
