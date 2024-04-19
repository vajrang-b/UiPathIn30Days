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
    # Make the POST request
    $response = Invoke-WebRequest -Uri $url -Method Post -ContentType $contentType -Body $data

    # Decode the JSON response content
    $responseJson = ConvertFrom-Json $response.Content

    # Access the value of the "response" key
    $responseValue = $responseJson.response

    # Return the value of the "response" key
    return $responseValue
}
