# Install the MicrosoftPowerBIMgmt module if not already installed  
# Install-Module -Name MicrosoftPowerBIMgmt -Scope CurrentUser  
  
# Import the module  
Import-Module MicrosoftPowerBIMgmt  
  
# Connect to the Power BI Service, remember that you must connect with your ISO1/71 account, but before that the PBI Admin role must be activated
Connect-PowerBIServiceAccount  
  
# Retrieve the list of workspaces  
$workspaces = Get-PowerBIWorkspace  
  
# Sort the workspaces by their names alphabetically  
$sortedWorkspaces = $workspaces | Sort-Object -Property Name  
  
# Display the sorted workspaces with their display names and IDs  
$sortedWorkspaces | Format-Table Name, Id  
