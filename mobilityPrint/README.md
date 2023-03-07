Install the Mobility Print Client and available Cloud Print queues without user intervention.

Deployable via [Intune](https://learn.microsoft.com/en-us/mem/intune/apps/intune-management-extension) or good 'ol Group Policy.

Usage example:

`powershell.exe .\mobility.ps1 -token "eyJhbGciO…myToken"`

1. If the script doesn’t detect the app it’ll install the client and wait for the Mobility Print Client service to start.
2. If the client is installed, but no Mobility Print queues exist, it’ll push them to install.
