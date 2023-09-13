function CleanAnyalyseResults {

    param (
        [string]$RawAnalysisResults
    )

    # Replace #json with {
    $RawAnalysisResults = $RawAnalysisResults -replace '#json{', '{'

    # Replace }#json with }
    $RawAnalysisResults = $RawAnalysisResults -replace '}#json', '}'

    # Output the modified string
    Write-Host $RawAnalysisResults
        
    # Parse the JSON data
    $jsonObject = $RawAnalysisResults | ConvertFrom-Json

    # Initialize an array to store description and recommendation pairs
    $descriptionRecommendations = @()

    # Iterate through the JSON object properties and extract descriptions and recommendations
    $jsonObject.PSObject.Properties | ForEach-Object {
        $propertyName = $_.Name
        if ($propertyName -like "*-Description") {
            $description = $_.Value
        }
        elseif ($propertyName -like "*-Recommendation") {
            $recommendation = $_.Value

            # Create a custom object containing description and recommendation
            $descriptionRecommendation = [PSCustomObject]@{
                Description    = $description
                Recommendation = $recommendation
            }

            # Add the custom object to the array
            $descriptionRecommendations += $descriptionRecommendation
        }
    }

    # Convert the array of objects to JSON
    $jsonOutput = $descriptionRecommendations | ConvertTo-Json

    # Output the JSON representation
    Write-Host $jsonOutput

    return $jsonOutput
}