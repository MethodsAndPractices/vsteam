using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class JobRequest : Leaf
   {
      public JobRequest(PSObject obj) : base(obj, obj.GetValue<string>("owner.Name"), obj.GetValue<string>("requestId"), null)
      {
         this.Type = obj.GetValue<string>("planType");
         this.QueueTime = obj.GetValue<DateTime>("queueTime");
         this.FinishTime = obj.GetValue<DateTime?>("finishTime");
         this.StartTime = obj.GetValue<DateTime?>("receiveTime");
         this.Pipeline = obj.GetValue<string>("definition.name");
         this.AssignedTime = obj.GetValue<DateTime?>("assignTime");
         this.Demands = obj.GetValue<object[]>("demands").Select(o => o.ToString()).ToArray();

         if (!obj.HasValue("result") && !obj.HasValue("assignTime"))
         {
            this.Result = "queued";
         }
         else if (!obj.HasValue("result") && obj.HasValue("assignTime"))
         {
            this.Result = "running";
         }
         else
         {
            this.Result = obj.GetValue<string>("result");
         }

         if (this.FinishTime.HasValue && this.StartTime.HasValue)
         {
            this.Duration = this.FinishTime.Value - this.StartTime.Value;
         }
      }

      public string Type { get; }
      public IEnumerable<string> Demands { get; }
      public DateTime? AssignedTime { get; }
      public DateTime? StartTime { get; }
      public string Pipeline { get; }
      public DateTime? FinishTime { get; }
      public DateTime QueueTime { get; }
      public TimeSpan Duration { get; }
      public string Result { get; }
   }
}
