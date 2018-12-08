Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToWorkItem {
   param($item)

   # If there are ids in the list that don't map to a work item and empty
   # entry is returned in its place if ErrorPolicy is Omit.
   if ($item) {
      $item.PSObject.TypeNames.Insert(0, 'Team.WorkItem')
   }
}

function Add-VSTeamWorkItem {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string]$Title,

      [Parameter(Mandatory = $false)]
      [string]$Description,

      [Parameter(Mandatory = $false)]
      [string]$IterationPath,

      [Parameter(Mandatory = $false)]
      [string]$AssignedTo
   )

   DynamicParam {
      $dp = _buildProjectNameDynamicParam -mandatory $true

      # If they have not set the default project you can't find the
      # validateset so skip that check. However, we still need to give
      # the option to pass a WorkItemType to use.
      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $wittypes = _getWorkItemTypes -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $wittypes
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of WorkItemType'
         $wittypes = $null
         $arrSet = $null
      }

      $ParameterName = 'WorkItemType'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -Mandatory $true
      $dp.Add($ParameterName, $rp)

      $dp
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # The type has to start with a $
      $WorkItemType = "`$$($PSBoundParameters["WorkItemType"])"

      # Constructing the contents to be send.
      # Empty parameters will be skipped when converting to json.
      $body = @(
         @{
            op    = "add"
            path  = "/fields/System.Title"
            value = $Title
         }
         @{
            op    = "add"
            path  = "/fields/System.Description"
            value = $Description
         }
         @{
            op    = "add"
            path  = "/fields/System.IterationPath"
            value = $IterationPath
         }
         @{
            op    = "add"
            path  = "/fields/System.AssignedTo"
            value = $AssignedTo
         }) | Where-Object { $_.value}

      # It is very important that even if the user only provides
      # a single value above that the item is an array and not
      # a single object or the call will fail.
      # You must call ConvertTo-Json passing in the value and not
      # not using pipeline.
      # https://stackoverflow.com/questions/18662967/convertto-json-an-array-with-a-single-item
      $json = ConvertTo-Json @($body) -Compress

      # Call the REST API
      $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitems' `
         -Version $([VSTeamVersions]::Core) -id $WorkItemType -Method Post `
         -ContentType 'application/json-patch+json' -Body $json

      _applyTypesToWorkItem -item $resp

      return $resp
   }
}

function Update-VSTeamWorkItem {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $Id,

      [Parameter(Mandatory = $false)]
      [string]$Title,

      [Parameter(Mandatory = $false)]
      [string]$Description,

      [Parameter(Mandatory = $false)]
      [string]$IterationPath,

      [Parameter(Mandatory = $false)]
      [string]$AssignedTo
   )

   Process {    
      # Constructing the contents to be send.
      # Empty parameters will be skipped when converting to json.
      $body = @(
         @{
            op    = "add"
            path  = "/fields/System.Title"
            value = $Title
         }
         @{
            op    = "add"
            path  = "/fields/System.Description"
            value = $Description
         }
         @{
            op    = "add"
            path  = "/fields/System.IterationPath"
            value = $IterationPath
         }
         @{
            op    = "add"
            path  = "/fields/System.AssignedTo"
            value = $AssignedTo
         }) | Where-Object { $_.value}

      # It is very important that even if the user only provides
      # a single value above that the item is an array and not
      # a single object or the call will fail.
      # You must call ConvertTo-Json passing in the value and not
      # not using pipeline.
      # https://stackoverflow.com/questions/18662967/convertto-json-an-array-with-a-single-item
      $json = ConvertTo-Json @($body) -Compress

      # Call the REST API
      $resp = _callAPI -Area 'wit' -Resource 'workitems' `
         -Version $([VSTeamVersions]::Core) -id $Id -Method Patch `
         -ContentType 'application/json-patch+json' -Body $json

      _applyTypesToWorkItem -item $resp

      return $resp
   }
}

function Show-VSTeamWorkItem {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [Alias('WorkItemID')]
      [int] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      Show-Browser "$([VSTeamVersions]::Account)/$ProjectName/_workitems/edit/$Id"
   }
}

function Get-VSTeamWorkItem {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $Id,

      [Parameter(ParameterSetName = 'List', Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int[]] $Ids,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('Fail', 'Omit')]
      [string] $ErrorPolicy = 'Fail',

      [ValidateSet('None', 'Relations', 'Fields', 'Links', 'All')]
      [string] $Expand = 'None',

      [string[]] $Fields
   )

   Process {
      # Call the REST API
      if ($Ids) {
         $resp = _callAPI -Area 'wit' -Resource 'workitems'  `
            -Version $([VSTeamVersions]::Core) `
            -Querystring @{
            '$Expand'   = $Expand
            fields      = ($Fields -join ',')
            errorPolicy = $ErrorPolicy
            ids         = ($ids -join ',')
         }

         foreach ($item in $resp.value) {
            _applyTypesToWorkItem -item $item
         }
      }
      else {
         $a = $id[0]
         $resp = _callAPI -Area 'wit' -Resource 'workitems'  `
            -Version $([VSTeamVersions]::Core) -id "$a" `
            -Querystring @{
            '$Expand' = $Expand
            fields    = ($Fields -join ',')
         }

         _applyTypesToWorkItem -item $resp
      }

      return $resp
   }
}

Set-Alias Add-WorkItem Add-VSTeamWorkItem
Set-Alias Get-WorkItem Get-VSTeamWorkItem
Set-Alias Show-WorkItem Show-VSTeamWorkItem
Set-Alias Update-WorkItem Update-VSTeamWorkItem

Export-ModuleMember `
   -Function Add-VSTeamWorkItem, Get-VSTeamWorkItem, Show-VSTeamWorkItem, Update-VSTeamWorkItem `
   -Alias Add-WorkItem, Get-WorkItem, Show-WorkItem, Update-WorkItem
