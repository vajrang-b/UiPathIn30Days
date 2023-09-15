param (
    [string]$pull_number,
    [string]$YOUR_PERSONAL_ACCESS_TOKEN,
    [string]$GptApiKey,
    [string]$currentDirectory
)
    
# Import the script containing the Run-UiPathAnalyze function
# Dot-source the script with the relative path
. $PSScriptRoot\UiPathAnalyze.ps1
. $PSScriptRoot\GenerateGptResponse.ps1
. $PSScriptRoot\GitHubFunctions.ps1


# Check if required parameters are provided
if (-not $pull_number -or -not $YOUR_PERSONAL_ACCESS_TOKEN) {
    Write-Host "Usage: script.ps1 -pull_number <pull_number> -YOUR_PERSONAL_ACCESS_TOKEN <access_token> -GptApiKey <GptApiKey>" 
    exit 1
}

$githubOwner = "vajrang-b"
$githubRepoName = "RPA-Developer-in-30-Days"
$RepoLocalpath = $currentDirectory

$responseFilesChanged = @()
$responseFilesChanged = Get-GitHubPrFiles -Token $YOUR_PERSONAL_ACCESS_TOKEN -Owner $githubOwner -Repo $githubRepoName -PullRequestId $pull_number

# Convert the JSON response content to PowerShell objects
"count of project json files changed $responseFilesChanged.Length"

$fileNames = $responseFilesChanged

# Display the list of filtered file names
Write-Output "files changed $fileNames"

if ($fileNames.Length -ge 0 ) {
    <# Action to perform if the condition is true #>


    foreach ($project in $fileNames) {
        $ProjectPath = Join-Path -Path $RepoLocalpath -ChildPath $project
        Write-Output "project path is $ProjectPath"
        $Comment = UiPathAnalyze -ProjectJsonPath $ProjectPath
        Write-Host $Comment
        $GptComment = GenerateGptResponse -GptApiKey $GptApiKey -errorDetails  $Comment 
        Write-Host $GptComment

        # Add-GitHubPRComment -Token $YOUR_PERSONAL_ACCESS_TOKEN -Owner $Owner -Repo $Repo -PullRequestId $PullRequestId -Comment $Comment

        $AddCommentResponse = Add-GitHubPRComment -Token $YOUR_PERSONAL_ACCESS_TOKEN -Owner $githubOwner -Repo $githubRepoName -PullRequestId $pull_number -Comment $GptComment
        Write-Host $AddCommentResponse
        #downloadProjectDependencies -ProjectJsonPath $ProjectPath
    }
}
else {
    Write-Host "no project files are in review"
    $GptComment = "Cannot perform automated review, team will manually verify your code"
    $AddCommentResponse = Add-GitHubPRComment -Token $YOUR_PERSONAL_ACCESS_TOKEN -Owner $githubOwner -Repo $githubRepoName -PullRequestId $pull_number -Comment $GptComment
    Write-Host $AddCommentResponse
    <# Action when all if and elseif conditions are false #>
}
# Usage:
# Add-GitHubPRComment -Token "YOUR_GITHUB_TOKEN" -Owner "OWNER_NAME" -Repo "REPO_NAME" -PullRequestId PR_NUMBER -Comment "YOUR_COMMENT"


# adding nuget to local 
#nuget.exe install UiPath.System.Activities -Version 21.10.2 -Source https://www.myget.org/F/workflow/api/v3/index.json

