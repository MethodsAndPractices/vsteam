using System.Collections.Generic;

namespace vsteam_lib
{
   public class WorkItemTypeValidateAttribute : BaseValidateArgumentsAttribute
   {
      internal override IEnumerable<string> GetValues() => WorkItemTypeCache.GetCurrent();
   }
}
