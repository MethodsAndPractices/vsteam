Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _testAdministrator {
   $user = [Security.Principal.WindowsIdentity]::GetCurrent()
   (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function _setEnvironmentVariables {
   param (
      [string] $Level = "Process",
      [string] $Pat,
      [string] $Acct
   )

   # You always have to set at the process level or they will Not
   # be seen in your current session.
   $env:TEAM_PAT = $Pat
   $env:TEAM_ACCT = $Acct

   # This is so it can be loaded by default in the next session
   if($Level -ne "Process") {
      [System.Environment]::SetEnvironmentVariable("TEAM_PAT", $Pat, $Level)
      [System.Environment]::SetEnvironmentVariable("TEAM_ACCT", $Acct, $Level)
   }
}

function _clearEnvironmentVariables {
   param (
      [string] $Level = "Process"
   )

   _setEnvironmentVariables -Level $Level -Pat $null -Acct $null
}

function Get-TeamInfo {
   return @{
      Account=$env:TEAM_ACCT
      DefaultProject=$Global:PSDefaultParameterValues['*:projectName']
   }
}

function Add-TeamAccount {
   [CmdletBinding(DefaultParameterSetName='Secure')]
   param(
      [parameter(ParameterSetName='Secure', Mandatory=$true, Position=1)]
      [Parameter(ParameterSetName='Plain')]
      [string] $Account,
      [parameter(ParameterSetName='Plain', Mandatory=$true, Position=2, HelpMessage='Personal Access Token')]
      [string] $PersonalAccessToken,
      [parameter(ParameterSetName='Secure', Mandatory=$true, HelpMessage='Personal Access Token')]
      [securestring] $PAT
   )

   DynamicParam {
      # Only add this option on Windows Machines
      if(_isOnWindows) {
         Write-Verbose 'On a Windows machine'

         $ParameterName = 'Level'

         # Create the dictionary
         $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

         # Create the collection of attributes
         $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

         # Create and set the parameters' attributes
         $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
         $ParameterAttribute.Mandatory = $false
         $ParameterAttribute.HelpMessage = "On Windows machines allows you to store the account information at the process, user or machine level. Not available on other platforms."

         # Add the attributes to the attributes collection
         $AttributeCollection.Add($ParameterAttribute)

         # Generate and set the ValidateSet
         if (_testAdministrator) {
            $arrSet = "Process", "User", "Machine"
         } else {
            $arrSet = "Process", "User"
         }

         $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

         # Add the ValidateSet to the attributes collection
         $AttributeCollection.Add($ValidateSetAttribute)

         # Create and return the dynamic parameter
         $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
         $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
         return $RuntimeParameterDictionary
      } else {
         Write-Verbose 'Not on a Windows machine'
      }
   }

   process {
      if ($PAT) {
         # Convert the securestring to a normal string
         # this was the one technique that worked on Mac, Linux and Windows
         $credential = New-Object System.Management.Automation.PSCredential $account,$PAT
         $_pat = $credential.GetNetworkCredential().Password
      } else {
         $_pat = $PersonalAccessToken
      }

      if(_isOnWindows) {
         # Bind the parameter to a friendly variable
         $Level = $PSBoundParameters[$ParameterName]

         if(-not $Level) {
            $Level = "Process"
         }
      } else {
         $Level = "Process"
      }

      # If they only gave an account name add visualstudio.com
      if($Account.ToLower().Contains('http') -eq $false) {
         $Account = "https://$($Account).visualstudio.com"
      }

	  $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$_pat"))

	  # If no PAT is entered, and on windows, assume we will be using default credentials for REST calls
	  if ((!$_pat) -and (_isOnWindows)) {
		Write-Verbose "Using Default Windows Credentials for authentication; no Personal Access Token provided"
		$encodedPat = ""
	  }

      _setEnvironmentVariables -Level $Level -Pat $encodedPat -Acct $account
   }
}

function Remove-TeamAccount {
   [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="Medium")]
   param(
      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      # Only add this option on Windows Machines
      if(_isOnWindows) {
         Write-Verbose 'On a Windows machine'

         $ParameterName = 'Level'

         # Create the dictionary
         $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

         # Create the collection of attributes
         $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

         # Create and set the parameters' attributes
         $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
         $ParameterAttribute.Mandatory = $false
         $ParameterAttribute.HelpMessage = "On Windows machines allows you to store the account information at the process, user or machine level. Not available on other platforms."

         # Add the attributes to the attributes collection
         $AttributeCollection.Add($ParameterAttribute)

         # Generate and set the ValidateSet
         if (_testAdministrator) {
            $arrSet = "All", "Process", "User", "Machine"
         } else {
            $arrSet = "All", "Process", "User"
         }

         $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

         # Add the ValidateSet to the attributes collection
         $AttributeCollection.Add($ValidateSetAttribute)

         # Create and return the dynamic parameter
         $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
         $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
         return $RuntimeParameterDictionary
      } else {
         Write-Verbose 'Not on a Windows machine'
      }
   }

   process {
      if(_isOnWindows) {
         # Bind the parameter to a friendly variable
         $Level = $PSBoundParameters[$ParameterName]

         if(-not $Level) {
            $Level = "Process"
         }
      } else {
         $Level = "Process"
      }

      switch ($Level) {
         "User" {
            $whatIf = "user level"
         }
         "All" {
            $whatIf = "all levels"
         }
         Default {
            $whatIf = "$Level level"
         }
      }

      if ($Force -or $pscmdlet.ShouldProcess($whatIf, "Remove Team Account")) {
         switch ($Level) {
            "Process" {
               Write-Verbose "Removing from user level."
               _clearEnvironmentVariables "Process"
            }
            "All" {
               Write-Verbose "Removing from all levels."
               Write-Verbose "Removing from proces level."
               _clearEnvironmentVariables "Process"

               Write-Verbose "Removing from user level."
               _clearEnvironmentVariables "User"

               if (_testAdministrator) {
                  Write-Verbose "Removing from machine level."
                  _clearEnvironmentVariables "Machine"
               } else {
                  Write-Warning "Must run as administrator to clear machine level."
               }
            }
            Default {
               Write-Verbose "Removing from $Level level."
               _clearEnvironmentVariables $Level
            }
         }

         Write-Output "Removed team account information"
      }
   }
}

function Clear-DefaultProject {
   $Global:PSDefaultParameterValues.Remove("*:projectName")

   Write-Output "Removed default project"
}

function Set-DefaultProject {
   [CmdletBinding()]
   param()
   DynamicParam {
      _buildProjectNameDynamicParam -ParameterName "Project"
   }

   begin {
      # Bind the parameter to a friendly variable
      $Project = $PSBoundParameters["Project"]
   }

   process {
      $Global:PSDefaultParameterValues["*:projectName"] = $Project
   }
}

Export-ModuleMember -Alias * -Function Get-TeamInfo, Add-TeamAccount, Remove-TeamAccount, Clear-DefaultProject, Set-DefaultProject