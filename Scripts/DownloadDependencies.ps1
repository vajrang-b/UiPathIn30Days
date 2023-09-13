# DownloadDependencies.ps1

# Function to download a UiPath library
function DownloadUiPathLibrary {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $LibraryName,

        [Parameter(Mandatory=$false)]
        [string]
        $PackageSource = "https://www.myget.org/F/workflow/"
    )

    # Construct the command
    $command = "'C:\Program Files\UiPath\Studio\UiRobot.exe' pack download -p '$LibraryName' -s '$PackageSource'"

    # Debugging: Show what will be executed
    Write-Host "Executing: $command"

    # Execute the command
    Invoke-Expression -Command $command
}

# Function to download project dependencies
function DownloadProjectDependencies {
    param (
        [Parameter()]
        [string]
        $ProjectJsonPath
    )

    # Read the project.json file
    $projectJson = Get-Content -Path $ProjectJsonPath | ConvertFrom-Json

    # Extract dependency names
    $libraries = $projectJson.dependencies.PSObject.Properties | ForEach-Object { $_.Name } 

    # Output the names
    Write-Output "Libraries are: $libraries"

    # Loop through the list of libraries and download each one
    foreach ($library in $libraries) {
        DownloadUiPathLibrary -LibraryName $library
    }
}

