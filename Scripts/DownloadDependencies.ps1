# Function to install UiPath package using NuGet CLI
param(
    [string]$projectJsonPath
)
function Install-UiPathPackage {
    param(
        [string]$NuGetPath,
        [string]$PackageName,
        [string]$PackageVersion,
        [string]$PackageDestination,
        [string]$PackageSource
    )


    Invoke-Expression "& '$NuGetPath' install $PackageName -Version $PackageVersion -OutputDirectory '$PackageDestination' -Source '$PackageSource' -Force"
}

# Main function to install all UiPath packages based on project.json
function Install-UiPathProjectDependencies {
    param(
        [string]$projectJsonPath
    )

    # Read project.json content into a PowerShell object
    $projectJsonContent = Get-Content $projectJsonPath | ConvertFrom-Json

    # Navigate through dependencies
    $dependencies = $projectJsonContent.dependencies.PSObject.Properties

    # Path to nuget.exe (nuget will be in the same folder as the script)
    $nugetPath = Join-Path $PSScriptRoot "nuget.exe"

    # Local NuGet feed directory (usually this is the default directory for user-wide NuGet packages)
    $packageDestination = "$env:USERPROFILE\.nuget\packages"
    #$packageDestination = "C:\Users\Vajrangbilllakurthi\.nuget\packages"


    # NuGet package source URL
    $packageSource = "https://pkgs.dev.azure.com/uipath/Public.Feeds/_packaging/UiPath-Official/nuget/v3/index.json"


    foreach ($dependency in $dependencies) {
        $packageName = $dependency.Name
        $packageVersion = $dependency.Value.Trim('[', ']')  # Remove brackets to get the version number

        Write-Host "Installing $packageName version $packageVersion"

        # Install package
        Install-UiPathPackage -NuGetPath $nugetPath -PackageName $packageName -PackageVersion $packageVersion -PackageDestination $packageDestination -PackageSource $packageSource
    }
}

# Example usage:
# Replace with the path to your project.json file

