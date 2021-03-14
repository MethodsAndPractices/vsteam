using System.Collections.Generic;

namespace vsteam_lib
{
   public class TimeZoneValidateAttribute : BaseValidateArgumentsAttribute
   {
      internal override IEnumerable<string> GetValues() => TimeZones.GetTimeZoneIds();
   }

}
