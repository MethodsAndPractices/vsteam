using System;
using System.Management.Automation;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Build : Leaf
   {
      public string Status { get; set; }
      public string Result { get; set; }
      public string BuildNumber { get; set; }
      public DateTime? StartTime { get; set; }
      [XmlAttribute("definition.name")]
      public string BuildDefinition { get; set; }
      public UserEntitlement RequestedBy { get; }
      public UserEntitlement RequestedFor { get; }
      public UserEntitlement LastChangedBy { get; }

      public Build(PSObject obj, string projectName) :
         base(obj, obj.GetValue("buildNumber"), obj.GetValue("Id"), projectName)
      {
         Common.MoveProperties(this, obj);

         this.RequestedBy = new UserEntitlement(obj.GetValue<PSObject>("requestedBy"), projectName);
         this.RequestedFor = new UserEntitlement(obj.GetValue<PSObject>("requestedFor"), projectName);
         this.LastChangedBy = new UserEntitlement(obj.GetValue<PSObject>("lastChangedBy"), projectName);
      }
   }
}
