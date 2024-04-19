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
    "prompt": "hi",
    "stream": false
}
"@
    Write-Host $data
    try {

        # Make the POST request
        $response = Invoke-WebRequest -Uri $url -Method Post -ContentType $contentType -Body $data -UseBasicParsing

        # Output the raw response content for inspection
        $response.Content

        # Decode the JSON response content
        $responseJson = ConvertFrom-Json $response.Content
        Write-Host "value from phi $responseJson" 
        # Access the value of the "response" key
        $responseValue = $responseJson.response

       Write-Host "value from phi"
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