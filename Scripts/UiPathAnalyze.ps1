. $PSScriptRoot\CleanAnyalyseResults.ps1
function UiPathAnalyze {
    param (
        [string]$UiPathCommandLinePath = 'C:\Program Files\UiPath\Studio\UiPath.Studio.CommandLine.exe',
        [string]$ProjectJsonPath
    )

    if (-not (Test-Path $UiPathCommandLinePath -PathType Leaf)) {
        Write-Host "UiPath command line tool not found at $UiPathCommandLinePath"
        return
    }

    if (-not (Test-Path $ProjectJsonPath -PathType Leaf)) {
        Write-Host "Project JSON file not found at $ProjectJsonPath"
        return
    }

    $escapedCommand = [System.Management.Automation.WildcardPattern]::Escape($UiPathCommandLinePath)
    $command = "& ""$escapedCommand"" analyze -p ""$ProjectJsonPath"""

    Write-Host "Executing UiPath Analyze with command: $command"

    # Capture the output of Invoke-Expression
    $output = Invoke-Expression -Command $command
    Write-Host "retrieved errors $output"
    try {
        $cleanResponse = CleanAnyalyseResults -RawAnalysisResults $output
    }
    catch {
        Write-Host "An error occurred: $_"
        $cleanResponse = $output
        # Additional error handling here, if needed
    }

    return $cleanResponse
}
