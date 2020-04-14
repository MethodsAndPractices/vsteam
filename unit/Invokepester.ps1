function Invoke-PesterJob {
   [CmdletBinding(DefaultParameterSetName = 'LegacyOutputXml')]
   param(
      [Parameter(Position = 0)]
      [Alias('Path', 'relative_path')]
      [System.Object[]]
      ${Script},

      [Parameter(Position = 1)]
      [Alias('Name')]
      [string[]]
      ${TestName},

      [Parameter(Position = 2)]
      [switch]
      ${EnableExit},

      [Parameter(ParameterSetName = 'LegacyOutputXml', Position = 3)]
      [string]
      ${OutputXml},

      [Parameter(Position = 4)]
      [Alias('Tags')]
      [string[]]
      ${Tag},

      [string[]]
      ${ExcludeTag},

      [switch]
      ${PassThru},

      [System.Object[]]
      ${CodeCoverage},

      [switch]
      ${Strict},

      [Parameter(ParameterSetName = 'NewOutputSet', Mandatory = $true)]
      [string]
      ${OutputFile},

      [Parameter(ParameterSetName = 'NewOutputSet', Mandatory = $true)]
      [ValidateSet('LegacyNUnitXml', 'NUnitXml')]
      [string]
      ${OutputFormat},

      [ValidateSet('None', 'Default', 'Passed', 'Failed', 'Pending', 'Skipped', 'Inconclusive', 'Describe', 'Context', 'Summary', 'Header', 'All', 'Fails')]
      [string]
      ${Show},

      [switch]
      ${Quiet}
   )

   $params = $PSBoundParameters

   Start-Job -ScriptBlock { Set-Location $using:pwd; Invoke-Pester @using:params } |
      Receive-Job -Wait -AutoRemoveJob
}