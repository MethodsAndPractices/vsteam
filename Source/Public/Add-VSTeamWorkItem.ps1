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
      [string]$AssignedTo,

      [Parameter(Mandatory = $false)]
      [int]$ParentId,

      [Parameter(Mandatory = $false)]
      [string]$Tag,

      [Parameter(Mandatory = $false)]
      [object]$Link,

      [Parameter(Mandatory = $false)]
      [object]$CustomFields
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
         }
         @{
            op    = "add"
            path  = "/fields/System.Tags"
            value = $Tag
         }) | Where-Object { $_.value}

      if ($ParentId) {
         $parentUri = _buildRequestURI -ProjectName $ProjectName -Area 'wit' -Resource 'workitems' -id $ParentId
         $body += @{
            op    = "add"
            path  = "/relations/-"
            value = @{
               "rel" = "System.LinkTypes.Hierarchy-Reverse"
               "url" = $parentURI
            }
         }
      }

      if ($Link) {
         if (($Link.PSObject.Properties.name -contains "rel") -and ($Link.PSObject.Properties.name -contains "url")){
            $body +=  @{
               op    = "add"
               path  = "/relations/-"
               value = @{
                  rel   = $Link.rel
                  url   = $Link.url
                  attributes = @{
                     comment = $Link.comment
                  }
               }
            }
         }
      }

      if ($CustomFields) {
         ForEach-Object -InputObject $CustomFields {
            if (($_.PSObject.Properties.name -contains "op") -and ($_.PSObject.Properties.name -contains "path") -and ($_.PSObject.Properties.name -contains "value")){
               $body += @{
                  op    = $_.op
                  path  = $_.path
                  value = $_.value
               }
            }
         }
      }

      # It is very important that even if the user only provides
      # a single value above that the item is an array and not
      # a single object or the call will fail.
      # You must call ConvertTo-Json passing in the value and not
      # not using pipeline.
      # https://stackoverflow.com/questions/18662967/convertto-json-an-array-with-a-single-item
      $json = ConvertTo-Json @($body) -Depth 3 -Compress

      # Call the REST API
      $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitems' `
         -Version $([VSTeamVersions]::Core) -id $WorkItemType -Method Post `
         -ContentType 'application/json-patch+json' -Body $json

      _applyTypesToWorkItem -item $resp

      return $resp
   }
}