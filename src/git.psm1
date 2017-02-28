Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [string] $ProjectName,
      [guid] $Id
   )

   if(-not $env:TEAM_ACCT) {
      throw 'You must call Add-TeamAccount before calling any other functions in this module.'
   }

   $version = '1.0'
   $resource = "/git/repositories"
   $instance = $env:TEAM_ACCT

   if($ProjectName) {
      $instance += "/$ProjectName"
   }

   if($id) {
      $resource += "/$id"
   }

   # Build the url to list the projects
   return $instance + '/_apis' + $resource + '?api-version=' + $version
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.GitRepository')
}

function Remove-GitRepository {
   [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
   param(
      [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
      [guid[]] $Id,

      [switch] $Force
   )

   Process {
      foreach ($item in $id) {
         # Build the url to delete the build
         $listurl = _buildURL -id $item

         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Repository")) {
            try {
               # Call the REST API
               $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}

               Write-Output "Deleted repository $item"
            }
            catch [System.Net.WebException] {
               _handleException $_
            }
            catch {
               # Dig into the exception to get the Response details.
               # Note that value__ is not a typo.
               $errMsg = "Failed`nStatusCode: $($_.Exception.Response.StatusCode.value__)`nStatusDescription: $($_.Exception.Response.StatusDescription)"
               Write-Error $errMsg

               throw $_
            }
         }
      }
   }
}

function Add-GitRepository {
   [CmdletBinding()]
   param(
      [parameter(Mandatory=$true)]
      [string] $Name
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Build the url to list the projects
      $listurl = _buildURL -ProjectName $ProjectName

      $body = '{"name": "'+ $Name +'"}'

      Write-Verbose $body

      try {
         # Call the REST API
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -ContentType "application/json" -Body $body -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}

         Write-Output $resp
      }
      catch [System.Net.WebException] {
         _handleException $_
      }
      catch {
         # Dig into the exception to get the Response details.
         # Note that value__ is not a typo.
         $errMsg = "Failed`nStatusCode: $($_.Exception.Response.StatusCode.value__)`nStatusDescription: $($_.Exception.Response.StatusDescription)"
         Write-Error $errMsg

         throw $_
      }
   }
}

function Get-GitRepository {
   [CmdletBinding()]
   param (
      [Parameter(ParameterSetName='ByID', ValueFromPipeline=$true)]
      [Alias('RepositoryID')]
      [guid[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $false
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         foreach ($item in $id) {
            # Build the url to return the single build
            $listurl = _buildURL -projectName $ProjectName -id $item

            # Call the REST API
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}

            _applyTypes -item $resp

            Write-Output $resp
         }
      } else {
         # Build the url to list the builds
         $listurl = _buildURL -projectName $ProjectName

         # Call the REST API
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach($item in $resp.value) {
            _applyTypes -item $item
         }

         Write-Output $resp.value
      }
   }
}

Export-ModuleMember -Alias * -Function Get-GitRepository, Add-GitRepository, Remove-GitRepository