function Remove-VSTeamAccessControlEntry {
    [CmdletBinding(DefaultParameterSetName = 'ByNamespace')]
    param(
       [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true, ValueFromPipeline = $true)]
       [VSTeamSecurityNamespace] $SecurityNamespace,
 
       [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
       [ValidateScript({
          try {
              [System.Guid]::Parse($_) | Out-Null
              $true
          } catch {
              $false
          }
       })]
       [string] $SecurityNamespaceId,
 
       [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true)]
       [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
       [string] $Token,
 
       [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true)]
       [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
       [string] $Descriptor
    )
 
    process {
        if ($SecurityNamespace)
        {
            $SecurityNamespaceId = $SecurityNamespace.ID
        }

        if ($Descriptor -like "*,*")
        {
            $Descriptors = @()

            foreach($UniqueDescriptor in $Descriptor.Split(","))
            {
                $UniqueDescriptor = ($UniqueDescriptor).split(".")[1]
                $UniqueDescriptor = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($UniqueDescriptor))
                $UniqueDescriptor = "Microsoft.TeamFoundation.Identity;"+"$UniqueDescriptor"

                $Descriptors += $UniqueDescriptor
            }

            [Uri]$Uri = "$($env:TEAM_ACCT)/_apis/accesscontrolentries/$($securityNamespaceId)?token=$($token)&descriptors=$($descriptors -join ",")&api-version=5.1"
        }
        else 
        {
            $Descriptor = ($descriptor).split(".")[1]
            $Descriptor = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Descriptor))
            $Descriptor = "Microsoft.TeamFoundation.Identity;"+"$descriptor"

            [Uri]$Uri = "$($env:TEAM_ACCT)/_apis/accesscontrolentries/$($securityNamespaceId)?token=$($token)&descriptors=$($descriptor)&api-version=5.1"
        }

        # Call the REST API
        $resp = _callAPI -method DELETE -Url $Uri -ContentType "application/json"
    }
 }