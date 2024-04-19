function GenerateLlmSummary {
    param (
        [string]$prompt
    )

    # Define the URL
    $url = "http://localhost:11434/api/generate"

    # Define the content type
    $contentType = "text/plain"

    # Define the data
    $data = @"
{
    "model": "phi",
    "prompt": "$prompt",
    "stream": false
}
"@
    Write-Host $prompt
    try {

    # Make the POST request
    $response = Invoke-WebRequest -Uri $url -Method Post -ContentType $contentType -Body $data

    # Output the raw response content for inspection
    $response.Content

    # Decode the JSON response content
    $responseJson = ConvertFrom-Json $response.Content

    # Access the value of the "response" key
    $responseValue = $responseJson.response

    # Return the value of the "response" key
    return $responseValue
} catch {
    # Handle any exceptions that occur during the request
    Write-Error "An error occurred while making the web request: $_"
}
