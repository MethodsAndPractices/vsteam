using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Text.RegularExpressions;

namespace vsteam_lib
{
   public class PickListTransformAttribute : ArgumentTransformationAttribute {
      [ExcludeFromCodeCoverage]
      public override object Transform(EngineIntrinsics engineIntrinsics, object InputData) {
          if ((InputData is string) )
         {
            string s = (InputData as string);
            if (!(string.IsNullOrEmpty(s)) && (s != "*"))
            {
               s = PickListCache.GetID(s);
               if (!string.IsNullOrEmpty(s) && !Regex.Match(s, "[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}").Success)
               {
                  throw (new ValidationMetadataException(s + " is not a valid PickList name.") );
               }
               else
               {
                  return s;
               }
            }
          }  
          return InputData;
      }
   }
}
