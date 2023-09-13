# GitHubFunctions.ps1

# Function to add a GitHub PR comment
function Add-GitHubPRComment {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Token, # Your GitHub Personal Access Token (PAT)

        [Parameter(Mandatory = $true)]
        [string]$Owner, # Repository owner (username or organization name)

        [Parameter(Mandatory = $true)]
        [string]$Repo, # Repository name

        [Parameter(Mandatory = $true)]
        [int]$PullRequestId, # PR number

        [Parameter(Mandatory = $true)]
        [string]$Comment         # The comment text you want to add
    )

    $uri = "https://api.github.com/repos/$Owner/$Repo/issues/$PullRequestId/comments"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "User-Agent"    = "PowerShellScript"
        "Accept"        = "application/vnd.github.v3+json"
    }

    $body = @{
        "body" = $Comment
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body

    return $response
}

function Add-GitHubPRComment {

    param(
        [Parameter(Mandatory = $true)]
        [string]$Token, # Your GitHub Personal Access Token (PAT)

        [Parameter(Mandatory = $true)]
        [string]$Owner, # Repository owner (username or organization name)

        [Parameter(Mandatory = $true)]
        [string]$Repo, # Repository name

        [Parameter(Mandatory = $true)]
        [int]$PullRequestId # PR number

    )

# Usage:
# Add-GitHubPRComment -Token "YOUR_GITHUB_TOKEN" -Owner "OWNER_NAME" -Repo "REPO_NAME" -PullRequestId PR_NUMBER -Comment "YOUR_COMMENT"
# Define the URL of the GitHub API endpoint for the pull request files
$apiUrl = "https://api.github.com/repos/$Owner/$Repo/pulls/$PullRequestId/files"


# Create a headers hashtable with the required Authorization header
$headers = @{
    "Authorization" = "Bearer $Token"
    "User-Agent"    = "PowerShell-GitHub-Request"
}

# Initialize variables for pagination
$page = 1
$perPage = 100  # Adjust this value as needed (GitHub's max is typically 100 per page)
$changedProjectJsonFiles = @()

# Loop to retrieve all pages of files
while ($true) {
    # Add page query parameter to the API URL
    $pagedUrl = $apiUrl + "?page=$page&per_page=$perPage"

    # Make a GET request to the paged URL
    $response = Invoke-RestMethod -Uri $pagedUrl -Headers $headers -Method Get

    # Check if the response is empty (no more pages)
    if ($response.Count -eq 0) {
        break
    }

    # Filter and add only the 'project.json' files from the current page to the list
    $projectJsonFilesOnPage = $response | Where-Object { $_.filename -like "*project.json*" } | ForEach-Object { $_.filename }

    # Add the filtered files to the collection
    $changedProjectJsonFiles += [array]$projectJsonFilesOnPage

    # Increment the page counter
    $page++
}

# Display the filenames of 'project.json' files that have changed
foreach ($file in $changedProjectJsonFiles) {
    Write-Host "Changed project.json File: $file"
}

return [array]$changedProjectJsonFiles
}