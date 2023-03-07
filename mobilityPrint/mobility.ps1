[CmdletBinding(DefaultParameterSetName = 'Default')]
param(
    # Token from your Mobility Print Server
    [Parameter(Mandatory = $true)]
    [string]
    $token
)

$app = "$env:PROGRAMFILES\PaperCut Mobility Print Client\mobility-print-client.exe"
$url = "https://papercut.com/api/product/mobility-print/latest/client/windows-cloud"
$req = [System.Net.WebRequest]::Create($url)
$req.AllowAutoRedirect = $true
$res = $req.GetResponse()
$AbsoluteUri = $res.ResponseUri.AbsoluteUri
$mobilityFileName = [System.IO.Path]::GetFileName($AbsoluteUri)
$tmp = "$env:TEMP\$mobilityFileName"


if ((Test-Path $app) -and ((Get-Printer).name | Select-String -Pattern "Mobility" -Quiet)) {
    #app is installed and queues are good
    (Get-Printer).name | Select-String -Pattern '(Mobility)' -NoEmphasis
    Write-Host "Everything looks great! Nothing to do here"
    return;
}
if (Test-Path $app) {
    Write-Host "Client is installed" -ForegroundColor green -BackgroundColor black
    #app is installed checking queues next
}
else {
    Write-Host "I can't find the Mobility Print Client path. Installing now." -ForegroundColor yellow -BackgroundColor black
    Start-Sleep -Seconds 1
    Write-Output "Found the latest Mobility Print Cloud Print client version => $mobilityFileName"
    Start-Sleep -Seconds 1
    Write-Host "Retriving Mobility Print Cloud Print Client => $mobilityFileName"
}
    
if ((Test-Path $app) -eq $false) {
    Write-Host "Please wait for $mobilityFileName to install..."
        (New-Object System.Net.WebClient).DownloadFile("$AbsoluteUri", "$env:TEMP\$([System.IO.PATH]::GetFileName(($AbsoluteUri)))")
    Write-Host "Temp file is at => $tmp"

    & msiexec.exe /i "$tmp" /passive | Out-Null
}
if ((Test-Path $app) -eq $true) {
    Write-Host "Mobility Print installed successfully" -ForegroundColor green -BackgroundColor black        
    do {
        Write-Host "Waiting for Mobility Print to start..." -ForegroundColor green -BackgroundColor black
        Start-Sleep -Seconds 5
    } until (
            (Get-Service mobility-print-client).status -eq "Running"
        <# Condition that stops the loop if it returns true #>
    )
    Write-Host "Mobility Print has started successfully" -ForegroundColor green -BackgroundColor black
}
if ((Get-Printer).name | Select-String -Pattern "Mobility" -Quiet) {
    # queues are installed too; if we're here we may have changed a fundamental name somewhere
    Write-Host "Queues are installed" -ForegroundColor green -BackgroundColor black
    (Get-Printer).name | Select-String -Pattern "Mobility" -NoEmphasis
}
else {
    Write-Host "Pushed token, waiting for queues to install..." -ForegroundColor green -BackgroundColor black
    do {
        Start-Process "mobilityprint://mp.cloud.papercut.com/?token=$token"
        Start-Sleep -Seconds 10
        Write-Host "."
        Start-Sleep -Seconds 10

    } until (
        (Get-Printer).name | Select-String -Pattern "Mobility"
        <# Condition that stops the loop if it returns true #>
    )
    #app is installed and queues are present
    Write-Host "Queues are installed or we have installed at least one! Here's what we got so far:" -ForegroundColor green -BackgroundColor black
    (Get-Printer).name | Select-String -Pattern '(Mobility)' -NoEmphasis
    Start-Sleep -Seconds 3
    Write-Host ""
    Write-Host "If you wish to check on this manually later, give this command a try:" -ForegroundColor yellow -BackgroundColor black
    Write-Host ""
    Write-Host "(Get-Printer).name | Select-String -Pattern '(Mobility)' -NoEmphasis"
    Write-Host ""
    Write-Host ""
    Write-Host "Everything looks great, Happy printing!" -ForegroundColor green -BackgroundColor black
    return;
}    
Remove-Item -Path $tmp
$app = ""
$url = ""
$token = ""
$req = ""
$AbsoluteUri = ""
$mobilityFileName = ""
$tmp = ""
$AbsoluteUri
return
