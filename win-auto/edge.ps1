# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

$DateVar    = Get-Date -Format 'yyyyMMddHHmmss'
$ElevateCMD = 'https://naeembolchhi.github.io/Better-Edge-Browser/win-auto/elevate.cmd?v=' + $DateVar
$AddREG     = 'https://naeembolchhi.github.io/Better-Edge-Browser/edge-add.reg?v=' + $DateVar
$RemoveREG  = 'https://naeembolchhi.github.io/Better-Edge-Browser/edge-remove.reg?v=' + $DateVar

$TargetDir       = "$env:TEMP\TmFlZW1Cb2xjaGhp"
$Path_ElevateCMD = "$TargetDir\edge-elevate.cmd"
$Path_AddREG     = "$TargetDir\edge-add.reg"
$Path_RemoveREG  = "$TargetDir\edge-remove.reg"
$Path_ReplaceREG = "$TargetDir\edge-replace.reg"

if (Test-Path "$env:TEMP\TmFlZW1Cb2xjaGhp\") {
    Remove-Item -Path "$env:TEMP\TmFlZW1Cb2xjaGhp" -Recurse -Force
}

New-Item -Path "$env:TEMP\" -Name "TmFlZW1Cb2xjaGhp" -ItemType Directory

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
        Add-Content -Path $Path_ElevateCMD -Value "reg import `"$Path_AddREG`""
        Start-Process $Path_ElevateCMD -Wait
    
    } elseif ($args[0] -eq 'remove') {
        # Remove edge policies
        Add-Content -Path $Path_ElevateCMD -Value "reg import `"$Path_RemoveREG`""
        Start-Process $Path_ElevateCMD -Wait
    
    } elseif ($args[0] -match '^[a-p]{32}$') {
        # Custom new tab addon to replace Tabliss
        $ReplaceString = @(
            "set `"_source=$Path_AddREG`"",
            "set `"_replaced=$Path_ReplaceREG`"",
            '',
            '> "%_replaced%" (',
            '    for /f "delims=" %%A in (%_source%) do (',
            '        set "line=%%A"',
            "        set `"line=!line:lklaendlmlfkaabeleddanafeinnenih=$args[0]!`"",
            '        echo(!line!',
            '    )',
            ')',
            '',
            "reg import `"$Path_ReplaceREG`""
        )
        Add-Content -Path $Path_ElevateCMD -Value $ReplaceString
        Start-Process $Path_ElevateCMD -Wait
    }
    
    Remove-Item -Path "$env:TEMP\TmFlZW1Cb2xjaGhp" -Recurse -Force
} else {
    Write-Warning "Verification failed. One or more files are missing."
}
