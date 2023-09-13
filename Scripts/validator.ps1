param (
    [string]$pull_number,
    [string]$YOUR_PERSONAL_ACCESS_TOKEN
    )
    
    # Import the script containing the Run-UiPathAnalyze function
    # Dot-source the script with the relative path
. UiPathAnalyze.ps1

# Check if required parameters are provided
if (-not $pull_number -or -not $YOUR_PERSONAL_ACCESS_TOKEN) {
    Write-Host "Usage: script.ps1 -pull_number <pull_number> -YOUR_PERSONAL_ACCESS_TOKEN <access_token>"
    exit 1
}

$githubOwner = "vajrang-b"
$githubRepoName = "RPA-Developer-in-30-Days"
$githubApiUrl = "https://api.github.com/repos/$githubOwner/$githubRepoName/pulls/$pull_number/files"
$RepoLocalpath = "E:\RPA-Developer-in-30-Days"



$response = Invoke-WebRequest -Uri $githubApiUrl

# Convert the JSON response content to PowerShell objects
$responseContent = $response.Content | ConvertFrom-Json
$responseContent.Length

# Filter and extract file names using Where-Object
$fileNames = $responseContent | Where-Object { $_.filename -like "*project.json*" } | ForEach-Object { $_.filename }

# Display the list of filtered file names
Write-Output $fileNames


foreach ($project in $fileNames) {
    $ProjectPath = Join-Path -Path $RepoLocalpath -ChildPath $project
    Write-Output $ProjectPath
    $Comment = UiPathAnalyze -ProjectJsonPath $ProjectPath
    Write-Host $Comment
   # Add-GitHubPRComment -Token $YOUR_PERSONAL_ACCESS_TOKEN -Owner $Owner -Repo $Repo -PullRequestId $PullRequestId -Comment $Comment
    #downloadProjectDependencies -ProjectJsonPath $ProjectPath
}


# Usage:
# Add-GitHubPRComment -Token "YOUR_GITHUB_TOKEN" -Owner "OWNER_NAME" -Repo "REPO_NAME" -PullRequestId PR_NUMBER -Comment "YOUR_COMMENT"


# adding nuget to local 
#nuget.exe install UiPath.System.Activities -Version 21.10.2 -Source https://www.myget.org/F/workflow/api/v3/index.json

