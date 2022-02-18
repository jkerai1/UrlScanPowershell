$url = Read-Host "URL"
$url = $url.Trim()

$theHead = @{
    "API-Key"="INSERT API KEY HERE"
}

$theBody = @{
    "url"="$url"
    "visibility"="private"
} | ConvertTo-Json

# Invoke-RestMethod, Posting to URLscan w/ API Key and URL
$urlScanIt = Invoke-RestMethod -Method Post -Uri "https://urlscan.io/api/v1/scan/" -Headers $theHead -Body $theBody -ContentType application/json

# Getting just the section of data that is relevant... Only need $urlSCanIt.api, but the UUID is nice to have as well
$scanlink = $urlScanIt.api
$scanuuid = $urlScanIt.uuid

Start-Sleep 22
$scanResult = Invoke-RestMethod -Method Get -Uri "$scanlink"

if ($scanResult.verdicts.overall.malicious -ne "False"){$Verdict = "This URL is not malicious."}
else{"This URL has a malicious rating."  }
    


$scanResult.page | ForEach-Object {
    Write-Host "======================================================================="
    Write-Host ""
    Write-Host "URL: " -NoNewline; Write-Output "$($_.url)"
    Write-Host "Country: " -NoNewline; Write-Output "$($_.country)"
    Write-Host "IP: " -NoNewline; Write-Output "$($_.ip)"
    Write-Host "ASN: " -NoNewline; Write-Output "$($_.asname)"
    Write-Host ""
    Write-Host "$Verdict"
}


