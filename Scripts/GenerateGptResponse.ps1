# API endpoint URL
function GenerateGptResponse {
    
    param (
        [string]$GptApiKey,
        [string]$errorDetails,
        [string]$systemRole
    )
        
    $apiUrl = "https://api.openai.com/v1/chat/completions"
    # Check if required parameters are provided
    if (-not $GptApiKey -or -not $errorDetails) {
        Write-Host "Usage: script.ps1 -GptApiKey <GptApiKey> -errorDetails <errorDetails>"
        exit 1
    }
    
    # Check if the length of $errorDetails is greater than 20,000 characters
    if ($errorDetails.Length -gt 20000) {
        # Trim $errorDetails to the first 20,000 characters
        $errorDetails = $errorDetails.Substring(0, 20000)
    }
    #"content" = "you are worlds best code validator generate simple summary of errors to developer on correcting the error in english language, take influence of ironman movie dialouges in while creating, group together based on file names. with funny tone in each line,  it must be posted to github comment for pr "
    #"content" = "ChatGPT, for the duration of this conversation, play the role of Balakrishna, telugu movie actor, acted in more than 100 films, get all info about balakrishna, and perform code review to developer in most nonsense way possible, tone: cinematic, spartan, use less corporate jargon, in simple english, no need to introduce yourself in answer group based on file names it must be posted to github comment for pr , telugu movie dialogues"

    $requestBody = @{
        "model"    = "gpt-4"    
        "temperature" = 1
        "max_tokens" = 256
        "top_p" = 1
        "frequency_penalty" = 0
        "presence_penalty" = 0
        "messages" = @(
            @{
                "role"    = "system"
                "content" = "$systemRole"
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
    
    # Write-Host "Generated messages: $messages"

    # Send the request using Invoke-RestMethod
    $gptresponse = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $requestBody

    # Extract the generated text from the response
    $generatedText = $gptresponse.choices[0].message.content

    # Display the generated text
    # Write-Host "Generated Text: $generatedText"

    return $generatedText 
}