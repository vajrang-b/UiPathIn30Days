
# $uri = "https://api.github.com/repos/vajrang-b/RPA-Developer-in-30-Days/pulls/:pull_number/files"

$uri = "https://api.github.com/repos/vajrang-b/RPA-Developer-in-30-Days/commits/$sourceVersion"

$headers = @{
    "Authorization" = "Bearer YOUR_PERSONAL_ACCESS_TOKEN"
}

# $response = Invoke-WebRequest -Uri $uri -Headers $headers

$response = Invoke-WebRequest -Uri $uri

# Convert the JSON response content to PowerShell objects
$responseContent = $response.Content | ConvertFrom-Json

# Filter and extract file names using Where-Object
$fileNames = $responseContent |
    Where-Object { $_.filename -eq "package.json" } |  # Filter for "package.json" files
    ForEach-Object { $_.filename }

# Display the list of filtered file names
$fileNames


function Add-GitHubPRComment {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Token,          # Your GitHub Personal Access Token (PAT)

        [Parameter(Mandatory=$true)]
        [string]$Owner,          # Repository owner (username or organization name)

        [Parameter(Mandatory=$true)]
        [string]$Repo,           # Repository name

        [Parameter(Mandatory=$true)]
        [int]$PullRequestId,     # PR number

        [Parameter(Mandatory=$true)]
        [string]$Comment         # The comment text you want to add
    )

    $uri = "https://api.github.com/repos/$Owner/$Repo/issues/$PullRequestId/comments"

    $headers = @{
        "Authorization" = "Bearer $Token"
        "User-Agent" = "PowerShellScript"
        "Accept" = "application/vnd.github.v3+json"
    }

    $body = @{
        "body" = $Comment
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body

    return $response
}

# Usage:
# Add-GitHubPRComment -Token "YOUR_GITHUB_TOKEN" -Owner "OWNER_NAME" -Repo "REPO_NAME" -PullRequestId PR_NUMBER -Comment "YOUR_COMMENT"
