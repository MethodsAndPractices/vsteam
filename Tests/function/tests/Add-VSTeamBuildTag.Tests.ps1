Set-StrictMode -Version Latest

# Adds a tag to a build.
# Get-VSTeamOption 'build' 'tags'
# id              : 6e6114b2-8161-44c8-8f6c-c5505782427f
# area            : build
# resourceName    : tags
# routeTemplate   : {project}/_apis/{area}/builds/{buildId}/{resource}/{*tag}

Describe 'VSTeamBuildTag' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Add-VSTeamBuildTag' -Tag "Add" {
      ## Arrange
      BeforeAll {
         Mock _callAPI
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }
      }

      It 'should add tags to Build' {
         ## Arrange 
         $inputTags = "Test1", "Test2", "Test3"

         ## Act
         Add-VSTeamBuildTag -ProjectName project `
            -id 2 `
            -Tags $inputTags

         ## Assert
         foreach ($inputTag in $inputTags) {
            Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
               $Method -eq 'Put' -and
               $ProjectName -eq "project" -and
               $Area -eq "build/builds/2" -and 
               $Resource -eq "tags" -and 
               $Id -eq $inputTag -and 
               $Version -eq $(_getApiVersion Build)
            }
         }
      }
   }
}