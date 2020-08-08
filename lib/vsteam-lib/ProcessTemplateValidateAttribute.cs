using System.Linq;
using System.Management.Automation;

namespace vsteam_lib
{
   public class ProcessTemplateValidateAttribute : ValidateArgumentsAttribute
   {
      protected override void Validate(object arguments, EngineIntrinsics engineIntrinsics)
      {
         if (string.IsNullOrEmpty(arguments?.ToString()))
         {
            return;
         }

         var cache = ProcessTemplateCache.GetCurrent();

         if (cache.Count() > 0 && cache.All(s => string.Compare(arguments.ToString(), s) != 0))
         {
            throw new ValidationMetadataException($"'{arguments}' is an invalid process template name");
         }
      }
   }
}
