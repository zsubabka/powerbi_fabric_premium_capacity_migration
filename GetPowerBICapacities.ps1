# Install and update the Power BI Management module (run this separately if not already installed)  
# Install-Module -Name MicrosoftPowerBIMgmt -AllowClobber -Force  
# Update-Module -Name MicrosoftPowerBIMgmt  

# Connect to the Power BI Service  
Connect-PowerBIServiceAccount  

# Retrieve the list of capacities,remember that you must connect with your ISO1/71 account, but before that the PBI Admin role must be activated
$capacities = Get-PowerBICapacity  

# Display the capacities with their display names and IDs  
$capacities | Format-Table DisplayName, Id 