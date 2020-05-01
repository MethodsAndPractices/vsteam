Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamBuild.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamBuild.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamBuilds" {
   Context "Constructor" {
      Mock Get-VSTeamBuild { return @([PSCustomObject]@{
               id            = 1
               description   = ''
               buildNumber   = '1'
               status        = 'completed'
               result        = 'succeeded'
               startTime     = Get-Date
               lastChangedBy = [PSCustomObject]@{
                  id          = ''
                  displayName = 'Test User'
                  uniqueName  = 'test@email.com'
               }
               requestedBy   = [PSCustomObject]@{
                  id          = ''
                  displayName = 'Test User'
                  uniqueName  = 'test@email.com'
               }
               requestedFor  = [PSCustomObject]@{
                  id          = ''
                  displayName = 'Test User'
                  uniqueName  = 'test@email.com'
               }
               definition    = [PSCustomObject]@{
                  name     = 'Test CI'
                  fullname = 'Test CI'
               }
               project       = [PSCustomObject]@{
                  name = 'Test Project'
               }
            }
         )
      }

      $builds = [VSTeamBuilds]::new('TestBuild', 'TestProject')

      It 'Should create Builds' {
         $builds | Should Not Be $null
      }

      $build = $builds.GetChildItem()

      It 'Should return build' {
         $build | Should Not Be $null
      }
   }
}