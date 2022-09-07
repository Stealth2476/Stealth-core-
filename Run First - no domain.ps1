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
# Stealth POC script  setup an Enterprise Manager 
# tim saja version 20160921.1


# RUN THIS SCRIPT AS AN ADMINISTRATOR!!!
# Before you run this script you need to:
# Copy the files to a local directory and cd to that directory after you start Powershell, 
#
#     Good Luck!
#
# install needed features to be a domain controller and HTTP Activation

Import-Module Servermanager
Add-Windowsfeature AD-Domain-Services, MSMQ
Add-WindowsFeature RSAT-AD-PowerShell,RSAT-AD-AdminCenter
add-windowsfeature NET-WCF-HTTP-Activation45,NET-WCF-MSMQ-Activation45 
# ===============================================================================



$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer
Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green


