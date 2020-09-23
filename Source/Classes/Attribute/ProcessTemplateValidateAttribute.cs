using System.Collections.Generic;

namespace vsteam_lib
{
   public class ProcessTemplateValidateAttribute : BaseValidateArgumentsAttribute
   {
      internal override IEnumerable<string> GetValues() => ProcessTemplateCache.GetCurrent();
   }
}
