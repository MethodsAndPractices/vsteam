using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class JobRequest : Leaf
   {
      [XmlAttribute("planType")]
      public string Type { get; set; }
      public string Result { get; set; }
      [XmlAttribute("definition.name")]
      public string Pipeline { get; set; }
      public TimeSpan Duration { get; }
      public DateTime QueueTime { get; set; }
      [XmlAttribute("receiveTime")]
      public DateTime? StartTime { get; set; }
      public DateTime? FinishTime { get; set; }
      [XmlAttribute("assignTime")]
      public DateTime? AssignedTime { get; set; }
      public IEnumerable<string> Demands { get; }

      public JobRequest(PSObject obj) :
         base(obj, obj.GetValue("owner.Name"), obj.GetValue("requestId"), null)
      {
         this.Demands = obj.GetValue<object[]>("demands").Select(o => o.ToString()).ToArray();

         if (!obj.HasValue("result") && !obj.HasValue("assignTime"))
         {
            this.Result = "queued";
         }
         else if (!obj.HasValue("result") && obj.HasValue("assignTime"))
         {
            this.Result = "running";
         }

         if (this.FinishTime.HasValue)
         {
            this.Duration = this.FinishTime.Value - this.StartTime.Value;
         }
      }
   }
}
