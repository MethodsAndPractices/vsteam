function Test-HelpFileDocumentation {
   [CmdletBinding()]
   param (
      [Parameter(Mandatory = $true)]
      [string]
      $MarkdownOutputPath,

      [Parameter(Mandatory = $true)]
      [string]
      $ModulePath,

      [Parameter(Mandatory = $false)]
      [string[]]
      $IgnoredParameters = @()
   )

   $missingExamples = @()
   $missingSpecificParameters = @{}

   # Check if the module is already imported
   if (-not (Get-Module -Name $ModulePath -ListAvailable)) {
      Import-Module $ModulePath -Force
   }

   # Get all markdown files from the output path
   $mdFiles = Get-ChildItem -Path $MarkdownOutputPath -Filter '*.md'

   foreach ($file in $mdFiles) {
      $cmdletName = $file.BaseName
      $content = Get-Content -Path $file.FullName -Raw

      # Check if the content has the EXAMPLES structure and at least one Example 1
      if (-not ($content -imatch '## EXAMPLES\s+### Example 1')) {
         $missingExamples += $cmdletName
      }

      # Check for specific parameter documentation
      $command = Get-Command -Name $cmdletName -ErrorAction SilentlyContinue
      if ($command) {
         $commonParameters = [System.Management.Automation.PSCmdlet]::CommonParameters + [System.Management.Automation.PSCmdlet]::OptionalCommonParameters
         $allIgnoredParameters = $commonParameters + $IgnoredParameters
         $parameters = $command.Parameters.Keys | Where-Object { $_ -cnotin $allIgnoredParameters }


         foreach ($param in $parameters) {
            if (-not ($content -imatch "### $param")) {
               if (-not $missingSpecificParameters[$cmdletName]) {
                  $missingSpecificParameters[$cmdletName] = @()
               }
               $missingSpecificParameters[$cmdletName] += $param
            }
         }

      }
   }

   # Generate error messages and output
   $totalErrors = $missingSpecificParameters.Count + $missingExamples.Count
   if ($totalErrors -gt 0) {
      $errorMessage = "Total cmdlets with missing $($missingExamples.Count) examples and missing $($missingSpecificParameters.Count) parameters `n"

      foreach ($cmdlet in $missingSpecificParameters.Keys) {
         $paramsList = $missingSpecificParameters[$cmdlet] -join ', '
         $filePath = Join-Path $MarkdownOutputPath "$cmdlet.md"
         $mdSourcePath = Join-Path ".docs" "$cmdlet.md"
         $ps1SourcePath = Join-Path "Source/Public" "$cmdlet.ps1"
         Write-Host "Issue in [$filePath](source:[$mdSourcePath], ps1:[$ps1SourcePath]): Missing parameters: $paramsList"
      }

      foreach ($cmdlet in $missingExamples) {
         $filePath = Join-Path $MarkdownOutputPath "$cmdlet.md"
         $sourcePath = Join-Path ".docs" "$cmdlet.md"
         Write-Host "Issue in [$filePath](source:[$sourcePath]): Missing examples."
      }

      throw $errorMessage
   }
   else {
      Write-Output 'All help files have appropriate documentation.'
   }
}
