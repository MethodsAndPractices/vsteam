Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [string] $ProjectName
   )

   if(-not $env:TEAM_ACCT) {
      throw 'You must call Add-TeamAccount before calling any other functions in this module.'
   }

   $version = '1.0'
   $resource = "/projects/$ProjectName"
   $instance = $env:TEAM_ACCT

   # Build the url to list the projects
   return $instance + '/_apis' + $resource + '?api-version=' + $version
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Project')

   # Only returned for a single item
   if($item.PSObject.Properties.Match('defaultTeam').count -gt 0 -and $item.defaultTeam -ne $null) {
      $item.defaultTeam.PSObject.TypeNames.Insert(0, 'Team.Team')
   }

   if($item.PSObject.Properties.Match('_links').count -gt 0 -and $item._links -ne $null) {
      $item._links.PSObject.TypeNames.Insert(0, 'Team.Links')
   }
}

function _checkStatus {
   param(
      [Parameter(Mandatory=$true)]
      [string] $Uri
   )

   # Call the REST API
   if (_useWindowsAuthenticationOnPremise) {
     $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $uri -UseDefaultCredentials
   } else {
     $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $uri -Headers @{Authorization = "Basic $env:TEAM_PAT"}
   }

   return $resp
}

function _trackProgress {
   param(
      [Parameter(Mandatory=$true)] $Resp,
      [string] $Title,
      [string] $Msg
   )

   $i = 0
   $x = 1
   $y = 10
   $status = $resp.status

   # Track status
   while ($status -ne 'failed' -and $status -ne 'succeeded') {
      $status = (_checkStatus $resp.url).status

      # oscillate back a forth to show progress
      $i += $x
      Write-Progress -Activity $title -Status $msg -PercentComplete ($i/$y*100)

      if($i -eq $y -or $i -eq 0) {
         $x *= -1
      }
   }
}

function Get-Project {
   [CmdletBinding(DefaultParameterSetName='List')]
   param(
      [Parameter(ParameterSetName='List')]
      [ValidateSet('WellFormed','CreatePending', 'Deleting', 'New', 'All')]
      [string] $StateFilter = 'WellFormed',
      [Parameter(ParameterSetName='List')]
      [int] $Top = 100,
      [Parameter(ParameterSetName='List')]
      [int] $Skip = 0,
      [Parameter(ParameterSetName='ByID')]
      [Alias('ProjectID')]
      [string] $Id,
      [Parameter(ParameterSetName='ByID')]
      [switch] $IncludeCapabilites
   )

   DynamicParam {
      _buildProjectNameDynamicParam -ParameterSetName 'ByName' -ParameterName 'Name'
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["Name"]

      if($id) {
         $ProjectName = $id
      }

      if($ProjectName) {
         # Build the url to list the projects
         $listurl = _buildURL -ProjectName $ProjectName

         if ($includeCapabilites.IsPresent) {
            $listurl += '&includeCapabilities=true'
         }

         # Call the REST API
         if (_useWindowsAuthenticationOnPremise) {
           $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
         } else {
		 Write-Host Calling normal
           $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
         }

         # Apply a Type Name so we can use custom format view and custom type extensions
         _applyTypes -item $resp

         Write-Output $resp
      } else {
         # Build the url to list the projects
         $listurl = "$(_buildURL)&stateFilter=$($stateFilter)&`$top=$($top)&`$skip=$($skip)"

         try {
            # Call the REST API
            if (_useWindowsAuthenticationOnPremise) {
              $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
            } else {
              $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
            }

            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach($item in $resp.value) {
               _applyTypes -item $item
            }

            Write-Output $resp.value
         }
         catch {
            # I catch because using -ErrorAction Stop on the Invoke-RestMethod
            # was still running the foreach after and reporting useless errors.
            # This casuses the first error to terminate this execution.
            throw $_
         }
      }
   }
}

function Update-Project {
   [CmdletBinding()]
   param(
      [string] $NewName = '',
      [string] $NewDescription = ''
   )

   DynamicParam {
      _buildProjectNameDynamicParam -ParameterName 'Name'
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["Name"]

      if($newName -eq '' -and $newDescription -eq '') {
         # There is nothing to do
         Write-Verbose 'Nothing to update'
         return
      }

      # At the end we return the project and need it's name
      # this is used to track the final name.
      $finalName = $ProjectName

      # Build the url to list the projects
      $listurl = _buildURL -ProjectName (Get-Project $ProjectName).id

      if($newName -ne '' -and $newDescription -ne '') {
         $finalName = $newName
         $msg = "Changing name and description"
         $body = '{"name": "' + $newName + '", "description": "' + $newDescription + '"}'
      }
      elseif ($newName -ne '') {
         $finalName = $newName
         $msg = "Changing name"
         $body = '{"name": "'+ $newName +'"}'
      }
      else {
         $msg = "Changing description"
         $body = '{"description": "'+ $newDescription +'"}'
      }

      Write-Verbose $body

      # Call the REST API
	  if (_useWindowsAuthenticationOnPremise) {
        $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Patch -ContentType "application/json" -Body $body -Uri $listurl -UseDefaultCredentials
	  } else {
        $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Patch -ContentType "application/json" -Body $body -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
	  }

      _trackProgress -resp $resp -title 'Updating team project' -msg $msg

      # Return the project now that it has been updated
      return Get-Project -Name $finalName
   }
}

function Add-Project {
   param(
      [parameter(Mandatory=$true)]
      [string] $Name,

      [ValidateSet('Agile','CMMI', 'Scrum')]
      [string] $ProcessTemplate = 'Scrum',

      [string] $Description,

      [switch] $TFVC
   )

   $srcCtrl = 'Git'
   $templateTypeId = ''

   switch ($ProcessTemplate) {
      'Agile' {
         $templateTypeId = 'adcc42ab-9882-485e-a3ed-7678f01f66bc'
      }
      'CMMI'  {
         $templateTypeId = '27450541-8e31-4150-9947-dc59f998fc01'
      }
      # The default is Scrum
      Default {
         $templateTypeId = '6b724908-ef14-45cf-84f8-768b5384da45'
      }
   }

   if($TFVC.IsPresent) {
      $srcCtrl = "Tfvc"
   }

   # Build the url to list the projects
   $listurl = _buildURL

   $body = '{"name": "'+ $Name +'", "description": "' + $Description + '", "capabilities": {"versioncontrol": { "sourceControlType": "' + $srcCtrl + '"}, "processTemplate":{"templateTypeId": "' + $templateTypeId + '"}}}'

   Write-Verbose $body

   try {
      # Call the REST API
	  if (_useWindowsAuthenticationOnPremise) {
        $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -ContentType "application/json" -Body $body -Uri $listurl -UseDefaultCredentials
	  } else {
        $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -ContentType "application/json" -Body $body -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
	  }

      _trackProgress -resp $resp -title 'Creating team project' -msg "Name: $($Name), Template: $($processTemplate), Src: $($srcCtrl)"

      return Get-Project -ProjectID $resp.id
   }
   catch {
      # Dig into the exception to get the Response details.
      # Note that value__ is not a typo.
      $errMsg = "Failed`nStatusCode: $($_.Exception.Response.StatusCode.value__)`nStatusDescription: $($_.Exception.Response.StatusDescription)"
      Write-Error $errMsg

      throw $_
   }
}

function Remove-Project {
   [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
   param(
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam -ParameterName 'Name'
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["Name"]

      # Build the url to list the projects
      $listurl = _buildURL -ProjectName (Get-Project $ProjectName).id

      if ($Force -or $pscmdlet.ShouldProcess($ProjectName, "Delete Project")) {
         # Call the REST API
	     if (_useWindowsAuthenticationOnPremise) {
           $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -UseDefaultCredentials
	     } else {
           $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
	     }

         _trackProgress -resp $resp -title 'Deleting team project' -msg "Deleting $ProjectName"

         Write-Output "Deleted $ProjectName"
      }
   }
}

Export-ModuleMember -Alias * -Function Get-Project, Update-Project, Add-Project, Remove-Project