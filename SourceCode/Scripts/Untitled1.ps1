# Define the JSON string without unnecessary escape characters
$jsonString = '{
    "NoFile":  [
        {
            "Your organization requires your project to have an Automation Hub URL defined.":  "Use \"Project Settings\" to add the missing information."
        }
    ],
    "Main.xaml":  [
        {
            "Variable _out_HttpClient_1__ResponseHeaders name length should not be above 30 characters.":  "Variable name length should not be above 30 characters. Consider abbreviating longer words."
        },
        {
            "Variable _out_DeserializeJson_Generic_1_1__JsonObject name length should not be above 30 characters.":  "Variable name length should not be above 30 characters. Consider abbreviating longer words."
        },
        {
            "Activity Write Text File has a default name.":  "Check if it could be easier to understand what the activity does by adding a more descriptive title."
        },
        {
            "Activity Log Message has a default name.":  "Check if it could be easier to understand what the activity does by adding a more descriptive title."
        },
        {
            "Activity Deserialize JSON has a default name.":  "Check if it could be easier to understand what the activity does by adding a more descriptive title."
        },
        {
            "Activity Read Text File has a default name.":  "Check if it could be easier to understand what the activity does by adding a more descriptive title."
        }
    ]
}'

# Convert the JSON string to a PowerShell object
$jsonObject = ConvertFrom-Json $jsonString

# Output the PowerShell object
Write-Output $jsonObject | Out-String
