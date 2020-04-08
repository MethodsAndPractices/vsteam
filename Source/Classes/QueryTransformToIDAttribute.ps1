using namespace System.Management.Automation

class QueryTransformToIDAttribute : ArgumentTransformationAttribute {
   [object] Transform(
      [EngineIntrinsics] $EngineIntrinsics,
      [object] $InputData) {
      if ($InputData -notmatch "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}" -and 
         [VSTeamQueryCache]::queries.where({ $_.name -eq $InputData }).count) {
         $InputData = [VSTeamQueryCache]::queries.where({ $_.name -eq $InputData }).id
      }

      return $InputData
   }
}
