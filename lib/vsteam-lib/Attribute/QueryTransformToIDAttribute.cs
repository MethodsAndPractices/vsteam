using System.Management.Automation;
using System.Text.RegularExpressions;

namespace vsteam_lib
{
   public sealed class QueryTransformToIDAttribute : ArgumentTransformationAttribute
   {
      public override object Transform(EngineIntrinsics engineIntrinsics, object inputData)
      {
         // If input data isn't empty and is not a GUID, and it is found as a name in the cache,
         // then replace it with the match ID from the cache
         var value = inputData?.ToString();

         if (!string.IsNullOrEmpty(value) && !Regex.Match(value, "[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}").Success)
         {
            value = QueryCache.GetId(value);
         }

         return value;
      }
   }
}
