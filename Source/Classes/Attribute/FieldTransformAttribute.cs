using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Linq;
namespace vsteam_lib
{
   public class FieldTransformAttribute : ArgumentTransformationAttribute {
      [ExcludeFromCodeCoverage]
      public override object Transform(EngineIntrinsics engineIntrinsics, object InputData) {
         if (InputData is string)
         {
            string s = (InputData as string);
            if (! string.IsNullOrEmpty(s))
            {
               s = FieldCache.GetRefName(s);
               var fieldList = FieldCache.GetCurrent();
            
               if (fieldList.Count() > 1 && ! fieldList.Contains(s) ) 
               {
                  throw (new ValidationMetadataException(s + " is not a valid Field name.") );
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
