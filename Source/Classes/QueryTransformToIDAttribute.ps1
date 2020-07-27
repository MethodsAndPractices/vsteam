using namespace System.Management.Automation

class QueryTransformToIDAttribute : ArgumentTransformationAttribute {
   [object] Transform(
      [EngineIntrinsics] $EngineIntrinsics,
      [object] $InputData) {
      # If input data isn't empty and is not a GUID, and it is found as a name in the cache,
      # then replace it with the match ID from the cache
      if ($InputData -and $InputData -notmatch "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}" -and
         [VSTeamQueryCache]::queries.where( { $_.name -eq $InputData }).count) {
         $InputData = [VSTeamQueryCache]::queries.where( { $_.name -eq $InputData }).id
      }

      return $InputData
   }
}