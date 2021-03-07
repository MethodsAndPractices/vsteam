$sampleFiles = "$PSScriptRoot/../../SampleFiles"

function Set-TestPrep {
   [CmdletBinding()]
   param(
      [switch] $skipEnvCheck
   )
   # Module must be loaded
   if (-not (Get-Module VSTeam)) {
      Write-Verbose "         Importing: module"
      Import-Module "$PSScriptRoot\..\..\..\dist\VSTeam.psd1"
   }

   if (-not $skipEnvCheck.IsPresent) {
      if ($null -eq $env:ACCT -or
         $null -eq $env:API_VERSION -or
         $null -eq $env:PAT -or
         $null -eq $env:EMAIL) {
         throw "You must set all environment variables that are needed first to run integration tests. Please see https://github.com/MethodsAndPractices/vsteam/blob/trunk/.github/CONTRIBUTING.md#running-integration-tests for details."
      }

      Write-Verbose "            Target: $($env:ACCT)"
      Write-Verbose "           Version: $($env:API_VERSION)"

      Set-VSTeamAccount -Account $env:ACCT -PersonalAccessToken $env:PAT -Version $env:API_VERSION
   }
}

function Set-Project {
   $projectName = 'TeamModuleIntegration-' + [guid]::NewGuid().toString().substring(0, 5)
   $projectDescription = 'Project for VSTeam integration testing.'

   # This will search for a project with the description of our test projects
   # if it finds one it will reuse that project instead of creating a new project.
   # This makes debuging tests easier and faster.
   $existingProject = $(Get-VSTeamProject | Where-Object Description -eq $projectDescription)

   if ($existingProject) {
      Write-Verbose "     Found Project: $($existingProject.Name)"
      $projectName = $existingProject.Name
   }
   else {
      Write-Verbose "  Creating Project: $projectName"
      Add-VSTeamProject -Name $projectName -Description $projectDescription | Should -Not -Be $null
      Start-Sleep -Seconds 5
   }

   $target = @{
      Name        = $projectName
      Description = $projectDescription
      NewName     = $projectName + [guid]::NewGuid().toString().substring(0, 5) + '1'
   }

   Write-Verbose "      Project Name: $($target.Name)"
   Write-Verbose "      Project Desc: $($target.Description)"
   Write-Verbose "   Project NewName: $($target.NewName)"

   return $target
}

function Get-ProjectName {
   # Everytime you run the test a new "$newProjectName" is generated.
   # This is fine if you are running all the tests but not if you just
   # want to run these. So if the newProjectName can't be found in the
   # target system change newProjectName to equal the name of the project
   # found with the correct description.
   $projectDescription = 'Project for VSTeam integration testing.'

   return ($(Get-VSTeamProject | Where-Object Description -eq $projectDescription)).Name
}

function Open-SampleFile {
   param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $file,
      [switch] $ReturnValue
   )

   if ($ReturnValue.IsPresent) {
      return $(Get-Content "$sampleFiles\$file" -Raw | ConvertFrom-Json).value
   }
   else {
      return $(Get-Content "$sampleFiles\$file" -Raw | ConvertFrom-Json)
   }
}