using System.Collections.Generic;

namespace vsteam_lib
{
   public class ProjectValidateAttribute : BaseValidateArgumentsAttribute
   {
      private readonly bool _forceUpdate;

      public ProjectValidateAttribute(bool forceUpdate)
      {
         this._forceUpdate = forceUpdate;
      }

      internal override IEnumerable<string> GetValues() => ProjectCache.GetCurrent(_forceUpdate);
   }
}
