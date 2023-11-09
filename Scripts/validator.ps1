param (
    [string]$pull_number,
    [string]$YOUR_PERSONAL_ACCESS_TOKEN,
    [string]$GptApiKey,
    [string]$currentDirectory,
    [string]$systemRole

)
    
# Import the script containing the Run-UiPathAnalyze function
# Dot-source the script with the relative path

. $PSScriptRoot\DownloadDependencies.ps1
. $PSScriptRoot\UiPathAnalyze.ps1
. $PSScriptRoot\GenerateGptResponse.ps1
. $PSScriptRoot\GitHubFunctions.ps1

Write-Host "current System role $systemRole"

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

# Assuming $responseFilesChanged contains the list of changed files

# Calculate the count of project JSON files changed
$count = $responseFilesChanged.Length

# Print the count in a readable format
Write-Host "Count of project JSON files changed: $count"


$fileNames = $responseFilesChanged

# Display the list of filtered file names
Write-Output "files changed $fileNames"

Write-Host "Count value: $count"

if ($count -gt 0 ) {
    <# Action to perform if the condition is true #>
    foreach ($project in $fileNames) {
        $ProjectPath = Join-Path -Path $RepoLocalpath -ChildPath $project
        Write-Output "project path is $ProjectPath"
        Write-Output "Install Dependencies started"
        Install-UiPathProjectDependencies -projectJsonPath $ProjectPath
        Write-Output "Install Dependencies completed"
        $Comment = UiPathAnalyze -ProjectJsonPath $ProjectPath
        Write-Host $Comment
       
       <#  enable this block  if gpt code required#>


        # $GptComment = GenerateGptResponse -GptApiKey $GptApiKey -errorDetails  $Comment -systemRole $systemRole
        # Write-Host $GptComment

        # # Add-GitHubPRComment -Token $YOUR_PERSONAL_ACCESS_TOKEN -Owner $Owner -Repo $Repo -PullRequestId $PullRequestId -Comment $Comment
        # $GptComment = ($project, $GptComment) -join "`n"

        # $AddCommentResponse = Add-GitHubPRComment -Token $YOUR_PERSONAL_ACCESS_TOKEN -Owner $githubOwner -Repo $githubRepoName -PullRequestId $pull_number -Comment $GptComment


        <#  enable this block  if gpt code required#>
        $AddCommentResponse = Add-GitHubPRComment -Token $YOUR_PERSONAL_ACCESS_TOKEN -Owner $githubOwner -Repo $githubRepoName -PullRequestId $pull_number -Comment $Comment
        Write-Host $AddCommentResponse
        #downloadProjectDependencies -ProjectJsonPath $ProjectPath
    }
}
else {
    Write-Host "no project files are in review"
    $GptComment = "5 Points are assured. No Errors found by AI system, you must be really good in writing uipath code. An expert need to review your code and it will be done before next sunrise :)"
    $AddCommentResponse = Add-GitHubPRComment -Token $YOUR_PERSONAL_ACCESS_TOKEN -Owner $githubOwner -Repo $githubRepoName -PullRequestId $pull_number -Comment $GptComment
    Write-Host $AddCommentResponse
    <# Action when all if and elseif conditions are false #>
}
# Usage:
# Add-GitHubPRComment -Token "YOUR_GITHUB_TOKEN" -Owner "OWNER_NAME" -Repo "REPO_NAME" -PullRequestId PR_NUMBER -Comment "YOUR_COMMENT"


# adding nuget to local 
#nuget.exe install UiPath.System.Activities -Version 21.10.2 -Source https://www.myget.org/F/workflow/api/v3/index.json

