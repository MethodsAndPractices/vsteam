Describe "VSTeamProject" {
   BeforeAll {
      . "$PSScriptRoot/testprep.ps1"

      Set-TestPrep

      $target = Set-Project
   }

   Context 'Remove-VSTeamProject' {
      It 'should remove Project' {
         # I have noticed that if the delete happens too soon you will get a
         # 400 response and told to try again later. So this test needs to be
         # retried. We need to wait a minute after the rename before we try
         # and delete
         Start-Sleep -Seconds 5

         Get-VSTeamProject -Name $target.Name | Remove-VSTeamProject -Force

         Start-Sleep -Seconds 5

         $(Get-VSTeamProject | Where-Object name -eq $target.Name) | Should -Be $null
      }
   }
}