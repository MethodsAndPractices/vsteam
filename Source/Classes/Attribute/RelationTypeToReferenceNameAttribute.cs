using System.Management.Automation;

namespace vsteam_lib
{
   public sealed class RelationTypeToReferenceNameAttribute : ArgumentTransformationAttribute
   {
      public override object Transform(EngineIntrinsics engineIntrinsics, object inputData)
      {
         var value = inputData?.ToString();

         if (!string.IsNullOrEmpty(value))
         {
            value = RelationTypeCache.GetReferenceName(value);
         }

         return value;
      }
   }
}
