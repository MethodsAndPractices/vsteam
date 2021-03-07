using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class UpstreamSource : IInternalObject
   {
      public string ID { get; set; }
      public string Name { get; set; }
      public string Status { get; set; }
      public string Protocol { get; set; }
      public string Location { get; set; }
      public string DisplayLocation { get; set; }
      public string UpstreamSourceType { get; set; }
      public PSObject InternalObject { get; }

      public UpstreamSource(PSObject obj)
      {
         this.InternalObject = obj;

         Common.MoveProperties(this, obj);
      }
   }
}
