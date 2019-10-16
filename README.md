# Get-Diskspace.ps1

Fetches disk/volume information from a given computer

## Description

This script fetches disk/volume information from a given computer and displays

- Volume name
- Capacity
- Free Space
- Boot Volume Status
- System Volume Status
- File System Type

With -SendMail switch no data is returned to the console.

## Requirements

- Windows Server 2012R2, 2016, 2019
- Exchange Server 2013+ (for AllExchangeServer switch)
- WMI access to remote computers

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

## Examples

``` PowerShell
.\Get-Diskpace.ps1 -ComputerName MYSERVER
```

Get disk information from computer MYSERVER

``` PowerShell
.\Get-Diskpace.ps1 -ComputerName MYSERVER -Unit MB
```

Get disk information from computer MYSERVER in MB

``` PowerShell
.\Get-Diskpace.ps1 -AllExchangeServer -SendMail -MailFrom postmaster@sedna-inc.com -MailTo exchangeadmin@sedna-inc.com -MailServer mail.sedna-inc.com
```

Get disk information from all Exchange servers and send html email

## Note

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE
RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

## TechNet Gallery

Download and vote at TechNet Gallery

- [https://gallery.technet.microsoft.com/Get-Diskspace-report-for-3aedf6ac](https://gallery.technet.microsoft.com/Get-Diskspace-report-for-3aedf6ac)

## Credits

Written by: Thomas Stensitzki

Stay connected:

- My Blog: [http://justcantgetenough.granikos.eu](http://justcantgetenough.granikos.eu)
- Twitter: [https://twitter.com/stensitzki](https://twitter.com/stensitzki)
- LinkedIn: [http://de.linkedin.com/in/thomasstensitzki](http://de.linkedin.com/in/thomasstensitzki)
- Github: [https://github.com/Apoc70](https://github.com/Apoc70)

For more Office 365, Cloud Security, and Exchange Server stuff checkout services provided by Granikos

- Blog: [http://blog.granikos.eu](http://blog.granikos.eu)
- Website: [https://www.granikos.eu/en/](https://www.granikos.eu/en/)
- Twitter: [https://twitter.com/granikos_de](https://twitter.com/granikos_de)
