# Get-Diskspace.ps1
Fetches disk/volume information from a given computer

## Description
This script fetches disk/volume information from a given computer and displays 

- Volume name
- Capacity
- Free Space
- Boot Volume Status
- System Volume Status
- File Systemtype 

With -SendMail switch no data is returned to the console.

## Parameters
### ComputerName
Can of the computer to fetch disk information from  

### Unit
Target unit for disk space value (default = GB)

### AllExchangeServer
Switch to fetch disk space data from all Exchange Servers

### SendMail
Switch to send an Html report

### MailFrom
Email address of report sender

### MailTo
Email address of report recipient

### MailServer
SMTP Server for email report

## Outputs
The disk volumes table is sent either to the console or sent as html email to a given recipient.

## Examples
```
.\Get-Diskpace.ps1 -ComputerName MYSERVER
```
Get disk information from computer MYSERVER

```
.\Get-Diskpace.ps1 -ComputerName MYSERVER -Unit MB
```
Get disk information from computer MYSERVER in MB

```
.\Get-Diskpace.ps1 -AllExchangeServer -SendMail -MailFrom postmaster@sedna-inc.com -MailTo exchangeadmin@sedna-inc.com -MailServer mail.sedna-inc.com
```
Get disk information from all Exchange servers and send html email

## TechNet Gallery
Find the script at TechNet Gallery
* https://gallery.technet.microsoft.com/Get-Diskspace-report-for-3aedf6ac

## Credits
Written by: Thomas Stensitzki

## Social

* My Blog: http://justcantgetenough.granikos.eu
* Archived Blog: http://www.sf-tools.net/
* Twitter: https://twitter.com/stensitzki
* LinkedIn:	http://de.linkedin.com/in/thomasstensitzki
* Github: https://github.com/Apoc70

For more Office 365, Cloud Security and Exchange Server stuff checkout the services provided by Granikos GmbH & Co. KG

* Blog: http://blog.granikos.eu/
* Website: https://www.granikos.eu/en/
* Twitter: https://twitter.com/granikos_de