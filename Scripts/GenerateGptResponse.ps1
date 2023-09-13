# API endpoint URL
function GenerateGptResponse {
    
    param (
        [string]$GptApiKey,
        [string]$errorDetails
    )
        
    $apiUrl = "https://api.openai.com/v1/chat/completions"
    # Check if required parameters are provided
    if (-not $GptApiKey -or -not $errorDetails) {
        Write-Host "Usage: script.ps1 -GptApiKey <GptApiKey> -errorDetails <errorDetails>"
        exit 1
    }

    $requestBody = @{
        "model"    = "gpt-3.5-turbo"
        "messages" = @(
            @{
                "role"    = "system"
                "content" = "you are worlds best code validator generate simple summary of errors to guide developer on correcting the error in pure english summary."
            },
            @{
                "role"    = "user"
                "content" = "$errorDetails"
            }
        )
    } | ConvertTo-Json
    
    # Prepare the headers
    $headers = @{
        "Content-Type"  = "application/json"
        "Authorization" = "Bearer $GptApiKey"
    }
    
    # Send the request using Invoke-RestMethod
    $gptresponse = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $requestBody

    # Extract the generated text from the response
    $generatedText =   $gptresponse.choices[0].message.content

    # Display the generated text
    Write-Host "Generated Text: $generatedText"

    return $generatedText 
}