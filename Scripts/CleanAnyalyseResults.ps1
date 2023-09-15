function CleanAnyalyseResults {

    param (
        [string]$RawAnalysisResults
    )

    # Replace #json with {
    $RawAnalysisResults = $RawAnalysisResults -replace '#json{', '{'

    # Replace }#json with }
    $RawAnalysisResults = $RawAnalysisResults -replace '}#json', '}'

    # Parse the JSON data
    $jsonObject = $RawAnalysisResults | ConvertFrom-Json

    # Initialize an array to store description and recommendation pairs
    $descriptionRecommendations = @{}

    # Initialize a variable for ErrorSeverity
    $ErrorSeverity = ""

    # Iterate through the JSON object properties and extract descriptions and recommendations
    $jsonObject.PSObject.Properties | ForEach-Object {
        $propertyName = $_.Name

        if ($propertyName -like "*-ErrorSeverity") {
            $ErrorSeverity = $_.Value
        }

        if ($propertyName -like "*-FilePath") {
            $filePath = $_.Value
            if ($null -eq $filePath) {
                $FileName = "NoFile"
            }
            else {
                $FileName = Split-Path -Path $filePath -Leaf
            }
        }

        if ($propertyName -like "*-Description") {
            $description = $_.Value
        }
        elseif ($propertyName -like "*-Recommendation") {
            $recommendation = $_.Value
            if ($null -eq $recommendation) {
                $recommendation = "_"
            }
            else {
               
                $recommendation = $recommendation -replace '\[Learn more\..*$', ''
            }
            # Remove all characters after "[Learn more.]" including "[Learn more.]"

            # Create a custom object containing description and recommendation
            $descriptionRecommendation = [PSCustomObject]@{
                Description    = $description
                Recommendation = $recommendation
            }

            # Add the custom object to the hashtable using the FileName as the key
            if ($ErrorSeverity -ne "Info") {
                if ($descriptionRecommendations.ContainsKey($FileName)) {
                    $descriptionRecommendations[$FileName] += $descriptionRecommendation
                }
                else {
                    $descriptionRecommendations[$FileName] = @($descriptionRecommendation)
                }
            }
        }
    }

    # Convert the hashtable to JSON for the desired format
    $jsonOutput = $descriptionRecommendations | ConvertTo-Json

    # Output the JSON representation
    return $jsonOutput
}
