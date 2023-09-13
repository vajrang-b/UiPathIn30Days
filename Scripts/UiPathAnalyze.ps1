function UiPathAnalyze {
    param (
        [string]$UiPathCommandLinePath = "C:\Program Files\UiPath\Studio\UiPath.Studio.CommandLine.exe",
        [string]$ProjectJsonPath
    )

    if (-not (Test-Path $UiPathCommandLinePath)) {
        Write-Host "UiPath command line tool not found at $UiPathCommandLinePath"
        return
    }

    if (-not (Test-Path $ProjectJsonPath)) {
        Write-Host "Project JSON file not found at $ProjectJsonPath"
        return
    }

    $command = "$UiPathCommandLinePath analyze -p ""$ProjectJsonPath"""

    Write-Host "Executing UiPath Analyze with command: $command"

    # Capture the output of Invoke-Expression
    $output = Invoke-Expression -Command $command

    return $output
}