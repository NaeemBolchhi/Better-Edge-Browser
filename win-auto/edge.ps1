# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

$ElevateURL = 'https://naeembolchhi.github.io/Better-Edge-Browser/win-auto/elevate.cmd'
$AddREG = 'https://naeembolchhi.github.io/Better-Edge-Browser/edge-add.reg'
$RemoveREG = 'https://naeembolchhi.github.io/Better-Edge-Browser/edge-remove.reg'

$Path_AddREG = "$env:TEMP\TmFlZW1Cb2xjaGhp\edge-add.reg"
$Path_RemoveREG = "$env:TEMP\TmFlZW1Cb2xjaGhp\edge-remove.reg"
$Path_RunAddREG = "$env:TEMP\TmFlZW1Cb2xjaGhp\edge-add.cmd"
$Path_RunRemoveREG = "$env:TEMP\TmFlZW1Cb2xjaGhp\edge-remove.cmd"
$Path_RunSpecialREG = "$env:TEMP\TmFlZW1Cb2xjaGhp\edge-special.cmd"

$customAddon = $args[0]

if (Test-Path "$env:TEMP\TmFlZW1Cb2xjaGhp\") {
    Remove-Item -Path "$env:TEMP\TmFlZW1Cb2xjaGhp" -Recurse -Force
}

New-Item -Path "$env:TEMP\" -Name "TmFlZW1Cb2xjaGhp" -ItemType Directory

try {
	Invoke-WebRequest -Uri $AddREG -UseBasicParsing -OutFile $Path_AddREG
	Invoke-WebRequest -Uri $RemoveREG -UseBasicParsing -OutFile $Path_RemoveREG
    Invoke-WebRequest -Uri $ElevateURL -UseBasicParsing -OutFile $Path_RunAddREG
	Copy-Item -Path $Path_RunAddREG -Destination $Path_RunRemoveREG
	Copy-Item -Path $Path_RunAddREG -Destination $Path_RunSpecialREG
} catch {
    Write-Error $_
	Return
}

if (Test-Path $FilePath) {
    Start-Process $FilePath -Wait
    $item = Get-Item -LiteralPath $FilePath
    $item.Delete()
}
