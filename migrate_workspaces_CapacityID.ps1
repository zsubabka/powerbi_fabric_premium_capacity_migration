
#Requires -Modules @{ ModuleName="MicrosoftPowerBIMgmt"; ModuleVersion="1.2.1026" }  
  
param (  
    $sourceCapacityId = "YourSourceCapacityId",  # Replace with source capacity ID  
    $targetCapacityId = "YourTargetCapacityId"   # Replace with target capacity ID  
)  
  
$ErrorActionPreference = "Stop"  
  
# Connect to Power BI Service, before make sure that the normal user account has Admin access to the capacities
Connect-PowerBIServiceAccount  
  
Write-Host "Getting existent capacities"  
$capacities = Get-PowerBICapacity  
$capacities | Format-Table  
  
$sourceCapacity = ($capacities | ? Id -eq $sourceCapacityId | select -First 1)  
if (!$sourceCapacity) {  
    throw "Cannot find capacity with ID '$sourceCapacityId'"  
}  
  
$targetCapacity = ($capacities | ? Id -eq $targetCapacityId | select -First 1)  
if (!$targetCapacity) {  
    throw "Cannot find capacity with ID '$targetCapacityId'"  
}  
  
Write-Host "Getting workspaces"  
$premiumWorkspaces  = Get-PowerBIWorkspace -Scope Organization -All -Filter "isOnDedicatedCapacity eq true and tolower(state) eq 'active'"  
$sourcePremiumWorkspaces = @($premiumWorkspaces | ? {$_.capacityId -eq $sourceCapacity.Id}) | sort-object -Property Id -Unique  
  
if ($sourcePremiumWorkspaces.Count -gt 0) {  
    Write-Host "Assigning $($sourcePremiumWorkspaces.Count) workspaces to new capacity '$($targetCapacity.DisplayName)' / '$($targetCapacity.Id)'"  
    $sourcePremiumWorkspaces | Format-Table  
      
    $confirmation = Read-Host "Are you Sure You Want To Proceed (y)"  
    if ($confirmation -ieq 'y') {  
        $workspaceIds = @($sourcePremiumWorkspaces.id)  
          
        # Create the body for the REST API call  
        $body = @{  
            capacityMigrationAssignments = @(@{  
                targetCapacityObjectId = $targetCapacity.Id  
                workspacesToAssign = $workspaceIds  
            })  
        }  
        $bodyStr = ConvertTo-Json $body -Depth 3  
          
        # Invoke the REST API to assign workspaces to the new capacity  
        Invoke-PowerBIRestMethod -url "admin/capacities/AssignWorkspaces" -method Post -body $bodyStr  
    }  
} else {  
    Write-Host "No workspaces on source capacity: '$($sourceCapacity.DisplayName)' / '$($sourceCapacity.Id)'"  
}  
