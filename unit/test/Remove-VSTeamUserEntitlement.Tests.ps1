Set-StrictMode -Version Latest

Describe "VSTeamUserEntitlement" {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
   }

   Context "Remove-VSTeamUserEntitlement" {
      BeforeAll {
         Mock _getApiVersion { return 'VSTS' }
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }
      }

      Context 'Remove-VSTeamUserEntitlement' {
         BeforeAll {
            # Get-VSTeamUserEntitlement by Id
            Mock _callAPI {
               return [PSCustomObject]@{
                  accessLevel = [PSCustomObject]@{ }
                  email       = 'test@user.com'
                  userName    = 'Test User'
                  id          = '00000000-0000-0000-0000-000000000000'
               }
            } -ParameterFilter { $Id -eq '00000000-0000-0000-0000-000000000000' }

            # Get-VSTeamUserEntitlement by email
            Mock _callAPI {
               return [PSCustomObject]@{
                  members = [PSCustomObject]@{
                     accessLevel = [PSCustomObject]@{ }
                     email       = 'test@user.com'
                     userName    = 'Test User'
                     id          = '00000000-0000-0000-0000-000000000000'
                  }
               }
            }

            # Remove Call
            Mock _callAPI -ParameterFilter { $Method -eq 'Delete' }
         }

         It 'by Id should remove user' {
            Remove-VSTeamUserEntitlement -UserId '00000000-0000-0000-0000-000000000000' -Force
            Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
               $subDomain -eq 'vsaex' -and
               $id -eq '00000000-0000-0000-0000-000000000000' -and
               $resource -eq 'userentitlements' -and
               $method -eq 'Delete' -and
               $version -eq $(_getApiVersion MemberEntitlementManagement)
            }
         }

         It 'bye email should remove user' {
            Remove-VSTeamUserEntitlement -Email 'test@user.com' -Force
            Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
               $Method -eq 'Delete' -and
               $subDomain -eq 'vsaex' -and
               $id -eq '00000000-0000-0000-0000-000000000000' -and
               $resource -eq 'userentitlements' -and
               $version -eq $(_getApiVersion MemberEntitlementManagement)
            }
         }

         It 'by invalid email should throw' {
            { Remove-VSTeamUserEntitlement -Email 'not@found.com' -Force } | Should -Throw
         }
      }
   }
}