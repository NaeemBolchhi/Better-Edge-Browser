# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

Write-Host ""
Write-Host "Better Edge Browser" -ForegroundColor Yellow
Write-Host ""

$DateVar    = Get-Date -Format 'yyyyMMddHHmmss'
$ElevateCMD = 'https://naeembolchhi.github.io/better-edge-browser/win-auto/elevate.cmd?v=' + $DateVar
$AddREG     = 'https://naeembolchhi.github.io/better-edge-browser/edge-add.reg?v=' + $DateVar
$RemoveREG  = 'https://naeembolchhi.github.io/better-edge-browser/edge-remove.reg?v=' + $DateVar

$TargetDir       = "$env:TEMP\TmFlZW1Cb2xjaGhp"
$Path_ElevateCMD = "$TargetDir\edge-elevate.cmd"
$Path_AddREG     = "$TargetDir\edge-add.reg"
$Path_RemoveREG  = "$TargetDir\edge-remove.reg"

if (Test-Path "$env:TEMP\TmFlZW1Cb2xjaGhp\") {
    Remove-Item -Path "$env:TEMP\TmFlZW1Cb2xjaGhp" -Recurse -Force
}

New-Item -Path "$env:TEMP\" -Name "TmFlZW1Cb2xjaGhp" -ItemType Directory | Out-Null

try {
    # CMD Files
    Invoke-WebRequest -Uri $ElevateCMD -UseBasicParsing -OutFile $Path_ElevateCMD -ErrorAction Stop
    # REG Files
	Invoke-WebRequest -Uri $AddREG -UseBasicParsing -OutFile $Path_AddREG -ErrorAction Stop
	Invoke-WebRequest -Uri $RemoveREG -UseBasicParsing -OutFile $Path_RemoveREG -ErrorAction Stop
} catch {
    Write-Error $_
	Return
}

$FilePaths = @(
    $Path_ElevateCMD,
    $Path_AddREG,
    $Path_RemoveREG
)

if ((Test-Path $FilePaths) -notcontains $false) {
    if ([string]::IsNullOrEmpty($args[0])) {
        # No arguments; add edge policies
		Write-Host "Adding policies to Edge..."
        Add-Content -Path $Path_ElevateCMD -Value "reg import `"$Path_AddREG`""
        Start-Process $Path_ElevateCMD -Wait

    } elseif ($args[0] -eq 'remove') {
        # Remove edge policies
		Write-Host "Removing policies from Edge..."
        Add-Content -Path $Path_ElevateCMD -Value "reg import `"$Path_RemoveREG`""
        Start-Process $Path_ElevateCMD -Wait

    } elseif ($args[0] -match '^[a-p]{32}$') {
        # Custom new tab addon to replace Tabliss
		# lklaendlmlfkaabeleddanafeinnenih is Tabliss
		Write-Host "Replacing Tabliss with custom Add-on..."
		Write-Host ""
		Write-Host "Adding updated policies to Edge..."
		(Get-Content $Path_AddREG) -replace 'lklaendlmlfkaabeleddanafeinnenih', $args[0] | Set-Content $Path_AddREG
        Add-Content -Path $Path_ElevateCMD -Value "reg import `"$Path_AddREG`""
        Start-Process $Path_ElevateCMD -Wait
    }

	Write-Host ""
	Write-Host "Success!" -ForegroundColor Green
    Remove-Item -Path "$env:TEMP\TmFlZW1Cb2xjaGhp" -Recurse -Force
} else {
    Write-Warning "Verification failed. One or more files are missing."
}
Write-Host ""