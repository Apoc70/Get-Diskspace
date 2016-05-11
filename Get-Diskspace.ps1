<# 
    .SYNOPSIS 
    Fetches disk/volume information from a given computer

    Thomas Stensitzki 

    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 

    Version 1.11, 2016-05-11

    Please send ideas, comments and suggestions to support@granikos.eu 

    .LINK 
    More information can be found at http://www.granikos.eu/en/scripts

    .DESCRIPTION 
    This script fetches disk/volume information from a given computer and displays 

    * Volume name
    * Capacity
    * Free Space
    * Boot Volume Status
    * System Volume Status
    * File Systemtype 

    With -SendMail switch no data is returned to the console. 
     
    .NOTES 
    Requirements 
    - Windows Server 2012 R2  
    - Remote WMI
    - Exchange Server Management Shell
    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0      Initial community release 
    1.1      Email reports added
    1.11     Send email issue fixed

    .PARAMETER ComputerName
    Can of the computer to fetch disk information from  

    .PARAMETER Unit
    Target unit for disk space value (default = GB)

    .PARAMETER AllExchangeServer
    Switch to fetch disk space data from all Exchange Servers

    .PARAMETER SendMail
    Switch to send an Html report

    .PARAMETER MailFrom
    Email address of report sender

    .PARAMETER MailTo
    Email address of report recipient

    .PARAMETER MailServer
    SMTP Server for email report

    .EXAMPLE 
    Get disk information from computer MYSERVER
    
    Get-Diskpace.ps1 -ComputerName MYSERVER

    .EXAMPLE
    Get disk information from computer MYSERVER in MB

    Get-Diskpace.ps1 -ComputerName MYSERVER -Unit MB

    .EXAMPLE
    Get disk information from all Exchange servers and send html email

    Get-Diskpace.ps1 -AllExchangeServer -SendMail -MailFrom postmaster@sedna-inc.com -MailTo exchangeadmin@sedna-inc.com -MailServer mail.sedna-inc.com

#>

param(
	[parameter(Mandatory=$false, HelpMessage='Computer name to query')]
		[string] $ComputerName = $env:COMPUTERNAME,
    [parameter(Mandatory=$false, HelpMessage='Unit to convert to [default = GB]')]
		[string] $Unit = "GB",
    [parameter(Mandatory=$false, HelpMessage='Fetch from all Exchange servers')]
        [switch] $AllExchangeServer,
    [parameter(Mandatory=$false, HelpMessage='Send report as Html email')]
        [switch] $SendMail,
    [parameter(Mandatory=$false, HelpMessage='Sender address for result summary')]
        [string]$MailFrom = "",
    [parameter(Mandatory=$false, HelpMessage='Recipient address for result summary')]
        [string]$MailTo = "",
    [parameter(Mandatory=$false, HelpMessage='SMTP Server address for sending result summary')]
        [string]$MailServer = ""
)

Set-StrictMode -Version Latest 

$Unit = $Unit.ToUpper()
$now = Get-Date -Format F
$ReportTitle = "Diskspace Report - $($now)"
$global:Html = ""

switch($Unit){
    "GB" {
        $ConvertTo = 1GB
    }
    "MB" {
        $ConvertTo = 1MB
    }
}

function Get-DiskspaceFromComputer {
param(
    [string] $ServerName
)
    
    if(($Unit -eq "GB") -or ($Unit -eq "MB")) {

        $ServerName = $ServerName.ToUpper()

        Write-Output "Fetching Volume Data from $($ServerName)"

        $wmi = Get-WmiObject Win32_Volume -ComputerName $ServerName | Select Name, @{Label="Capacity ($Unit)";Expression={[decimal]::round($_.Capacity/$ConvertTo)}}, @{Label="FreeSpace ($Unit)";Expression={[decimal]::round($_.FreeSpace/$ConvertTo)}}, BootVolume, SystemVolume, FileSystem | Sort-Object Name 
        $global:Html += $wmi | ConvertTo-Html -Fragment -PreContent "<h2>Server $($ServerName)</h2>"
    }

    $wmi
}

Function Check-SendMail {
     if( ($SendMail) -and ($MailFrom -ne "") -and ($MailTo -ne "") -and ($MailServer -ne "") ) {
        return $true
     }
     else {
        return $false
     }
}

#### MAIN
If (($SendMail) -and (!(Check-SendMail))) {
    Throw "If -SendMail specified, -MailFrom, -MailTo and -MailServer must be specified as well!"
}

# Some CSS to get a pretty report
$head = @'
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>$($ReportTitle)</title>
<style type=”text/css”>
<!–
body {
    font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
}
h2{ clear: both; font-size: 100%;color:#354B5E; }
h3{
    clear: both;
    font-size: 75%;
    margin-left: 20px;
    margin-top: 30px;
    color:#475F77;
}
table{
    border-collapse: collapse;
    border: none;
    font: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
    color: black;
    margin-bottom: 10px;
}
 
table td{
    font-size: 12px;
    padding-left: 0px;
    padding-right: 20px;
    text-align: left;
}
 
table th {
    font-size: 12px;
    font-weight: bold;
    padding-left: 0px;
    padding-right: 20px;
    text-align: left;
}
->
</style>
'@

if($AllExchangeServer) {
    $servers = Get-ExchangeServer | Sort-Object Name 
    foreach($server in $servers) {
        $output = Get-DiskspaceFromComputer -ServerName $server.Name 
        if(!($SendMail)) { $output | FT -AutoSize } 
    }
}
else {
    $output = Get-DiskspaceFromComputer -ServerName $ComputerName
    if(!($SendMail)) { $output | FT -AutoSize } 
}

if($SendMail) {
    [string]$Body = ConvertTo-Html -Body $global:Html -Title "Status" -Head $head
    Send-MailMessage -From $MailFrom -To $Mailto -SmtpServer $MailServer -Body $Body -BodyAsHtml -Subject $ReportTitle
    Write-Output "Email sent to $($MailTo)"
}