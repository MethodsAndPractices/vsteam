function Port-Tests {
   [CmdletBinding()]
   param (
      [Parameter(Mandatory = $True, Position = 0)]
      [string]
      $inputFile
   )

   begin {

   }

   process {
      $fullPath = $(Resolve-Path $inputFile)
      Write-Verbose "Full Path: $fullPath"

      $fileContents = Get-Content $fullPath -Encoding UTF8 -Raw
      $newFileContents = ($fileContents -replace '#region include', 'BeforeAll {')
      $newFileContents = ($newFileContents -replace '#endregion', '}')
      $newFileContents = ($newFileContents -replace '\$here = Split-Path -Parent \$MyInvocation.MyCommand.Path', '')
      $newFileContents = ($newFileContents -replace 'MyInvocation.MyCommand.Path', 'PSCommandPath')
      $newFileContents = ($newFileContents -replace '\$here', '$PSScriptRoot')
      $newFileContents = ($newFileContents -replace 'Assert-MockCalled', 'Should -Invoke')
      $newFileContents = ($newFileContents -replace 'Assert-VerifiableMock', 'Should -InvokeVerifiable')
      $newFileContents = ($newFileContents -replace '\| Should Throw', '| Should -Throw')
      $newFileContents = ($newFileContents -replace '\| Should Be', '| Should -Be')
      $newFileContents = ($newFileContents -replace '\| Should Not BeNullOrEmpty', '| Should -Not -BeNullOrEmpty')

      $lines = $newFileContents -split [Environment]::NewLine

      $addingBeforeAll = $false
      $beforeAllFound = $false
      $describeFound = $false
      $contextFound = $false
      $itFound = $false
      $contents = New-Object System.Text.StringBuilder

      foreach ($line in $lines) {
         if ($line -match "Set-StrictMode\s*") {
            $contents.AppendLine($line.TrimEnd()) | Out-Null
            continue
         }

         if ($line -match "BeforeAll\s*{") {
            $beforeAllFound = $true
            $contents.AppendLine($line.TrimEnd()) | Out-Null
            continue
         }

         if ($line -match "^\s*Describe\s*[-""'{]") {
            $describeFound = $true

            if ($addingBeforeAll) {
               $addingBeforeAll = $false
               $contents.Remove($contents.Length - 1, 1) | Out-Null
               $contents.AppendLine('}') | Out-Null
               $contents.AppendLine('') | Out-Null
            }

            $contents.AppendLine($line.TrimEnd()) | Out-Null
            continue
         }

         if ($line -match "^\s*Context\s*[-""'{]") {
            $contextFound = $true
            $describeFound = $false

            if ($addingBeforeAll) {
               $addingBeforeAll = $false
               $contents.Remove($contents.Length - 1, 1) | Out-Null
               $contents.AppendLine('}') | Out-Null
               $contents.AppendLine('') | Out-Null
            }

            $contents.AppendLine($line.TrimEnd()) | Out-Null
            continue
         }

         if ($line -match "^\s*It\s*[-""'{]") {
            $itFound = $true
            $contextFound = $false

            if ($addingBeforeAll) {
               $addingBeforeAll = $false
               $contents.Remove($contents.Length - 1, 1) | Out-Null
               $contents.AppendLine('}') | Out-Null
               $contents.AppendLine('') | Out-Null
            }

            $contents.AppendLine($line.TrimEnd()) | Out-Null
            continue
         }

         if ($line -match "^\s*}") {
            if ($itFound) {
               $itFound = $false               
            }
            $contents.AppendLine($line.TrimEnd()) | Out-Null
            continue
         }

         if (-not [string]::IsNullOrWhiteSpace($line) -and $line -notmatch "^\s*#" -and -not $beforeAllFound) {
            if (-not $addingBeforeAll -and -not $itFound) {
               # If you are not in a It or BeforeAll you need to add it
               $addingBeforeAll = $True
               $contents.AppendLine('BeforeAll {') | Out-Null
            }
            
            $contents.AppendLine($line.TrimEnd()) | Out-Null
            continue
         }

         if (-not $addingBeforeAll -and $describeFound -and -not $contextFound) {
            $addingBeforeAll = $True
            $contents.AppendLine('BeforeAll {') | Out-Null
         }

         if (-not $addingBeforeAll -and $contextFound -and -not $itFound) {
            $addingBeforeAll = $True
            $contents.AppendLine('BeforeAll {') | Out-Null
         }

         $contents.AppendLine($line.TrimEnd()) | Out-Null
      }

      Set-Content -Path $fullPath -Value $contents.ToString()
   }

   end {

   }
}