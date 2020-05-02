function Get-VSTeamGitCommit {
   [CmdletBinding(DefaultParameterSetName = 'All')]
   param (
      [Parameter(ParameterSetName = 'All', ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = 'ItemVersion', ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = 'CompareVersion', ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = 'ByIds', ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = 'ItemPath', ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Alias('Id')]
      [Guid] $RepositoryID,

      [Parameter(ParameterSetName = 'All', HelpMessage = "FromDate, in UTC")]
      [Parameter(ParameterSetName = 'ItemVersion', HelpMessage = "FromDate, in UTC")]
      [Parameter(ParameterSetName = 'CompareVersion', HelpMessage = "FromDate, in UTC")]
      [Parameter(ParameterSetName = 'ItemPath', HelpMessage = "FromDate, in UTC")]
      [DateTime] $FromDate,
      
      [Parameter(ParameterSetName = 'All', HelpMessage = "ToDate, in UTC")]
      [Parameter(ParameterSetName = 'ItemVersion', HelpMessage = "ToDate, in UTC")]
      [Parameter(ParameterSetName = 'CompareVersion', HelpMessage = "ToDate, in UTC")]
      [Parameter(ParameterSetName = 'ItemPath', HelpMessage = "ToDate, in UTC")]
      [DateTime] $ToDate,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'ItemVersion', Mandatory = $true)]
      [Parameter(ParameterSetName = 'CompareVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [ValidateSet('branch', 'commit', 'tag')]
      [string] $ItemVersionVersionType,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'ItemVersion', Mandatory = $true)]
      [Parameter(ParameterSetName = 'CompareVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [string] $ItemVersionVersion,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'ItemVersion', Mandatory = $false)]
      [Parameter(ParameterSetName = 'CompareVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [ValidateSet('firstParent', 'none', 'previousChange')]
      [string] $ItemVersionVersionOptions,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'CompareVersion', Mandatory = $true)]
      [Parameter(ParameterSetName = 'ItemVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [ValidateSet('branch', 'commit', 'tag')]
      [string] $CompareVersionVersionType,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'CompareVersion', Mandatory = $true)]
      [Parameter(ParameterSetName = 'ItemVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [string] $CompareVersionVersion,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'CompareVersion', Mandatory = $false)]
      [Parameter(ParameterSetName = 'ItemVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [ValidateSet('firstParent', 'none', 'previousChange')]
      [string] $CompareVersionVersionOptions,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'ItemVersion')]
      [Parameter(ParameterSetName = 'CompareVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [string] $FromCommitId,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'ItemVersion')]
      [Parameter(ParameterSetName = 'CompareVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [string] $ToCommitId,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'ItemVersion')]
      [Parameter(ParameterSetName = 'CompareVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [string] $Author,
      
      [Parameter(ParameterSetName = "ByIds")]
      [string[]] $Ids,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'ItemPath', Mandatory = $true)]
      [string] $ItemPath,
      
      [Parameter(ParameterSetName = 'ItemPath')]
      [switch] $ExcludeDeletes,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'ItemVersion')]
      [Parameter(ParameterSetName = 'CompareVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [int] $Top,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'ItemVersion')]
      [Parameter(ParameterSetName = 'CompareVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [int] $Skip,
      
      [Parameter(ParameterSetName = 'ItemPath')]
      [ValidateSet('firstParent', 'fullHistory', 'fullHistorySimplifyMerges', 'simplifiedHistory')]
      [string] $HistoryMode,
      
      [Parameter(ParameterSetName = 'All')]
      [Parameter(ParameterSetName = 'ItemVersion')]
      [Parameter(ParameterSetName = 'CompareVersion')]
      [Parameter(ParameterSetName = 'ItemPath')]
      [string] $User,
      
      [Parameter(Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if (($ItemVersionVersionType -eq "commit") -and ($null -eq $ItemVersionVersion -or $ItemVersionVersion -eq '')) {
         throw "If you have a -ItemVersionVersionType of 'commit' you need to set a commit id as -ItemVersionVersion";
      }

      if (($CompareVersionVersionType -eq "commit") -and ($null -eq $CompareVersionVersion -or $CompareVersionVersion -eq '')) {
         throw "If you have a -CompareVersionVersionType of 'commit' you need to set a commit id as -CompareVersionVersion";
      }

      try {
         $queryString = @{
            'searchCriteria.fromDate'                      = if ($FromDate) { $FromDate.ToString('yyyy-MM-ddTHH:mm:ssZ') } else { $null }
            'searchCriteria.toDate'                        = if ($ToDate) { $ToDate.ToString('yyyy-MM-ddTHH:mm:ssZ') } else { $null }
            'searchCriteria.itemVersion.versionType'       = $ItemVersionVersionType
            'searchCriteria.itemVersion.version'           = $ItemVersionVersion
            'searchCriteria.itemVersion.versionOptions'    = $ItemVersionVersionOptions
            'searchCriteria.compareVersion.versionType'    = $CompareVersionVersionType
            'searchCriteria.compareVersion.version'        = $CompareVersionVersion
            'searchCriteria.compareVersion.versionOptions' = $CompareVersionVersionOptions
            'searchCriteria.fromCommitId'                  = $FromCommitId
            'searchCriteria.toCommitId'                    = $ToCommitId
            'searchCriteria.author'                        = $Author
            'searchCriteria.ids'                           = $Ids
            'searchCriteria.itemPath'                      = $ItemPath
            'searchCriteria.excludeDeletes'                = $ExcludeDeletes
            'searchCriteria.historyMode'                   = $HistoryMode
            'searchCriteria.$top'                          = $Top
            'searchCriteria.$skip'                         = $Skip
            'searchCriteria.user'                          = $User
         }

         $resp = _callAPI -ProjectName $ProjectName -Id "$RepositoryID/commits" -Area git -Resource repositories -Version $(_getApiVersion Git) -QueryString $queryString

         $obj = @()

         foreach ($item in $resp.value) {
            $obj += [VSTeamGitCommitRef]::new($item, $ProjectName)
         }

         Write-Output $obj
      }
      catch {
         throw $_
      }
   }
}