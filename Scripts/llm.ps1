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
    "model": "llama3",
    "prompt": "$($prompt)",
    "stream": false
}
"@
    Write-Host $data
    try {

        # Make the POST request
        $response = Invoke-WebRequest -Uri $url -Method Post -ContentType $contentType -Body $data -UseBasicParsing

        # Decode the JSON response content
        $responseJson = ConvertFrom-Json $response.Content
        Write-Host "value from llama2 $responseJson"

        # Access the value of the "response" key and convert it to string
        $responseValue = $responseJson.response | Out-String

        Write-Host "Value from phi:"
        Write-Host $responseValue

        # Return the value of the "response" key
        return $responseValue
    }
    catch {
        # Handle any exceptions that occur during the request
        Write-Error "An error occurred while making the web request: $_" 
        return $prompt
    }
}