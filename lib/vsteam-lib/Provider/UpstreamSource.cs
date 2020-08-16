using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class UpstreamSource : IInternalObject
   {
      public string ID { get; }
      public string Name { get; }
      public string Status { get; }
      public string Protocol { get; }
      public string Location { get; }
      public string DisplayLocation { get; }
      public string UpstreamSourceType { get; }
      public PSObject InternalObject { get; set; }

      public UpstreamSource(PSObject obj)
      {
         this.InternalObject = obj;
         this.ID = obj.GetValue("id");
         this.Name = obj.GetValue("name");
         this.Status = obj.GetValue("status");
         this.Protocol = obj.GetValue("protocol");
         this.Location = obj.GetValue("location");
         this.DisplayLocation = obj.GetValue("displayLocation");
         this.UpstreamSourceType = obj.GetValue("upstreamSourceType");
      }
   }
}
