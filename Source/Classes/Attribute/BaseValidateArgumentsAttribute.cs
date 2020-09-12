using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;

namespace vsteam_lib
{
   public abstract class BaseValidateArgumentsAttribute : ValidateArgumentsAttribute
   {
      internal abstract IEnumerable<string> GetValues();

      protected override void Validate(object arguments, EngineIntrinsics engineIntrinsics)
      {
         if (string.IsNullOrEmpty(arguments?.ToString()))
         {
            return;
         }

         var cache = this.GetValues();

         if (cache.Count() > 0 && cache.All(s => string.Compare(arguments.ToString(), s, true) != 0))
         {
            throw new ValidationMetadataException($"'{arguments}' is invalid");
         }
      }
   }
}
